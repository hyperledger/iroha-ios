//
// Copyright 2021 Soramitsu Co., Ltd.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation
import IrohaSwiftScale

/**
 * Low-level Iroha v2 API client
 */
public final class IrohaApiClient: NSObject, URLSessionWebSocketDelegate {
    
    private lazy var urlSessionConfiguration = URLSessionConfiguration.default
    private lazy var urlSession = URLSession(configuration: urlSessionConfiguration, delegate: self, delegateQueue: OperationQueue())
    private var webSocketTasksByUrls: [URL: URLSessionWebSocketTask] = [:]
    private var webSocketReceiversByUrls: [URL: [WebSocketMessageReceiving]] = [:]
    
    private let baseUrlString: String
    public var wss: Bool
    public var responseQueue: OperationQueue
    
    public init(baseUrlString: String, wss: Bool, responseQueue: OperationQueue) {
        self.baseUrlString = baseUrlString
        self.wss = wss
        self.responseQueue = responseQueue
    }
    
    deinit {
        webSocketTasksByUrls.keys.forEach {
            stopWebSocket(at: $0)
        }
    }
}

// MARK: - URL builder

extension IrohaApiClient {
    
    private func buildUrl(path: String, ws: Bool = false, queryParameters: [String: CustomStringConvertible]? = nil) -> URL? {
        guard var components = URLComponents(string: baseUrlString) else {
            return nil
        }
        
        components.path = path
        if ws {
            components.scheme = wss ? "wss" : "ws"
        }
        
        if let queryParameters = queryParameters, !queryParameters.isEmpty {
            components.queryItems = queryParameters.map { URLQueryItem(name: $0, value: String(describing: $1)) }
        }

        return components.url
    }
}

// MARK: - Plain queries

extension IrohaApiClient {
    
    public func runQuery(
        at path: String,
        queryParameters: [String: CustomStringConvertible]? = nil,
        httpMethod: String,
        body: Data? = nil,
        completion: @escaping (Data?, Int?, Error?) -> Void
    ) {
        
        guard let url = buildUrl(path: path, queryParameters: queryParameters) else {
            completion(nil, nil, IrohaQueryError.internal)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod
        if let body = body {
            urlRequest.httpBody = body
        }
        
        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
            guard let response = response as? HTTPURLResponse else {
                completion(nil, nil, error ?? IrohaQueryError.internal)
                return
            }
            
            let responseCode = response.statusCode
            completion(data, responseCode, error)
        }
        task.resume()
    }
    
    public func runQuery<Query: IrohaQueryProtocol>(
        _ query: Query,
        request: Query.Request,
        completion: @escaping (Result<Query.ResponseValue, Query.ResponseError>
    ) -> Void) {
        
        let body: Data
        do {
            body = try ScaleEncoder().encode(request)
        } catch let error {
            completion(.failure(query.mapError(IrohaQueryError.scale(error))))
            return
        }
        
        runQuery(at: query.path, queryParameters: query.queryParameters, httpMethod: query.httpMethod, body: body) { data, responseCode, error in
            if let responseCode = responseCode {
                if let error = query.statusCodeToErrors[responseCode] {
                    completion(.failure(error))
                    return
                } else if responseCode != 200 {
                    let string = data.map { String(data: $0, encoding: .utf8) } ?? nil
                    completion(.failure(query.mapError(IrohaQueryError.http(responseCode, string))))
                    return
                }
            }
            
            if let data = data {
                do {
                    let response = try ScaleDecoder().decode(Query.ResponseValue.self, from: data)
                    completion(.success(response))
                } catch let error {
                    completion(.failure(query.mapError(IrohaQueryError.scale(error))))
                }

                return
            }

            if let error = error {
                completion(.failure(query.mapError(error)))
            } else {
                completion(.failure(query.mapError(IrohaQueryError.internal)))
            }
        }
    }
}

// MARK: - WebSockets

extension IrohaApiClient {
    
    public func readWebSocket<T: Decodable>(
        at path: String,
        type: T.Type,
        receive: @escaping (Result<T, Error>) -> Void
    ) {
        
        guard let url = buildUrl(path: path, ws: true) else {
            receive(.failure(IrohaQueryError.internal))
            return
        }
        
        openWebSocketIfNeeded(at: url)
        
        if webSocketReceiversByUrls[url] == nil {
            webSocketReceiversByUrls[url] = []
        }
        
        let receiver = WebSocketMessageReceiver(type: type, receiver: receive)
        webSocketReceiversByUrls[url]?.append(receiver)
    }
    
    public func writeWebSocket(
        at path: String,
        value: IrohaDataModelEvents._VersionedEventSocketMessageV1,
        completion: @escaping (Error?) -> Void
    ) {
        
        guard let url = buildUrl(path: path, ws: true) else {
            completion(IrohaQueryError.internal)
            return
        }
        
        let message = IrohaDataModelEvents.VersionedEventSocketMessage.v1(value)
        let data: Data
        do {
            data = try ScaleEncoder().encode(message)
        } catch let error {
            completion(IrohaQueryError.scale(error))
            return
        }
        
        let task = openWebSocketIfNeeded(at: url)
        task.send(.data(data)) { [weak self] error in
            self?.responseQueue.addOperation {
                completion(error)
            }
        }
    }
    
    @discardableResult
    private func openWebSocketIfNeeded(at url: URL) -> URLSessionWebSocketTask {
        if let task = webSocketTasksByUrls[url] {
            return task
        }
        
        let task = urlSession.webSocketTask(with: url)
        webSocketTasksByUrls[url] = task
        task.resume()
        task.receive { [weak self, weak task] message in
            guard let task = task else { return }
            self?.receivedWebSocketMessage(message, for: task)
        }
        
        return task
    }
    
    private func receivedWebSocketMessage(_ message: Result<URLSessionWebSocketTask.Message, Error>, for task: URLSessionWebSocketTask) {
        guard let url = self.webSocketTasksByUrls.first(where: { key, value in
            value == task
        })?.0 else { return }
        
        guard let receivers = self.webSocketReceiversByUrls[url] else { return }
        
        for receiver in receivers {
            responseQueue.addOperation {
                receiver.handle(message: message)
            }
        }
    }
    
    @discardableResult
    public func stopWebSocket(at path: String) -> Bool {
        guard let url = buildUrl(path: path, ws: true) else {
            return false
        }
        
        return stopWebSocket(at: url)
    }
    
    @discardableResult
    private func stopWebSocket(at url: URL) -> Bool {
        guard let task = webSocketTasksByUrls[url] else {
            return false
        }
        
        task.cancel(with: .goingAway, reason: nil)
        
        return webSocketReceiversByUrls.removeValue(forKey: url) != nil && webSocketTasksByUrls.removeValue(forKey: url) != nil
    }
}

private protocol WebSocketMessageReceiving {
    func handle(message: Result<URLSessionWebSocketTask.Message, Error>)
}

private struct WebSocketMessageReceiver<T: Decodable>: WebSocketMessageReceiving {
    let type: T.Type
    let receiver: (Result<T, Error>) -> Void
    
    func handle(message: Result<URLSessionWebSocketTask.Message, Error>) {
        switch message {
        case let .success(message):
            switch message {
            case let .data(data):
                if let event = try? ScaleDecoder().decode(type, from: data) {
                    receiver(.success(event))
                } // else do nothing, probably different event
            default:
                receiver(.failure(IrohaQueryError.internal))
            }
        case let .failure(error):
            receiver(.failure(error))
        }
    }
}

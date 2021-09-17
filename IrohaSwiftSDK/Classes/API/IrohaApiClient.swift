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
public final class IrohaApiClient: NSObject {
    
    private lazy var urlSessionConfiguration = URLSessionConfiguration.default
    private lazy var urlSession = URLSession(configuration: urlSessionConfiguration, delegate: self, delegateQueue: OperationQueue())
    private var webSocketTasksByIds: [String: URLSessionWebSocketTask] = [:]
    private var webSocketClientsByIds: [String: WebSocketClientInternal] = [:]
    
    private let baseUrlString: String
    public var wss: Bool
    public var responseQueue: OperationQueue
    
    public init(baseUrlString: String, wss: Bool, responseQueue: OperationQueue) {
        self.baseUrlString = baseUrlString
        self.wss = wss
        self.responseQueue = responseQueue
    }
    
    deinit {
        webSocketTasksByIds.keys.forEach {
            stopWebSocket(with: $0)
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

extension IrohaApiClient: URLSessionWebSocketDelegate {
    
    public typealias WebSocketClient = WebSocketMessageWriting & Cancellable
    private typealias WebSocketClientInternal = WebSocketClient & WebSocketMessageReceiving & WebSocketTaskDelegate
    
    @discardableResult
    public func openWebSocket<T: Decodable>(
        at path: String,
        type: T.Type,
        receive: @escaping (WebSocketClient, Result<T, Error>) -> Void
    ) -> WebSocketClient? {
        
        guard let url = buildUrl(path: path, ws: true) else {
            return nil
        }
        
        let task = urlSession.webSocketTask(with: url)
        let id = UUID().uuidString
        let onCancel: (WebSocketMessageClient<T>) -> Void = { [weak self] receiver in
            self?.stopWebSocket(with: receiver.id)
        }
        
        let client = WebSocketMessageClient(
            id: id,
            type: type,
            task: task,
            receiver: receive,
            responseQueue: responseQueue,
            onCancel: onCancel
        )
                
        webSocketTasksByIds[id] = task
        webSocketClientsByIds[id] = client
        
        return client
    }
    
    @discardableResult
    private func stopWebSocket(with id: String) -> Bool {
        webSocketClientsByIds.removeValue(forKey: id) != nil || webSocketTasksByIds.removeValue(forKey: id) != nil
    }
    
    public func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        webSocketClientsByIds.values
            .filter { $0.task == webSocketTask }
            .forEach { $0.webSocketTaskDidOpen(with: `protocol`) }
    }

    public func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
        reason: Data?
    ) {
        
        webSocketClientsByIds.values
            .filter { $0.task == webSocketTask }
            .forEach { $0.webSocketTaskDidClose(with: closeCode, reason: reason) }
    }
}

// MARK: - WebSocketMessageReceiving

private protocol WebSocketMessageReceiving {
    func handle(message: Result<URLSessionWebSocketTask.Message, Error>)
}

// MARK: - WebSocketTaskDelegate

private protocol WebSocketTaskDelegate {
    var task: URLSessionWebSocketTask { get }
    
    func webSocketTaskDidOpen(with protocol: String?)
    func webSocketTaskDidClose(with closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?)
}

// MARK: - WebSocketMessageWriting

public protocol WebSocketMessageWriting {
    func write(
        value: IrohaDataModelEvents._VersionedEventSocketMessageV1,
        completion: @escaping (IrohaApiClient.WebSocketClient, Error?) -> Void
    )
}

// MARK: - WebSocketMessageClient

private final class WebSocketMessageClient<T: Decodable> {
    let id: String
    let type: T.Type
    let task: URLSessionWebSocketTask
    let receiver: (IrohaApiClient.WebSocketClient, Result<T, Error>) -> Void
    let responseQueue: OperationQueue
    let onCancel: (WebSocketMessageClient<T>) -> Void
    
    init(
        id: String,
        type: T.Type,
        task: URLSessionWebSocketTask,
        receiver: @escaping (IrohaApiClient.WebSocketClient, Result<T, Error>) -> Void,
        responseQueue: OperationQueue,
        onCancel: @escaping (WebSocketMessageClient<T>) -> Void
    ) {
        
        self.id = id
        self.type = type
        self.task = task
        self.receiver = receiver
        self.responseQueue = responseQueue
        self.onCancel = onCancel
        
        task.resume()
        task.receive { [weak self] in self?.handle(message: $0) }
    }
    
    deinit {
        cancel()
    }
}

// MARK: - WebSocketMessageClient::WebSocketTaskDelegate

extension WebSocketMessageClient: WebSocketTaskDelegate {
    func webSocketTaskDidOpen(with protocol: String?) {}
    func webSocketTaskDidClose(with closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {}
}

// MARK: WebSocketMessageClient::WebSocketMessageWriting

extension WebSocketMessageClient: WebSocketMessageWriting {
    func write(
        value: IrohaDataModelEvents._VersionedEventSocketMessageV1,
        completion: @escaping (IrohaApiClient.WebSocketClient, Error?) -> Void
    ) {
        
        let message = IrohaDataModelEvents.VersionedEventSocketMessage.v1(value)
        let data: Data
        do {
            data = try ScaleEncoder().encode(message)
        } catch let error {
            completion(self, IrohaQueryError.scale(error))
            return
        }
        
        task.send(.data(data)) { [weak self] error in
            guard let self = self else { return }
            self.responseQueue.addOperation {
                completion(self, error)
            }
        }
    }
}

// MARK: - WebSocketMessageClient::WebSocketMessageReceiving

extension WebSocketMessageClient: WebSocketMessageReceiving {
    func handle(message: Result<URLSessionWebSocketTask.Message, Error>) {
        switch message {
        case let .success(message):
            switch message {
            case let .data(data):
                do {
                    let event = try ScaleDecoder().decode(type, from: data)
                    responseQueue.addOperation {
                        self.receiver(self, .success(event))
                    }
                } catch let error {
                    responseQueue.addOperation {
                        self.receiver(self, .failure(IrohaQueryError.scale(error)))
                    }
                }
                task.receive { [weak self] in self?.handle(message: $0) }
            default:
                responseQueue.addOperation {
                    self.receiver(self, .failure(IrohaQueryError.internal))
                }
            }
        case let .failure(error):
            responseQueue.addOperation {
                self.receiver(self, .failure(error))
            }
        }
    }
}

extension WebSocketMessageClient: Cancellable {
    func cancel() {
        task.cancel(with: .goingAway, reason: nil)
        onCancel(self)
    }
}

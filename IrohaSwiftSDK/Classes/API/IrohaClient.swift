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

import IrohaSwiftScale
import Foundation

public enum IrohaClientError: Swift.Error {
    case invalidResponse
    case webSocketNotEstablished
}

/**
 * High-level Iroha V2 client
 */
public final class IrohaClient {
    
    // MARK: - Config
    
    public var debug = false {
        didSet { apiClient.wss = !debug }
    }
    
    public var responseQueue = OperationQueue.main {
        didSet { apiClient.responseQueue = responseQueue }
    }
    
    public var ttl: TimeInterval = 100
    
    // MARK: - Init
    
    private let serverUrlString: String
    public let account: IrohaAccount
    
    private lazy var apiClient = IrohaApiClient(baseUrlString: serverUrlString, wss: !debug, responseQueue: responseQueue)
    
    public init(serverUrlString: String, account: IrohaAccount) {
        self.serverUrlString = serverUrlString
        self.account = account
    }
}

// MARK: - Submit instructions

extension IrohaClient {
    
    public func submitInstructions(
        _ instructions: [IrohaDataModelIsi.Instruction],
        completion: @escaping (IrohaDataModelTransaction.Transaction?, Error?) -> Void
    ) {
        
        let payload = IrohaDataModelTransaction.Payload(
            accountId: account.id,
            executable: .instructions(instructions),
            creationTime: Date().milliseconds,
            timeToLiveMs: ttl.milliseconds,
            nonce: UInt32.random(in: 0...UInt32.max)
        )

        do {
            let signature = try IrohaCrypto.Signature(signing: payload, with: account.keyPair)
            let transaction = IrohaDataModelTransaction.Transaction(payload: payload, signatures: [signature])
            apiClient.runQuery(SubmitInstructions(), request: .v1(transaction)) { response in
                switch response {
                case let .failure(error):
                    completion(transaction, error)
                default:
                    completion(transaction, nil)
                }
            }
        } catch let error {
            completion(nil, error)
        }
    }
    
    public func submitInstruction(
        _ instruction: IrohaDataModelIsi.Instruction,
        completion: @escaping (IrohaDataModelTransaction.Transaction?, Error?) -> Void
    ) {
     
        submitInstructions([instruction]) {
            completion($0, $1)
        }
    }
}

// MARK: - Submit query

extension IrohaClient {
    
    public func submitQuery(
        _ queryBox: IrohaDataModelQuery.QueryBox,
        from date: Date,
        start: Int? = nil,
        limit: Int? = nil,
        completion: @escaping (IrohaDataModelQuery.QueryResult?, Error?) -> Void
    ) {
        
        let timestampMs = MyUint128(uint64: UInt64(date.milliseconds))
        let payload = IrohaDataModelQuery.Payload(timestampMs: timestampMs, query: queryBox, accountId: account.id)
        
        guard let signature = try? IrohaCrypto.Signature(signing: payload, with: account.keyPair) else {
            completion(nil, IrohaQueryError.signingFailure)
            return
        }
        
        let query = IrohaDataModelQuery.SignedQueryRequest(payload: payload, signature: signature)
        
        apiClient.runQuery(SubmitQuery(start: start, limit: limit), request: .v1(query)) { response in
            switch response {
            case let .success(result):
                completion(result, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }
}

// MARK: - Events listening

extension IrohaClient {
    
    private func receiveEvents(
        eventsFilter: IrohaDataModelEvents.EventFilter,
        eventHandler: @escaping (IrohaDataModelEvents.Event) -> Void,
        subscriptionAcceptedHandler: (() -> Void)? = nil,
        errorHandler: ((Error) -> Void)? = nil
    ) {
        
        let eventsPath = "/events"
        
        let internalErrorHandler: (IrohaApiClient.WebSocketClient, Error?) -> Void = {
            if let error = $1 {
                $0.cancel()
                errorHandler?(error)
            }
        }
        
        let client = apiClient.openWebSocket(at: eventsPath, type: IrohaDataModelEvents.VersionedEventSocketMessage.self) { client, result in
            switch result {
            case let .success(versioned):
                switch versioned {
                case let .v1(message):
                    switch message {
                    case .subscriptionAccepted:
                        subscriptionAcceptedHandler?()
                    case let .event(event):
                        client.write(value: .eventReceived, completion: internalErrorHandler)
                        eventHandler(event)
                    default:
                        break // do nothing
                    }
                }
            case let .failure(error):
                internalErrorHandler(client, error)
            }
        }
        
        guard let client = client else {
            errorHandler?(IrohaClientError.webSocketNotEstablished)
            return
        }
        
        client.write(value: .subscriptionRequest(eventsFilter), completion: internalErrorHandler)
    }
    
    public func receivePipelineEvents(
        entityFilter: IrohaDataModelEventsPipeline.EntityType? = nil,
        hashFilter: IrohaCrypto.Hash? = nil,
        eventsHandler: @escaping (IrohaDataModelEventsPipeline.Event) -> Void,
        subscriptionAcceptedHandler: (() -> Void)? = nil,
        errorHandler: ((Error) -> Void)? = nil
    ) {
        
        let eventsFilter = IrohaDataModelEventsPipeline.EventFilter(entity: entityFilter, hash: hashFilter)
        let eventHandler: (IrohaDataModelEvents.Event) -> Void = {
            switch $0 {
            case let .pipeline(event):
                eventsHandler(event)
            default:
                break
            }
        }
        
        receiveEvents(eventsFilter: .pipeline(eventsFilter),
                      eventHandler: eventHandler,
                      subscriptionAcceptedHandler: subscriptionAcceptedHandler,
                      errorHandler: errorHandler)
    }
    
    public func receiveDataEvents(
        eventsHandler: @escaping (IrohaDataModelEventsData.Event) -> Void,
        subscriptionAcceptedHandler: (() -> Void)? = nil,
        errorHandler: ((Error) -> Void)? = nil
    ) {
        
        let eventsFilter = IrohaDataModelEventsData.EventFilter()
        let eventHandler: (IrohaDataModelEvents.Event) -> Void = {
            switch $0 {
            case let .data(event):
                eventsHandler(event)
            default:
                break
            }
        }
        
        receiveEvents(eventsFilter: .data(eventsFilter),
                      eventHandler: eventHandler,
                      subscriptionAcceptedHandler: subscriptionAcceptedHandler,
                      errorHandler: errorHandler)
    }
}

// MARK: - Health

extension IrohaClient {
    
    public func health(_ completion: @escaping (String?, Error?) -> Void) {
        apiClient.runQuery(at: "/health", httpMethod: "GET") { data, responseCode, error in
            guard let responseCode = responseCode else {
                completion(nil, IrohaQueryError.httpFailure)
                return
            }
            
            guard responseCode == 200 else {
                let body = data.map { String(data: $0, encoding: .utf8) }
                completion(nil, IrohaQueryError.http(responseCode, body ?? nil))
                return
            }
            
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments), let string = json as? String {
                completion(string, nil)
            } else {
                // Currently iroha2 server returns nil string
                completion(nil, nil)
            }
        }
    }
}

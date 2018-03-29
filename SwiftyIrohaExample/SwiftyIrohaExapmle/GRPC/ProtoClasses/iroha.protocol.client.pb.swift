/*
 * DO NOT EDIT.
 *
 * Generated by the protocol buffer compiler.
 * Source: endpoint.proto
 *
 */

/*
 * Copyright 2017, gRPC Authors All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import Foundation
import Dispatch
import gRPC
import SwiftProtobuf

/// Type for errors thrown from generated client code.
internal enum Iroha_Protocol_CommandServiceClientError : Error {
  case endOfStream
  case invalidMessageReceived
  case error(c: CallResult)
}

/// Torii (Unary)
internal class Iroha_Protocol_CommandServiceToriiCall {
  private var call : Call

  /// Create a call.
  fileprivate init(_ channel: Channel) {
    self.call = channel.makeCall("/iroha.protocol.CommandService/Torii")
  }

  /// Run the call. Blocks until the reply is received.
  fileprivate func run(request: Iroha_Protocol_Transaction,
                       metadata: Metadata) throws -> Google_Protobuf_Empty {
    let sem = DispatchSemaphore(value: 0)
    var returnCallResult : CallResult!
    var returnResponse : Google_Protobuf_Empty?
    _ = try start(request:request, metadata:metadata) {response, callResult in
      returnResponse = response
      returnCallResult = callResult
      sem.signal()
    }
    _ = sem.wait(timeout: DispatchTime.distantFuture)
    if let returnResponse = returnResponse {
      return returnResponse
    } else {
      throw Iroha_Protocol_CommandServiceClientError.error(c: returnCallResult)
    }
  }

  /// Start the call. Nonblocking.
  fileprivate func start(request: Iroha_Protocol_Transaction,
                         metadata: Metadata,
                         completion: @escaping (Google_Protobuf_Empty?, CallResult)->())
    throws -> Iroha_Protocol_CommandServiceToriiCall {

      let requestData = try request.serializedData()
      try call.start(.unary,
                     metadata:metadata,
                     message:requestData)
      {(callResult) in
        if let responseData = callResult.resultData,
          let response = try? Google_Protobuf_Empty(serializedData:responseData) {
          completion(response, callResult)
        } else {
          completion(nil, callResult)
        }
      }
      return self
  }
}

/// Status (Unary)
internal class Iroha_Protocol_CommandServiceStatusCall {
  private var call : Call

  /// Create a call.
  fileprivate init(_ channel: Channel) {
    self.call = channel.makeCall("/iroha.protocol.CommandService/Status")
  }

  /// Run the call. Blocks until the reply is received.
  fileprivate func run(request: Iroha_Protocol_TxStatusRequest,
                       metadata: Metadata) throws -> Iroha_Protocol_ToriiResponse {
    let sem = DispatchSemaphore(value: 0)
    var returnCallResult : CallResult!
    var returnResponse : Iroha_Protocol_ToriiResponse?
    _ = try start(request:request, metadata:metadata) {response, callResult in
      returnResponse = response
      returnCallResult = callResult
      sem.signal()
    }
    _ = sem.wait(timeout: DispatchTime.distantFuture)
    if let returnResponse = returnResponse {
      return returnResponse
    } else {
      throw Iroha_Protocol_CommandServiceClientError.error(c: returnCallResult)
    }
  }

  /// Start the call. Nonblocking.
  fileprivate func start(request: Iroha_Protocol_TxStatusRequest,
                         metadata: Metadata,
                         completion: @escaping (Iroha_Protocol_ToriiResponse?, CallResult)->())
    throws -> Iroha_Protocol_CommandServiceStatusCall {

      let requestData = try request.serializedData()
      try call.start(.unary,
                     metadata:metadata,
                     message:requestData)
      {(callResult) in
        if let responseData = callResult.resultData,
          let response = try? Iroha_Protocol_ToriiResponse(serializedData:responseData) {
          completion(response, callResult)
        } else {
          completion(nil, callResult)
        }
      }
      return self
  }
}

/// Call methods of this class to make API calls.
internal class Iroha_Protocol_CommandServiceService {
  private var channel: Channel

  /// This metadata will be sent with all requests.
  internal var metadata : Metadata

  /// This property allows the service host name to be overridden.
  /// For example, it can be used to make calls to "localhost:8080"
  /// appear to be to "example.com".
  internal var host : String {
    get {
      return self.channel.host
    }
    set {
      self.channel.host = newValue
    }
  }

  /// Create a client that makes insecure connections.
  internal init(address: String) {
    gRPC.initialize()
    channel = Channel(address:address, secure: false)
    metadata = Metadata()
  }

  /// Create a client that makes secure connections.
  internal init(address: String, certificates: String?, host: String?) {
    gRPC.initialize()
    channel = Channel(address:address, certificates:certificates!, host:host)
    metadata = Metadata()
  }

  /// Synchronous. Unary.
  internal func torii(_ request: Iroha_Protocol_Transaction)
    throws
    -> Google_Protobuf_Empty {
      return try Iroha_Protocol_CommandServiceToriiCall(channel).run(request:request, metadata:metadata)
  }
  /// Asynchronous. Unary.
  internal func torii(_ request: Iroha_Protocol_Transaction,
                  completion: @escaping (Google_Protobuf_Empty?, CallResult)->())
    throws
    -> Iroha_Protocol_CommandServiceToriiCall {
      return try Iroha_Protocol_CommandServiceToriiCall(channel).start(request:request,
                                                 metadata:metadata,
                                                 completion:completion)
  }
  /// Synchronous. Unary.
  internal func status(_ request: Iroha_Protocol_TxStatusRequest)
    throws
    -> Iroha_Protocol_ToriiResponse {
      return try Iroha_Protocol_CommandServiceStatusCall(channel).run(request:request, metadata:metadata)
  }
  /// Asynchronous. Unary.
  internal func status(_ request: Iroha_Protocol_TxStatusRequest,
                  completion: @escaping (Iroha_Protocol_ToriiResponse?, CallResult)->())
    throws
    -> Iroha_Protocol_CommandServiceStatusCall {
      return try Iroha_Protocol_CommandServiceStatusCall(channel).start(request:request,
                                                 metadata:metadata,
                                                 completion:completion)
  }
}

/// Type for errors thrown from generated client code.
internal enum Iroha_Protocol_QueryServiceClientError : Error {
  case endOfStream
  case invalidMessageReceived
  case error(c: CallResult)
}

/// Find (Unary)
internal class Iroha_Protocol_QueryServiceFindCall {
  private var call : Call

  /// Create a call.
  fileprivate init(_ channel: Channel) {
    self.call = channel.makeCall("/iroha.protocol.QueryService/Find")
  }

  /// Run the call. Blocks until the reply is received.
  fileprivate func run(request: Iroha_Protocol_Query,
                       metadata: Metadata) throws -> Iroha_Protocol_QueryResponse {
    let sem = DispatchSemaphore(value: 0)
    var returnCallResult : CallResult!
    var returnResponse : Iroha_Protocol_QueryResponse?
    _ = try start(request:request, metadata:metadata) {response, callResult in
      returnResponse = response
      returnCallResult = callResult
      sem.signal()
    }
    _ = sem.wait(timeout: DispatchTime.distantFuture)
    if let returnResponse = returnResponse {
      return returnResponse
    } else {
      throw Iroha_Protocol_QueryServiceClientError.error(c: returnCallResult)
    }
  }

  /// Start the call. Nonblocking.
  fileprivate func start(request: Iroha_Protocol_Query,
                         metadata: Metadata,
                         completion: @escaping (Iroha_Protocol_QueryResponse?, CallResult)->())
    throws -> Iroha_Protocol_QueryServiceFindCall {

      let requestData = try request.serializedData()
      try call.start(.unary,
                     metadata:metadata,
                     message:requestData)
      {(callResult) in
        if let responseData = callResult.resultData,
          let response = try? Iroha_Protocol_QueryResponse(serializedData:responseData) {
          completion(response, callResult)
        } else {
          completion(nil, callResult)
        }
      }
      return self
  }
}

/// Call methods of this class to make API calls.
internal class Iroha_Protocol_QueryServiceService {
  private var channel: Channel

  /// This metadata will be sent with all requests.
  internal var metadata : Metadata

  /// This property allows the service host name to be overridden.
  /// For example, it can be used to make calls to "localhost:8080"
  /// appear to be to "example.com".
  internal var host : String {
    get {
      return self.channel.host
    }
    set {
      self.channel.host = newValue
    }
  }

  /// Create a client that makes insecure connections.
  internal init(address: String) {
    gRPC.initialize()
    channel = Channel(address:address, secure: false)
    metadata = Metadata()
  }

  /// Create a client that makes secure connections.
  internal init(address: String, certificates: String?, host: String?) {
    gRPC.initialize()
    channel = Channel(address:address, certificates:certificates!, host:host)
    metadata = Metadata()
  }

  /// Synchronous. Unary.
  internal func find(_ request: Iroha_Protocol_Query)
    throws
    -> Iroha_Protocol_QueryResponse {
      return try Iroha_Protocol_QueryServiceFindCall(channel).run(request:request, metadata:metadata)
  }
  /// Asynchronous. Unary.
  internal func find(_ request: Iroha_Protocol_Query,
                  completion: @escaping (Iroha_Protocol_QueryResponse?, CallResult)->())
    throws
    -> Iroha_Protocol_QueryServiceFindCall {
      return try Iroha_Protocol_QueryServiceFindCall(channel).start(request:request,
                                                 metadata:metadata,
                                                 completion:completion)
  }
}

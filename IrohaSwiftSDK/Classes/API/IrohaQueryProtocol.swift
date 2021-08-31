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

public protocol IrohaQueryProtocol {
    associatedtype Request: Encodable
    associatedtype ResponseValue: Decodable
    associatedtype ResponseError: Swift.Error
    
    typealias Response = Swift.Result<ResponseValue, ResponseError>
    
    var path: String { get }
    var httpMethod: String { get }
    var queryParameters: [String: CustomStringConvertible] { get }
    
    var statusCodeToErrors: [Int: ResponseError] { get }
    func mapError(_ error: Swift.Error) -> ResponseError
    
    func encodeRequest(_ request: Request) throws -> Data
    func decodeResponse(_ data: Data) throws -> ResponseValue
}

enum IrohaQueryError: Swift.Error {
    case `internal`
    case signingFailure
    case scale(Swift.Error)
    case httpFailure
    case http(Int, String?)
}

// MARK: - Scale coding

protocol IrohaQueryScaleCoding: IrohaQueryProtocol {}

extension IrohaQueryScaleCoding {
    func encodeRequest(_ request: Request) throws -> Data {
        try ScaleEncoder().encode(request)
    }
    
    func decodeResponse(_ data: Data) throws -> ResponseValue {
        try ScaleDecoder().decode(ResponseValue.self, from: data)
    }
}

// MARK: - JSON coding

protocol IrohaQueryJsonCoding: IrohaQueryProtocol {}

extension IrohaQueryJsonCoding {
    func encodeRequest(_ request: Request) throws -> Data {
        try JSONEncoder().encode(request)
    }
    
    func decodeResponse(_ data: Data) throws -> ResponseValue {
        try JSONDecoder().decode(ResponseValue.self, from: data)
    }
}


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

extension IrohaDataModel {
public indirect enum Parameter: Codable {
    
    case maximumFaultyPeersAmount(UInt32)
    case blockTime(UInt128)
    case commitTime(UInt128)
    case transactionReceiptTime(UInt128)
    
    // MARK: - For Codable purpose
    
    static func index(of case: Self) -> Int {
        switch `case` {
            case .maximumFaultyPeersAmount:
                return 0
            case .blockTime:
                return 1
            case .commitTime:
                return 2
            case .transactionReceiptTime:
                return 3
        }
    }
    
    // MARK: - Decodable
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let index = try container.decode(Int.self)
        switch index {
        case 0:
            let val0 = try container.decode(UInt32.self)
            self = .maximumFaultyPeersAmount(val0)
            break
        case 1:
            let val0 = try container.decode(UInt128.self)
            self = .blockTime(val0)
            break
        case 2:
            let val0 = try container.decode(UInt128.self)
            self = .commitTime(val0)
            break
        case 3:
            let val0 = try container.decode(UInt128.self)
            self = .transactionReceiptTime(val0)
            break
        default:
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown index \(index)")
        }
    }
    
    // MARK: - Encodable
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(Parameter.index(of: self))
        switch self {
        case let .maximumFaultyPeersAmount(val0):
            try container.encode(val0)
            break
        case let .blockTime(val0):
            try container.encode(val0)
            break
        case let .commitTime(val0):
            try container.encode(val0)
            break
        case let .transactionReceiptTime(val0):
            try container.encode(val0)
            break
        }
    }
}
}
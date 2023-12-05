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

extension IrohaDataModelTransaction {
    public indirect enum TransactionValue: Swift.Codable {
        case transaction(IrohaDataModelTransaction.VersionedTransaction)
        case rejectedTransaction(IrohaDataModelTransaction.VersionedRejectedTransaction)
        
        // MARK: - For Codable purpose
        
        static func discriminant(of case: Self) -> UInt8 {
            switch `case` {
            case .transaction:
                return 0
            case .rejectedTransaction:
                return 1
            }
        }
        
        // MARK: - Decodable
        
        public init(from decoder: Swift.Decoder) throws {
            var container = try decoder.unkeyedContainer()
            let discriminant = try container.decode(UInt8.self)
            switch discriminant {
            case 0:
                let val0 = try container.decode(IrohaDataModelTransaction.VersionedTransaction.self)
                self = .transaction(val0)
                break
            case 1:
                let val0 = try container.decode(IrohaDataModelTransaction.VersionedRejectedTransaction.self)
                self = .rejectedTransaction(val0)
                break
            default:
                throw Swift.DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown discriminant \(discriminant)")
            }
        }
        
        // MARK: - Encodable
        
        public func encode(to encoder: Swift.Encoder) throws {
            var container = encoder.unkeyedContainer()
            try container.encode(TransactionValue.discriminant(of: self))
            switch self {
            case let .transaction(val0):
                try container.encode(val0)
                break
            case let .rejectedTransaction(val0):
                try container.encode(val0)
                break
            }
        }
    }
}
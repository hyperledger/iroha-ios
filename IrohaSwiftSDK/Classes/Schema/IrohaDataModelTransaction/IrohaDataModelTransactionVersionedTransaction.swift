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
    public indirect enum VersionedTransaction: Swift.Codable {
        case v1(IrohaDataModelTransaction._VersionedTransactionV1)
        
        // MARK: - For Codable purpose
        
        static func discriminant(of case: Self) -> UInt8 {
            switch `case` {
            case .v1:
                return 1
            }
        }
        
        // MARK: - Decodable
        
        public init(from decoder: Swift.Decoder) throws {
            var container = try decoder.unkeyedContainer()
            let discriminant = try container.decode(UInt8.self)
            switch discriminant {
            case 1:
                let val0 = try container.decode(IrohaDataModelTransaction._VersionedTransactionV1.self)
                self = .v1(val0)
                break
            default:
                throw Swift.DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown discriminant \(discriminant)")
            }
        }
        
        // MARK: - Encodable
        
        public func encode(to encoder: Swift.Encoder) throws {
            var container = encoder.unkeyedContainer()
            try container.encode(VersionedTransaction.discriminant(of: self))
            switch self {
            case let .v1(val0):
                try container.encode(val0)
                break
            }
        }
    }
}
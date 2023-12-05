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

extension IrohaDataModelEventsPipeline {
    public indirect enum RejectionReason: Swift.Codable {
        case block(IrohaDataModelEventsPipeline.BlockRejectionReason)
        case transaction(IrohaDataModelEventsPipeline.TransactionRejectionReason)
        
        // MARK: - For Codable purpose
        
        static func discriminant(of case: Self) -> UInt8 {
            switch `case` {
            case .block:
                return 0
            case .transaction:
                return 1
            }
        }
        
        // MARK: - Decodable
        
        public init(from decoder: Swift.Decoder) throws {
            var container = try decoder.unkeyedContainer()
            let discriminant = try container.decode(UInt8.self)
            switch discriminant {
            case 0:
                let val0 = try container.decode(IrohaDataModelEventsPipeline.BlockRejectionReason.self)
                self = .block(val0)
                break
            case 1:
                let val0 = try container.decode(IrohaDataModelEventsPipeline.TransactionRejectionReason.self)
                self = .transaction(val0)
                break
            default:
                throw Swift.DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown discriminant \(discriminant)")
            }
        }
        
        // MARK: - Encodable
        
        public func encode(to encoder: Swift.Encoder) throws {
            var container = encoder.unkeyedContainer()
            try container.encode(RejectionReason.discriminant(of: self))
            switch self {
            case let .block(val0):
                try container.encode(val0)
                break
            case let .transaction(val0):
                try container.encode(val0)
                break
            }
        }
    }
}
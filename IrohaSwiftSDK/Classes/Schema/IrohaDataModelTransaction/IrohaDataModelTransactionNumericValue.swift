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
    public indirect enum NumericValue: Codable {
        
        case u32(UInt32)
        case u64(UInt64)
        case u128(MyUint128)
        case fixed(Double)
        
        // MARK: - For Codable purpose
        
        static func discriminant(of case: Self) -> UInt8 {
            switch `case` {
                case .u32:
                    return 0
                case .u64:
                    return 1
                case .u128:
                    return 2
                case .fixed:
                    return 3
            }
        }
        
        // MARK: - Decodable
        
        public init(from decoder: Decoder) throws {
            var container = try decoder.unkeyedContainer()
            let discriminant = try container.decode(UInt8.self)
            switch discriminant {
            case 0:
                let val0 = try container.decode(UInt32.self)
                self = .u32(val0)
                break
            case 1:
                let val0 = try container.decode(UInt64.self)
                self = .u64(val0)
                break
            case 2:
                let val0 = try container.decode(MyUint128.self)
                self = .u128(val0)
                break
            case 3:
                let val0 = try container.decode(Double.self)
                self = .fixed(val0)
                break
            default:
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown discriminant \(discriminant)")
            }
        }
        
        // MARK: - Encodable
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.unkeyedContainer()
            try container.encode(NumericValue.discriminant(of: self))
            switch self {
            case let .u32(val0):
                try container.encode(val0)
                break
            case let .u64(val0):
                try container.encode(val0)
                break
            case let .u128(val0):
                try container.encode(val0)
                break
            case let .fixed(val0):
                let scale: Double = 1_000_000_000
                let correct = UInt64(val0 * scale)
                try container.encode(correct)
                break
            }
        }
    }
}

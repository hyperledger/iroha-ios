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
import ScaleCodec

extension IrohaDataModelTransaction {
    public indirect enum NumericValue: Swift.Codable {
        
        case u32(UInt32)
        case u64(UInt64)
        case u128(ScaleCodec.UInt128)
        case fixed(Int64)
        
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
        
        public init(from decoder: Swift.Decoder) throws {
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
                fatalError("Incorrect")
                break
            case 3:
                let val0 = try container.decode(Int64.self)
                self = .fixed(val0)
                break
            default:
                throw Swift.DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown discriminant \(discriminant)")
            }
        }
        
        // MARK: - Encodable
        
        public func encode(to encoder: Swift.Encoder) throws {
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
                fatalError("Incorrect")
                break
            case let .fixed(val0):
                try container.encode(val0)
                break
            }
        }
    }
}

extension IrohaDataModelTransaction.NumericValue: ScaleCodec.Encodable {
    public func encode<E>(in encoder: inout E) throws where E : Encoder {
        try encoder.encode(Self.discriminant(of: self))
        switch self {
        case let .u32(val0):
            try encoder.encode(val0)
            break
        case let .u128(val0):
            try encoder.encode(val0)
        case let .fixed(val0):
            let data = withUnsafeBytes(of: val0) { Data($0) }
            try encoder.encode(data, .fixed(9))
        default:
            // todo: доделать
            break
        }
    }
}

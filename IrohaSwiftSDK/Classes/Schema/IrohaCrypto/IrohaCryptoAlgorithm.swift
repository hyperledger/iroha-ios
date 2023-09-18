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

extension IrohaCrypto {
    public indirect enum Algorithm: Codable {
        
        case ed25519
        case secp256k1
        case blsNormal
        case blsSmall
        
        // MARK: - For Codable purpose
        
        static func discriminant(of case: Self) -> UInt8 {
            switch `case` {
                case .ed25519:
                    return 0
                case .secp256k1:
                    return 1
                case .blsNormal:
                    return 2
                case .blsSmall:
                    return 3
            }
        }
        
        // MARK: - Decodable
        
        public init(from decoder: Decoder) throws {
            var container = try decoder.unkeyedContainer()
            let discriminant = try container.decode(UInt8.self)
            switch discriminant {
            case 0:
                
                self = .ed25519
                break
            case 1:
                
                self = .secp256k1
                break
            case 2:
                
                self = .blsNormal
                break
            case 3:
                
                self = .blsSmall
                break
            default:
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown discriminant \(discriminant)")
            }
        }
        
        // MARK: - Encodable
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.unkeyedContainer()
            try container.encode(Self.discriminant(of: self))
            switch self {
            case .ed25519:
                
                break
            case .secp256k1:
                
                break
            case .blsNormal:
                
                break
            case .blsSmall:
                
                break
            }
        }
    }
}

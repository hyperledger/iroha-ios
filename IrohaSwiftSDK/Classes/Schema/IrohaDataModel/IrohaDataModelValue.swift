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
    public indirect enum Value: Codable {
        
        case bool(Bool)
        case string(String)
        case name(String)
        case vec([IrohaDataModel.Value])
        case id(IrohaDataModel.IdBox)
        case identifiable(IrohaDataModel.IdentifiableBox)
        case publicKey(IrohaCrypto.PublicKey)
        case signatureCheckCondition(IrohaDataModelAccount.SignatureCheckCondition)
        case transactionValue(IrohaDataModelTransaction.TransactionValue)
        case permissionToken(IrohaDataModelPermissions.PermissionToken)
        case numeric(IrohaDataModelTransaction.NumericValue)
        
        // MARK: - For Codable purpose
        
        static func discriminant(of case: Self) -> UInt8 {
            switch `case` {
                case .bool:
                    return 0
                case .string:
                    return 1
                case .name:
                    return 2
                case .vec:
                    return 3
                case .id:
                    return 8
                case .identifiable:
                    return 9
                case .publicKey:
                    return 10
                case .signatureCheckCondition:
                    return 11
                case .transactionValue:
                    return 12
                case .permissionToken:
                    return 14
                case .numeric:
                    return 20
            }
        }
        
        // MARK: - Decodable
        
        public init(from decoder: Swift.Decoder) throws {
            var container = try decoder.unkeyedContainer()
            let discriminant = try container.decode(UInt8.self)
            switch discriminant {
            case 0:
                let val0 = try container.decode(Bool.self)
                self = .bool(val0)
                break
            case 1:
                let val0 = try container.decode(String.self)
                self = .string(val0)
                break
            case 2:
                let val0 = try container.decode(String.self)
                self = .name(val0)
                break
            case 3:
                let val0 = try container.decode([IrohaDataModel.Value].self)
                self = .vec(val0)
                break
            case 8:
                let val0 = try container.decode(IrohaDataModel.IdBox.self)
                self = .id(val0)
                break
            case 9:
                let val0 = try container.decode(IrohaDataModel.IdentifiableBox.self)
                self = .identifiable(val0)
                break
            case 10:
                let val0 = try container.decode(IrohaCrypto.PublicKey.self)
                self = .publicKey(val0)
                break
            case 11:
                let val0 = try container.decode(IrohaDataModelAccount.SignatureCheckCondition.self)
                self = .signatureCheckCondition(val0)
                break
            case 12:
                let val0 = try container.decode(IrohaDataModelTransaction.TransactionValue.self)
                self = .transactionValue(val0)
                break
            case 14:
                let val0 = try container.decode(IrohaDataModelPermissions.PermissionToken.self)
                self = .permissionToken(val0)
                break
            case 20:
                let val0 = try container.decode(IrohaDataModelTransaction.NumericValue.self)
                self = .numeric(val0)
                break
            default:
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown discriminant \(discriminant)")
            }
        }
        
        // MARK: - Encodable
        
        public func encode(to encoder: Swift.Encoder) throws {
            var container = encoder.unkeyedContainer()
            try container.encode(Value.discriminant(of: self))
            switch self {
            case let .bool(val0):
                try container.encode(val0)
                break
            case let .string(val0):
                try container.encode(val0)
                break
            case let .name(val0):
                try container.encode(val0)
                break
            case let .vec(val0):
                try container.encode(val0)
                break
            case let .id(val0):
                try container.encode(val0)
                break
            case let .identifiable(val0):
                try container.encode(val0)
                break
            case let .publicKey(val0):
                try container.encode(val0)
                break
            case let .signatureCheckCondition(val0):
                try container.encode(val0)
                break
            case let .transactionValue(val0):
                try container.encode(val0)
                break
            case let .permissionToken(val0):
                try container.encode(val0)
                break
            case let .numeric(val0):
                try container.encode(val0)
                break
            }
        }
    }
}

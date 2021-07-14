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
    
    case u32(UInt32)
    case bool(Bool)
    case string(String)
    case vec([IrohaDataModel.Value])
    case id(IrohaDataModel.IdBox)
    case identifiable(IrohaDataModel.IdentifiableBox)
    case publicKey(IrohaCrypto.PublicKey)
    case parameter(IrohaDataModel.Parameter)
    case signatureCheckCondition(IrohaDataModelAccount.SignatureCheckCondition)
    case transactionValue(IrohaDataModelTransaction.TransactionValue)
    case permissionToken(IrohaDataModelPermissions.PermissionToken)
    
    // MARK: - For Codable purpose
    
    static func index(of case: Self) -> Int {
        switch `case` {
            case .u32:
                return 0
            case .bool:
                return 1
            case .string:
                return 2
            case .vec:
                return 3
            case .id:
                return 4
            case .identifiable:
                return 5
            case .publicKey:
                return 6
            case .parameter:
                return 7
            case .signatureCheckCondition:
                return 8
            case .transactionValue:
                return 9
            case .permissionToken:
                return 10
        }
    }
    
    // MARK: - Decodable
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let index = try container.decode(Int.self)
        switch index {
        case 0:
            let val0 = try container.decode(UInt32.self)
            self = .u32(val0)
            break
        case 1:
            let val0 = try container.decode(Bool.self)
            self = .bool(val0)
            break
        case 2:
            let val0 = try container.decode(String.self)
            self = .string(val0)
            break
        case 3:
            let val0 = try container.decode([IrohaDataModel.Value].self)
            self = .vec(val0)
            break
        case 4:
            let val0 = try container.decode(IrohaDataModel.IdBox.self)
            self = .id(val0)
            break
        case 5:
            let val0 = try container.decode(IrohaDataModel.IdentifiableBox.self)
            self = .identifiable(val0)
            break
        case 6:
            let val0 = try container.decode(IrohaCrypto.PublicKey.self)
            self = .publicKey(val0)
            break
        case 7:
            let val0 = try container.decode(IrohaDataModel.Parameter.self)
            self = .parameter(val0)
            break
        case 8:
            let val0 = try container.decode(IrohaDataModelAccount.SignatureCheckCondition.self)
            self = .signatureCheckCondition(val0)
            break
        case 9:
            let val0 = try container.decode(IrohaDataModelTransaction.TransactionValue.self)
            self = .transactionValue(val0)
            break
        case 10:
            let val0 = try container.decode(IrohaDataModelPermissions.PermissionToken.self)
            self = .permissionToken(val0)
            break
        default:
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown index \(index)")
        }
    }
    
    // MARK: - Encodable
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(Value.index(of: self))
        switch self {
        case let .u32(val0):
            try container.encode(val0)
            break
        case let .bool(val0):
            try container.encode(val0)
            break
        case let .string(val0):
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
        case let .parameter(val0):
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
        }
    }
}
}
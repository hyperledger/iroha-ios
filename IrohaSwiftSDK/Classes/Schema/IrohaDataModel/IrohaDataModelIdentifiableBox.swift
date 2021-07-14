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
public indirect enum IdentifiableBox: Codable {
    
    case account(IrohaDataModelAccount.Account)
    case newAccount(IrohaDataModelAccount.NewAccount)
    case asset(IrohaDataModelAsset.Asset)
    case assetDefinition(IrohaDataModelAsset.AssetDefinition)
    case domain(IrohaDataModelDomain.Domain)
    case peer(IrohaDataModelPeer.Peer)
    case world
    
    // MARK: - For Codable purpose
    
    static func index(of case: Self) -> Int {
        switch `case` {
            case .account:
                return 0
            case .newAccount:
                return 1
            case .asset:
                return 2
            case .assetDefinition:
                return 3
            case .domain:
                return 4
            case .peer:
                return 5
            case .world:
                return 6
        }
    }
    
    // MARK: - Decodable
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let index = try container.decode(Int.self)
        switch index {
        case 0:
            let val0 = try container.decode(IrohaDataModelAccount.Account.self)
            self = .account(val0)
            break
        case 1:
            let val0 = try container.decode(IrohaDataModelAccount.NewAccount.self)
            self = .newAccount(val0)
            break
        case 2:
            let val0 = try container.decode(IrohaDataModelAsset.Asset.self)
            self = .asset(val0)
            break
        case 3:
            let val0 = try container.decode(IrohaDataModelAsset.AssetDefinition.self)
            self = .assetDefinition(val0)
            break
        case 4:
            let val0 = try container.decode(IrohaDataModelDomain.Domain.self)
            self = .domain(val0)
            break
        case 5:
            let val0 = try container.decode(IrohaDataModelPeer.Peer.self)
            self = .peer(val0)
            break
        case 6:
            
            self = .world
            break
        default:
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown index \(index)")
        }
    }
    
    // MARK: - Encodable
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(IdentifiableBox.index(of: self))
        switch self {
        case let .account(val0):
            try container.encode(val0)
            break
        case let .newAccount(val0):
            try container.encode(val0)
            break
        case let .asset(val0):
            try container.encode(val0)
            break
        case let .assetDefinition(val0):
            try container.encode(val0)
            break
        case let .domain(val0):
            try container.encode(val0)
            break
        case let .peer(val0):
            try container.encode(val0)
            break
        case .world:
            
            break
        }
    }
}
}
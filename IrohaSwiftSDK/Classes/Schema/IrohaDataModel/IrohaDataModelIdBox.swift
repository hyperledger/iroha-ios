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
public indirect enum IdBox: Codable {
    
    case accountId(IrohaDataModelAccount.Id)
    case assetId(IrohaDataModelAsset.Id)
    case assetDefinitionId(IrohaDataModelAsset.DefinitionId)
    case domainName(String)
    case peerId(IrohaDataModelPeer.Id)
    case worldId
    
    // MARK: - For Codable purpose
    
    static func index(of case: Self) -> Int {
        switch `case` {
            case .accountId:
                return 0
            case .assetId:
                return 1
            case .assetDefinitionId:
                return 2
            case .domainName:
                return 3
            case .peerId:
                return 4
            case .worldId:
                return 5
        }
    }
    
    // MARK: - Decodable
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let index = try container.decode(Int.self)
        switch index {
        case 0:
            let val0 = try container.decode(IrohaDataModelAccount.Id.self)
            self = .accountId(val0)
            break
        case 1:
            let val0 = try container.decode(IrohaDataModelAsset.Id.self)
            self = .assetId(val0)
            break
        case 2:
            let val0 = try container.decode(IrohaDataModelAsset.DefinitionId.self)
            self = .assetDefinitionId(val0)
            break
        case 3:
            let val0 = try container.decode(String.self)
            self = .domainName(val0)
            break
        case 4:
            let val0 = try container.decode(IrohaDataModelPeer.Id.self)
            self = .peerId(val0)
            break
        case 5:
            
            self = .worldId
            break
        default:
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown index \(index)")
        }
    }
    
    // MARK: - Encodable
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(IdBox.index(of: self))
        switch self {
        case let .accountId(val0):
            try container.encode(val0)
            break
        case let .assetId(val0):
            try container.encode(val0)
            break
        case let .assetDefinitionId(val0):
            try container.encode(val0)
            break
        case let .domainName(val0):
            try container.encode(val0)
            break
        case let .peerId(val0):
            try container.encode(val0)
            break
        case .worldId:
            
            break
        }
    }
}
}
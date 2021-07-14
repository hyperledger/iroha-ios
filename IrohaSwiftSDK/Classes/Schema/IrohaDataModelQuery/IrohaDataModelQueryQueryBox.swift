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

extension IrohaDataModelQuery {
public indirect enum QueryBox: Codable {
    
    case findAllAccounts(IrohaDataModelQueryAccount.FindAllAccounts)
    case findAccountById(IrohaDataModelQueryAccount.FindAccountById)
    case findAccountKeyValueByIdAndKey(IrohaDataModelQueryAccount.FindAccountKeyValueByIdAndKey)
    case findAccountsByName(IrohaDataModelQueryAccount.FindAccountsByName)
    case findAccountsByDomainName(IrohaDataModelQueryAccount.FindAccountsByDomainName)
    case findAllAssets(IrohaDataModelQueryAsset.FindAllAssets)
    case findAllAssetsDefinitions(IrohaDataModelQueryAsset.FindAllAssetsDefinitions)
    case findAssetById(IrohaDataModelQueryAsset.FindAssetById)
    case findAssetsByName(IrohaDataModelQueryAsset.FindAssetsByName)
    case findAssetsByAccountId(IrohaDataModelQueryAsset.FindAssetsByAccountId)
    case findAssetsByAssetDefinitionId(IrohaDataModelQueryAsset.FindAssetsByAssetDefinitionId)
    case findAssetsByDomainName(IrohaDataModelQueryAsset.FindAssetsByDomainName)
    case findAssetsByAccountIdAndAssetDefinitionId(IrohaDataModelQueryAsset.FindAssetsByAccountIdAndAssetDefinitionId)
    case findAssetsByDomainNameAndAssetDefinitionId(IrohaDataModelQueryAsset.FindAssetsByDomainNameAndAssetDefinitionId)
    case findAssetQuantityById(IrohaDataModelQueryAsset.FindAssetQuantityById)
    case findAssetKeyValueByIdAndKey(IrohaDataModelQueryAsset.FindAssetKeyValueByIdAndKey)
    case findAllDomains(IrohaDataModelQueryDomain.FindAllDomains)
    case findDomainByName(IrohaDataModelQueryDomain.FindDomainByName)
    case findAllPeers(IrohaDataModelQueryPeer.FindAllPeers)
    case findTransactionsByAccountId(IrohaDataModelQueryTransaction.FindTransactionsByAccountId)
    case findPermissionTokensByAccountId(IrohaDataModelQueryPermissions.FindPermissionTokensByAccountId)
    
    // MARK: - For Codable purpose
    
    static func index(of case: Self) -> Int {
        switch `case` {
            case .findAllAccounts:
                return 0
            case .findAccountById:
                return 1
            case .findAccountKeyValueByIdAndKey:
                return 2
            case .findAccountsByName:
                return 3
            case .findAccountsByDomainName:
                return 4
            case .findAllAssets:
                return 5
            case .findAllAssetsDefinitions:
                return 6
            case .findAssetById:
                return 7
            case .findAssetsByName:
                return 8
            case .findAssetsByAccountId:
                return 9
            case .findAssetsByAssetDefinitionId:
                return 10
            case .findAssetsByDomainName:
                return 11
            case .findAssetsByAccountIdAndAssetDefinitionId:
                return 12
            case .findAssetsByDomainNameAndAssetDefinitionId:
                return 13
            case .findAssetQuantityById:
                return 14
            case .findAssetKeyValueByIdAndKey:
                return 15
            case .findAllDomains:
                return 16
            case .findDomainByName:
                return 17
            case .findAllPeers:
                return 18
            case .findTransactionsByAccountId:
                return 19
            case .findPermissionTokensByAccountId:
                return 20
        }
    }
    
    // MARK: - Decodable
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let index = try container.decode(Int.self)
        switch index {
        case 0:
            let val0 = try container.decode(IrohaDataModelQueryAccount.FindAllAccounts.self)
            self = .findAllAccounts(val0)
            break
        case 1:
            let val0 = try container.decode(IrohaDataModelQueryAccount.FindAccountById.self)
            self = .findAccountById(val0)
            break
        case 2:
            let val0 = try container.decode(IrohaDataModelQueryAccount.FindAccountKeyValueByIdAndKey.self)
            self = .findAccountKeyValueByIdAndKey(val0)
            break
        case 3:
            let val0 = try container.decode(IrohaDataModelQueryAccount.FindAccountsByName.self)
            self = .findAccountsByName(val0)
            break
        case 4:
            let val0 = try container.decode(IrohaDataModelQueryAccount.FindAccountsByDomainName.self)
            self = .findAccountsByDomainName(val0)
            break
        case 5:
            let val0 = try container.decode(IrohaDataModelQueryAsset.FindAllAssets.self)
            self = .findAllAssets(val0)
            break
        case 6:
            let val0 = try container.decode(IrohaDataModelQueryAsset.FindAllAssetsDefinitions.self)
            self = .findAllAssetsDefinitions(val0)
            break
        case 7:
            let val0 = try container.decode(IrohaDataModelQueryAsset.FindAssetById.self)
            self = .findAssetById(val0)
            break
        case 8:
            let val0 = try container.decode(IrohaDataModelQueryAsset.FindAssetsByName.self)
            self = .findAssetsByName(val0)
            break
        case 9:
            let val0 = try container.decode(IrohaDataModelQueryAsset.FindAssetsByAccountId.self)
            self = .findAssetsByAccountId(val0)
            break
        case 10:
            let val0 = try container.decode(IrohaDataModelQueryAsset.FindAssetsByAssetDefinitionId.self)
            self = .findAssetsByAssetDefinitionId(val0)
            break
        case 11:
            let val0 = try container.decode(IrohaDataModelQueryAsset.FindAssetsByDomainName.self)
            self = .findAssetsByDomainName(val0)
            break
        case 12:
            let val0 = try container.decode(IrohaDataModelQueryAsset.FindAssetsByAccountIdAndAssetDefinitionId.self)
            self = .findAssetsByAccountIdAndAssetDefinitionId(val0)
            break
        case 13:
            let val0 = try container.decode(IrohaDataModelQueryAsset.FindAssetsByDomainNameAndAssetDefinitionId.self)
            self = .findAssetsByDomainNameAndAssetDefinitionId(val0)
            break
        case 14:
            let val0 = try container.decode(IrohaDataModelQueryAsset.FindAssetQuantityById.self)
            self = .findAssetQuantityById(val0)
            break
        case 15:
            let val0 = try container.decode(IrohaDataModelQueryAsset.FindAssetKeyValueByIdAndKey.self)
            self = .findAssetKeyValueByIdAndKey(val0)
            break
        case 16:
            let val0 = try container.decode(IrohaDataModelQueryDomain.FindAllDomains.self)
            self = .findAllDomains(val0)
            break
        case 17:
            let val0 = try container.decode(IrohaDataModelQueryDomain.FindDomainByName.self)
            self = .findDomainByName(val0)
            break
        case 18:
            let val0 = try container.decode(IrohaDataModelQueryPeer.FindAllPeers.self)
            self = .findAllPeers(val0)
            break
        case 19:
            let val0 = try container.decode(IrohaDataModelQueryTransaction.FindTransactionsByAccountId.self)
            self = .findTransactionsByAccountId(val0)
            break
        case 20:
            let val0 = try container.decode(IrohaDataModelQueryPermissions.FindPermissionTokensByAccountId.self)
            self = .findPermissionTokensByAccountId(val0)
            break
        default:
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown index \(index)")
        }
    }
    
    // MARK: - Encodable
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(QueryBox.index(of: self))
        switch self {
        case let .findAllAccounts(val0):
            try container.encode(val0)
            break
        case let .findAccountById(val0):
            try container.encode(val0)
            break
        case let .findAccountKeyValueByIdAndKey(val0):
            try container.encode(val0)
            break
        case let .findAccountsByName(val0):
            try container.encode(val0)
            break
        case let .findAccountsByDomainName(val0):
            try container.encode(val0)
            break
        case let .findAllAssets(val0):
            try container.encode(val0)
            break
        case let .findAllAssetsDefinitions(val0):
            try container.encode(val0)
            break
        case let .findAssetById(val0):
            try container.encode(val0)
            break
        case let .findAssetsByName(val0):
            try container.encode(val0)
            break
        case let .findAssetsByAccountId(val0):
            try container.encode(val0)
            break
        case let .findAssetsByAssetDefinitionId(val0):
            try container.encode(val0)
            break
        case let .findAssetsByDomainName(val0):
            try container.encode(val0)
            break
        case let .findAssetsByAccountIdAndAssetDefinitionId(val0):
            try container.encode(val0)
            break
        case let .findAssetsByDomainNameAndAssetDefinitionId(val0):
            try container.encode(val0)
            break
        case let .findAssetQuantityById(val0):
            try container.encode(val0)
            break
        case let .findAssetKeyValueByIdAndKey(val0):
            try container.encode(val0)
            break
        case let .findAllDomains(val0):
            try container.encode(val0)
            break
        case let .findDomainByName(val0):
            try container.encode(val0)
            break
        case let .findAllPeers(val0):
            try container.encode(val0)
            break
        case let .findTransactionsByAccountId(val0):
            try container.encode(val0)
            break
        case let .findPermissionTokensByAccountId(val0):
            try container.encode(val0)
            break
        }
    }
}
}
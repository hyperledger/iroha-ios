/**
 * Copyright Soramitsu Co., Ltd. 2017 All Rights Reserved.
 * http://soramitsu.co.jp
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import UIKit

public class IrohaQueryBuilder {

    private var modelQueryBuilder: IRModelQueryBuilder

    public init() {
        modelQueryBuilder = IRModelQueryBuilder()
    }

    public func createdTime(_ creationTime: Date) -> IrohaQueryBuilder {
        modelQueryBuilder = modelQueryBuilder.createdTime(creationTime)
        return self
    }

    public func creatorAccountId(_ creatorAccountId: String) -> IrohaQueryBuilder {
        modelQueryBuilder = modelQueryBuilder.creatorAccountId(creatorAccountId)
        return self
    }

    public func queryCounter(_ queryCounter: Int32) -> IrohaQueryBuilder {
        modelQueryBuilder = modelQueryBuilder.queryCounter(queryCounter)
        return self
    }

    public func getAccount(byAccountId accountId: String) -> IrohaQueryBuilder {
        modelQueryBuilder = modelQueryBuilder.getAccountByAccountId(accountId)
        return self
    }

    public func getSignatories(forAccountId accountId: String) -> IrohaQueryBuilder {
        modelQueryBuilder = modelQueryBuilder.getSignatoriesForAccountId(accountId)
        return self
    }

    public func getAccountTransactions(forAccountId accountId: String) -> IrohaQueryBuilder {
        modelQueryBuilder = modelQueryBuilder.getAccountTransactions(forAccountId: accountId)
        return self
    }

    public func getAccountAssetsTransactions(forAccountId accountId: String,
                                             withAssetId assetId: String) -> IrohaQueryBuilder {
        modelQueryBuilder = modelQueryBuilder.getAccountAssetTransactions(withAccountId: accountId, withAssetId: assetId)
        return self
    }

    public func getAccountAssets(forAccountId accountId: String) -> IrohaQueryBuilder {
        modelQueryBuilder = modelQueryBuilder.getAccountAssets(withAccountId: accountId);
        return self
    }

    public func getRoles() -> IrohaQueryBuilder {
        modelQueryBuilder = modelQueryBuilder.getRoles()
        return self
    }

    public func getAssetInfo(byAssetsId assetsId: String) -> IrohaQueryBuilder {
        modelQueryBuilder = modelQueryBuilder.getAssetInfo(byAssetId: assetsId)
        return self
    }

    public func getRolePermissions(forRoleId roleId: String) -> IrohaQueryBuilder {
        modelQueryBuilder = modelQueryBuilder.getRolePermissions(withRoleId: roleId)
        return self
    }

    public func getTransactions(withHashes hashes: [String]) -> IrohaQueryBuilder {
        modelQueryBuilder = modelQueryBuilder.getTransactions(hashes)
        return self
    }

    public func build() throws -> IrohaUnsignedQuery {
        do {
            var unsignedWrapperSwift: IrohaUnsignedQuery!
            try ObjC.catchException {
                let unsignedWrapperObjC = self.modelQueryBuilder.build()
                unsignedWrapperSwift = IrohaUnsignedQuery(unsignedQueryObjC: unsignedWrapperObjC!)
            }
            return unsignedWrapperSwift
        } catch {
            let error = error as NSError
            throw IrohaQueryBuilderError.customError(error.userInfo["Description"] as! String)
        }
    }
}

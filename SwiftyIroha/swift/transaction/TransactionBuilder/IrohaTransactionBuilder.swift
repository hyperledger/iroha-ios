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

public class IrohaTransactionBuilder {

    private var modelTransactionBuilder: IRModelTransactionBuilder

    public init() {
        modelTransactionBuilder = IRModelTransactionBuilder()
    }

    public func creatorAccountId(_ creatorAccountId: String) -> IrohaTransactionBuilder {
        modelTransactionBuilder = modelTransactionBuilder.creatorAccountId(creatorAccountId)
        return self
    }

    public func createdTime(_ createdTime: Date) -> IrohaTransactionBuilder {
        modelTransactionBuilder = modelTransactionBuilder.createdTime(createdTime)
        return self
    }

    public func addAssetQuantity(withAccountId accountId: String,
                                 withAssetsId assetId: String,
                                 withAmount amount: String) -> IrohaTransactionBuilder {
        modelTransactionBuilder = modelTransactionBuilder.addAssetQuantity(withAccountId: accountId,
                                                                           withAssetsId: assetId,
                                                                           withAmount: amount)
        return self
    }

    public func addPeer(withAddress address: String,
                        withPublicKey publicKey: IrohaPublicKey) -> IrohaTransactionBuilder {
        let publicKeyObjC = IRPublicKey()
        publicKeyObjC.value = publicKey.getValue()
        modelTransactionBuilder = modelTransactionBuilder.addPeer(withAddress: address,
                                                                  with: publicKeyObjC)
        return self
    }

    public func addSignatory(withAccountId accountId: String,
                             withPublicKey publicKey: IrohaPublicKey) -> IrohaTransactionBuilder {
        let publicKeyObjC = IRPublicKey()
        publicKeyObjC.value = publicKey.getValue()
        modelTransactionBuilder = modelTransactionBuilder.addSignatory(withAccountId: accountId,
                                                                       with: publicKeyObjC)
        return self
    }

    public func removeSignatory(withAccountId accountId: String,
                                withPublicKey publicKey: IrohaPublicKey) -> IrohaTransactionBuilder {
        let publicKeyObjC = IRPublicKey()
        publicKeyObjC.value = publicKey.getValue()
        modelTransactionBuilder = modelTransactionBuilder.removeSignatory(withAccountId: accountId,
                                                                          with: publicKeyObjC)
        return self
    }

    public func createAssets(withAssetName assetName: String,
                             domainId: String,
                             percision: Double) -> IrohaTransactionBuilder {
        modelTransactionBuilder = modelTransactionBuilder.createAsset(withAssetName: assetName,
                                                                      withDomainId: domainId,
                                                                      withPercision: percision)
        return self
    }

    public func createAccount(withAccountName accountName: String,
                              withDomainId domainId: String,
                              withPublicKey publicKey: IrohaPublicKey) -> IrohaTransactionBuilder {
        let publicKeyObjC = IRPublicKey()
        publicKeyObjC.value = publicKey.getValue()
        modelTransactionBuilder = modelTransactionBuilder.createAccount(withAccountName: accountName,
                                                                        withDomainId: domainId,
                                                                        with: publicKeyObjC)
        return self
    }

    public func createDomain(withDomainId domainId: String,
                             withDefaultRole defaultRole: String) -> IrohaTransactionBuilder {
        modelTransactionBuilder = modelTransactionBuilder.createDomain(withDomainId: domainId,
                                                                       withDefaultRole: defaultRole)
        return self
    }

    public func createRole(withRoleName roleName: String,
                           withPermissions permissions: [String]) -> IrohaTransactionBuilder {
        modelTransactionBuilder = modelTransactionBuilder.createRole(withName: roleName,
                                                                     withPermissions: permissions)
        return self
    }

    public func detachRole(withRoleName roleName: String,
                           fromAccountId accountId: String) -> IrohaTransactionBuilder {
        modelTransactionBuilder = modelTransactionBuilder.detachRole(withAccountId: accountId,
                                                                     withRoleName: roleName)
        return self
    }

    public func setAccountQuorum(withAccountId accountId: String,
                                    withQuorum quorum: Int32) -> IrohaTransactionBuilder {
        modelTransactionBuilder = modelTransactionBuilder.setAccountQuorumWithAccountId(accountId,
                                                                                        withQuorum: quorum)
        return self
    }

    public func appendRole(toAccountId accountId: String,
                           withRoleName roleName: String) -> IrohaTransactionBuilder {
        modelTransactionBuilder = modelTransactionBuilder.appendRole(toAccountId: accountId,
                                                                     withRoleName: roleName)
        return self
    }

    public func grantPermission(toAccountId accountId: String,
                                withPermission permission: String) -> IrohaTransactionBuilder {
        modelTransactionBuilder = modelTransactionBuilder.grantPermission(toAccountId: accountId,
                                                                          withPermission: permission)
        return self
    }

    public func revokePermission(toAccountId accountId: String,
                                 withPermission permission: String) -> IrohaTransactionBuilder {
        modelTransactionBuilder = modelTransactionBuilder.revokePermission(toAccountId: accountId,
                                                                           withPermission: permission)
        return self
    }

    public func setAccountDetail(toAccountId accountId: String,
                                 withKey key: String,
                                 withValue value: String) -> IrohaTransactionBuilder {
        modelTransactionBuilder = modelTransactionBuilder.setAccountDetailToAccountId(accountId,
                                                                                      withKey: key,
                                                                                      withValue: value)
        return self
    }

    public func subtractAssetQuantity(fromAccountId accountId: String,
                                      withAssetId assetId: String,
                                      withAmount amount: String) -> IrohaTransactionBuilder {
        modelTransactionBuilder = modelTransactionBuilder.subtractAssetQuantity(fromAccountId: accountId,
                                                                                withAssetId: assetId,
                                                                                withAmount: amount)
        return self
    }

    public func transferAsset(fromAccountId sourceAccountId: String,
                              toAccountId destinationAccountId: String,
                              withAssetId assetId: String,
                              withDescription description: String,
                              withAmount amount: String) -> IrohaTransactionBuilder {
        modelTransactionBuilder = modelTransactionBuilder.transferAsset(fromAccountId: sourceAccountId,
                                                                        toDestinationAccountId: destinationAccountId,
                                                                        withAssetId: assetId,
                                                                        withDescription: description,
                                                                        withAmount: amount)
        return self
    }

    public func build() throws -> IrohaUnsignedTransaction {
        do {
            var unsignedWrapperSwift: IrohaUnsignedTransaction!
            try ObjC.catchException {
                let unsignedWrapperObjC = self.modelTransactionBuilder.build()
                unsignedWrapperSwift = IrohaUnsignedTransaction(unsignedTransactionObjC: unsignedWrapperObjC!)
            }
            return unsignedWrapperSwift
        } catch {
            let error = error as NSError
            throw IrohaTransactionBuilderError.customError(error.userInfo["Description"] as! String)
        }
    }
}

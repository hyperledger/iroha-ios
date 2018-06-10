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

#import <Foundation/Foundation.h>
#import "IRModelTransactionBuilder.h"
#import "IRUnsignedtransaction.h"
#import "IRPublicKey.h"

/**
 * Using private implementation or PIMPL approach inside implementation of this interface
 */
@interface IRModelTransactionBuilder : NSObject {
@private
    struct TransactionBuilderImpl* transactionBuilderImpl;
}

-(id)init;

/**
 * Sets id of account creator
 * @param creatorAccountId - account id
 * @return builder with creatorAccountId field appended
 */
-(IRModelTransactionBuilder*)creatorAccountId:(NSString*)creatorAccountId;

/**
 * Sets time of creation (Unix time in milliseconds)
 * @param creationTime - time to set
 * @return builder with creationTime field appended
 */
-(IRModelTransactionBuilder*)createdTime:(NSDate*)creationTime;

/**
 * Adds given quantity of given asset to account
 * @param accountId - account id
 * @param assetId - asset id
 * @param amount - amount of asset to add
 * @return builder with asset quantity command appended
 */
-(IRModelTransactionBuilder*)addAssetQuantityWithAccountId:(NSString*)accountId
                                              withAssetsId:(NSString*)assetId
                                                withAmount:(NSString*)amount;

/**
 * Adds new peer into ledger
 * @param address - peer address
 * @param peerPublicKey - peer public key
 * @return builder with added peer command appended
 */
-(IRModelTransactionBuilder*)addPeerWithAddress:(NSString*)address
                                  withPublicKey:(IRPublicKey*)peerPublicKey;

/**
 * Adds new signatory
 * @param accountId - id of signatory's account
 * @param publicKey - public key of signatory
 * @return builder with added signatory command appended
 */
-(IRModelTransactionBuilder*)addSignatoryWithAccountId:(NSString*)accountId
                                         withPublicKey:(IRPublicKey*)publicKey;

/**
 * Removes signatory
 * @param accountId - id of signatory's account to remove
 * @param publicKey - public key of signatory
 * @return builder with removed signatory command appended
 */
-(IRModelTransactionBuilder*)removeSignatoryWithAccountId:(NSString*)accountId
                                            withPublicKey:(IRPublicKey*)publicKey;

/**
 * Creates new account
 * @param accountName - name of account to create
 * @param domainId - id of domain where account will be created
 * @param publicKey - main public key of account
 * @return builder with new account command appended
 */
-(IRModelTransactionBuilder*)createAccountWithAccountName:(NSString*)accountName
                                             withDomainId:(NSString*)domainId
                                            withPublicKey:(IRPublicKey*)publicKey;

/**
 * Creates new domain
 * @param domainId - domain name to create
 * @param defaultRole - default role name
 * @return builder with new domain command appended
 */
-(IRModelTransactionBuilder*)createDomainWithDomainId:(NSString*)domainId
                                      withDefaultRole:(NSString*)defaultRole;

/**
 * Sets account quorum
 * @param accountId - id of account to set quorum
 * @param quorum - quorum amount
 * @return builder with set account quorum command appended
 */
-(IRModelTransactionBuilder*)setAccountQuorumWithAccountId:(NSString*)accountId
                                                withQuorum:(int)quorum;

/**
 * Appends role
 * @param accountId - account id to append role
 * @param roleName - role name to append
 * @return builder with append role command appended
 */
-(IRModelTransactionBuilder*)appendRoleToAccountId:(NSString*)accountId
                                      withRoleName:(NSString*)roleName;

/**
 * Creates asset
 * @param assetName - asset name to create
 * @param domainId - domain id to create asset in
 * @param precision - asset precision
 * @return builder with create asset command appended
 */
-(IRModelTransactionBuilder*)createAssetWithAssetName:(NSString*)assetName
                                         withDomainId:(NSString*)domainId
                                        withPercision:(double)precision;

/**
 * Creates role
 * @param roleName - role name to create
 * @param permissions - permissions to include in new role
 * @return builder with create role command appended
 */
-(IRModelTransactionBuilder*)createRoleWithName:(NSString*)roleName
                                withPermissions:(NSArray*)permissions;

/**
 * Detaches role
 * @param accountId - account id to detach role from
 * @param roleName - role name to detach
 * @return builder with detach role command appended
 */
-(IRModelTransactionBuilder*)detachRoleWithAccountId:(NSString*)accountId
                                        withRoleName:(NSString*)roleName;

/**
 * Grants permission
 * @param accountId - account id to grant permission
 * @param permission - permission to grant
 * @return builder with grant permission command appended
 */
-(IRModelTransactionBuilder*)grantPermissionToAccountId:(NSString*)accountId
                                         withPermission:(NSString*)permission;

/**
 * Revokes permission
 * @param accountId - account id to revoke permission
 * @param permission - permission to revoke
 * @return builder with revoke permission command appended
 */
-(IRModelTransactionBuilder*)revokePermissionToAccountId:(NSString*)accountId
                                          withPermission:(NSString*)permission;

/**
 * Subtracts asset quantity
 * @param accountId - account id to subtract asset quantity from
 * @param assetId - asset id to subtract
 * @param amount - amount to subtract
 * @return builder with subtract asset quantity command appended
 */
-(IRModelTransactionBuilder*)subtractAssetQuantityFromAccountId:(NSString*)accountId
                                                    withAssetId:(NSString*)assetId
                                                     withAmount:(NSString*)amount;

/**
 * Sets account detail
 * @param accountId - account id to set detail
 * @param key - detail key
 * @param value - detail value
 * @return builder with set account detail command appended
 */
-(IRModelTransactionBuilder*)setAccountDetailToAccountId:(NSString*)accountId
                                                 withKey:(NSString*)key
                                               withValue:(NSString*)value;

/**
 * Transfers asset from one account to another
 * @param sourceAccountId - source account id
 * @param destinationAccountId - destination account id
 * @param assetId - asset id
 * @param description - description message which user can set
 * @param amount - amount of asset to transfer
 * @return builder with transfer asset command appended
 */
-(IRModelTransactionBuilder*)transferAssetFromAccountId:(NSString*)sourceAccountId
                                 toDestinationAccountId:(NSString*)destinationAccountId
                                            withAssetId:(NSString*)assetId
                                        withDescription:(NSString*)description
                                             withAmount:(NSString*)amount;

/**
 * Builds result with all appended fields
 * @return wrapper on unsigned query
 */
-(IRUnsignedTransaction*)build;

@end

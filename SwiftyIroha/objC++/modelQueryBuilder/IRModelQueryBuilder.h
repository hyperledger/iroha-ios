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
#import "IRModelQueryBuilder.h"
#import "IRUnsignedQuery.h"

/**
 * Using private implementation or PIMPL approach inside implementation of this interface
 */
@interface IRModelQueryBuilder : NSObject {
@private
    struct QueryBuilderImpl* queryBuilderImpl;
}

-(id)init;

/**
 * Sets account id of query creator
 * @param creatorAccountId - account of query creator
 * @return builder with query account creator field appended
 */
-(IRModelQueryBuilder*)creatorAccountId:(NSString*)creatorAccountId;

/**
 * Sets query counter
 * @param queryCounter - number to set as a query counter
 * @return builder with query counter field appended
 */
-(IRModelQueryBuilder*)queryCounter:(int)queryCounter;

/**
 * Sets time of query creation (Unix time in milliseconds)
 * @param creationTime - time to set
 * @return builder with created time field appended
 */
-(IRModelQueryBuilder*)createdTime:(NSDate*)creationTime;

/**
 * Queries state of account
 * @param accountId - id of account to query
 * @return builder with getAccount query inside
 */
-(IRModelQueryBuilder*)getAccountByAccountId:(NSString*)accountId;

/**
 * Queries signatories of account
 * @param accountId - id of account to query
 * @return builder with getSignatories query inside
 */
-(IRModelQueryBuilder*)getSignatoriesForAccountId:(NSString*)accountId;

/**
 * Queries account transaction collection
 * @param accountId - id of account to query
 * @return builder with getAccountTransactions query inside
 */
-(IRModelQueryBuilder*)getAccountTransactionsForAccountId:(NSString*)accountId;

/**
 * Queries account transaction collection for a given asset
 * @param accountId - id of account to query
 * @param assetId - asset id to query about
 * @return builder with getAccountAssetTransactions query inside
 */
-(IRModelQueryBuilder*)getAccountAssetTransactionsWithAccountId:(NSString*)accountId
                                                    withAssetId:(NSString*)assetId;

/**
 * Queries balance of all assets for given account
 * @param accountId - id of account to query
 * @return builder with getAccountAssets query inside
 */
-(IRModelQueryBuilder*)getAccountAssetsWithAccountId:(NSString*)accountId;

/**
 * Queries available roles in the system
 * @return builder with getRoles query inside
 */
-(IRModelQueryBuilder*)getRoles;

/**
 * Queries info about given asset
 * @param assetId - asset id to query about
 * @return builder with getAssetInfo query inside
 */
-(IRModelQueryBuilder*)getAssetInfoByAssetId:(NSString*)assetId;

/**
 * Queries list of permissions for given role
 * @param roleId - role id to query about
 * @return builder with getRolePermissions query inside
 */
-(IRModelQueryBuilder*)getRolePermissionsWithRoleId:(NSString*)roleId;

/**
 * Queries transactions for given hashes
 * @param hashes - list of transaction hashes to query
 * @return builder with getTransactions query inside
 */
-(IRModelQueryBuilder*)getTransactions:(NSArray*)hashes;

/**
 * Builds result with all appended fields
 * @return wrapper on unsigned query
 */
-(IRUnsignedQuery*)build;

@end

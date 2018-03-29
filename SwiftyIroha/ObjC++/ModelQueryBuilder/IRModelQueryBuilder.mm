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

#import "IRModelQueryBuilder.h"
#import "bindings/model_query_builder.hpp"

using namespace std;
using namespace shared_model;
using namespace shared_model::proto;
using namespace shared_model::crypto;
using namespace shared_model::bindings;

typedef IRModelQueryBuilder ModelQueryBuilderObjC;
typedef IRUnsignedQuery UnsignedQueryObjC;

typedef ModelQueryBuilder QueryBuilderCpp;
typedef UnsignedWrapper<proto::Query> UnsignedQueryCpp;

enum UnsignedWrapperType {
    QUERY,
    TRANSACTION
};

struct UnsignedQueryImpl {
    UnsignedQueryCpp *unsignedQueryCpp;

    UnsignedQueryImpl(UnsignedQueryCpp query) {
        unsignedQueryCpp = new UnsignedQueryCpp(query);
    }
};

struct QueryBuilderImpl {
    QueryBuilderCpp queryBuilderCpp;
};

@implementation IRModelQueryBuilder

- (id)init {
    self = [super init];
    if (self) {
        queryBuilderImpl = new QueryBuilderImpl;
    }
    return self;
}

- (void)dealloc {
    delete queryBuilderImpl;
}

-(ModelQueryBuilderObjC*)creatorAccountId:(NSString*)creatorAccountId {
    string creatorAccountIdCpp = [self getStringCppFromStringObjC:creatorAccountId];
    queryBuilderImpl->queryBuilderCpp = queryBuilderImpl->queryBuilderCpp.creatorAccountId(creatorAccountIdCpp);
    return self;
}

-(ModelQueryBuilderObjC*)queryCounter:(int)queryCounter {
    queryBuilderImpl->queryBuilderCpp = queryBuilderImpl->queryBuilderCpp.queryCounter(queryCounter);
    return self;
}

-(ModelQueryBuilderObjC*)createdTime:(NSDate*)creationTime {
    UInt64 timestamp = (UInt64)([creationTime timeIntervalSince1970]) * 1000;
    queryBuilderImpl->queryBuilderCpp = queryBuilderImpl->queryBuilderCpp.createdTime(timestamp);
    return self;
}

-(ModelQueryBuilderObjC*)getAccountByAccountId:(NSString*)accountId {
    string accountIdCpp = [self getStringCppFromStringObjC:accountId];
    queryBuilderImpl->queryBuilderCpp = queryBuilderImpl->queryBuilderCpp.getAccount(accountIdCpp);
    return self;
}

-(ModelQueryBuilderObjC*)getSignatoriesForAccountId:(NSString*)accountId {
    string accountIdCpp = [self getStringCppFromStringObjC:accountId];
    queryBuilderImpl->queryBuilderCpp = queryBuilderImpl->queryBuilderCpp.getSignatories(accountIdCpp);
    return self;
}

-(ModelQueryBuilderObjC*)getAccountTransactionsForAccountId:(NSString*)accountId {
    string accountIdCpp = string([accountId UTF8String],
                                 [accountId lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
    queryBuilderImpl->queryBuilderCpp = queryBuilderImpl->queryBuilderCpp.getAccountTransactions(accountIdCpp);
    return self;
}

-(ModelQueryBuilderObjC*)getAccountAssetTransactionsWithAccountId:(NSString*)accountId
                                                      withAssetId:(NSString*)assetId {
    string accountIdCpp = [self getStringCppFromStringObjC:accountId];
    string assetIdCpp = [self getStringCppFromStringObjC:assetId];
    queryBuilderImpl->queryBuilderCpp = queryBuilderImpl->queryBuilderCpp.getAccountAssetTransactions(accountIdCpp, assetIdCpp);
    return self;
}

-(ModelQueryBuilderObjC*)getAccountAssetsWithAccountId:(NSString*)accountId
                                           withAssetId:(NSString*)assetId {
    string accountIdCpp = [self getStringCppFromStringObjC:accountId];
    string assetIdCpp = [self getStringCppFromStringObjC:assetId];
    queryBuilderImpl->queryBuilderCpp = queryBuilderImpl->queryBuilderCpp.getAccountAssets(accountIdCpp, assetIdCpp);
    return self;
}

-(ModelQueryBuilderObjC*)getRoles {
    queryBuilderImpl->queryBuilderCpp = queryBuilderImpl->queryBuilderCpp.getRoles();
    return self;
}

-(ModelQueryBuilderObjC*)getAssetInfoByAssetId:(NSString*)assetId {
    string assetIdCpp = [self getStringCppFromStringObjC:assetId];
    queryBuilderImpl->queryBuilderCpp = queryBuilderImpl->queryBuilderCpp.getRoles();
    return self;
}

-(ModelQueryBuilderObjC*)getRolePermissionsWithRoleId:(NSString*)roleId {
    string roleIdCpp = string([roleId UTF8String],
                              [roleId lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
    queryBuilderImpl->queryBuilderCpp = queryBuilderImpl->queryBuilderCpp.getRolePermissions(roleIdCpp);
    return self;
}

-(ModelQueryBuilderObjC*)getTransactions:(NSArray*)hashes {
    vector<Hash> hashesVectorCpp;

    for (NSString* hash in hashes) {
        string hashStringCpp = [self getStringCppFromStringObjC:hash];
        Hash hashCpp = Hash(hashStringCpp);
        hashesVectorCpp.push_back(hashCpp);
    }

    queryBuilderImpl->queryBuilderCpp = queryBuilderImpl->queryBuilderCpp.getTransactions(hashesVectorCpp);
    return self;
}

-(UnsignedQueryObjC*)build {
    try {
        UnsignedQueryCpp unsignedQueryCpp = queryBuilderImpl->queryBuilderCpp.build();
        UnsignedQueryImpl *unsignedQueryImpl = new UnsignedQueryImpl(unsignedQueryCpp);
        UnsignedQueryObjC *unsignedQueryObjC = [[UnsignedQueryObjC alloc] init:unsignedQueryImpl];
        return unsignedQueryObjC;
    } catch (const invalid_argument e) {
        NSString* description = [[NSString alloc] initWithUTF8String:e.what()];
        @throw [NSException exceptionWithName:@"Build unsigned query exception"
                                       reason:description
                                     userInfo:@{@"Description": description}];
    }
}

-(string)getStringCppFromStringObjC:(NSString*)stringObjC {
    string stringCpp = string([stringObjC UTF8String],
                              [stringObjC lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
    return stringCpp;
}

@end

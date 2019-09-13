/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import "IRGetAccountAssets.h"
#import "Queries.pbobjc.h"

@implementation IRGetAccountAssets
@synthesize accountId = _accountId;
@synthesize pagination = _pagination;

- (nonnull instancetype)initWithAccountId:(nonnull id<IRAccountId>)accountId
                               pagination:(nullable id<IRAssetPagination>)pagination {
    if (self = [super init]) {
        _accountId = accountId;
        _pagination = pagination;
    }

    return self;
}

#pragma mark - Protobuf Transformable

- (nullable id)transform:(NSError **)error {
    GetAccountAssets *query = [[GetAccountAssets alloc] init];
    query.accountId = [_accountId identifier];

    if (_pagination) {
        AssetPaginationMeta *meta = [[AssetPaginationMeta alloc] init];
        meta.pageSize = _pagination.pageSize;
        meta.firstAssetId = [_pagination.startingAssetId identifier];

        query.paginationMeta = meta;
    }

    Query_Payload *payload = [[Query_Payload alloc] init];
    payload.getAccountAssets = query;

    return payload;
}

@end

/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import "IRAccountAssetsResponse.h"

@implementation IRAccountAssetsResponse
@synthesize accountAssets = _accountAssets;
@synthesize totalCount = _totalCount;
@synthesize nextAssetId = _nextAssetId;
@synthesize queryHash = _queryHash;

- (nonnull instancetype)initWithAccountAssets:(nonnull NSArray<id<IRAccountAsset>>*)accountAssets
                                   totalCount:(UInt32)totalCount
                                  nextAssetId:(nullable id<IRAssetId>)assetId
                                    queryHash:(nonnull NSData*)queryHash {
    if (self = [super init]) {
        _accountAssets = accountAssets;
        _totalCount = totalCount;
        _nextAssetId = assetId;
        _queryHash = queryHash;
    }

    return self;
}

@end

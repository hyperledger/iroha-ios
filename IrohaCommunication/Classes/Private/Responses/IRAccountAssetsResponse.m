/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import "IRAccountAssetsResponse.h"

@implementation IRAccountAssetsResponse
@synthesize accountAssets = _accountAssets;
@synthesize queryHash = _queryHash;

- (nonnull instancetype)initWithAccountAssets:(NSArray<id<IRAccountAsset>> *)accountAssets
                                    queryHash:(nonnull NSData*)queryHash {
    if (self = [super init]) {
        _accountAssets = accountAssets;
        _queryHash = queryHash;
    }

    return self;
}

@end

/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import "IRAssetPagination.h"

@interface IRAssetPagination: NSObject <IRAssetPagination>

@end

@implementation IRAssetPagination
@synthesize pageSize = _pageSize;
@synthesize startingAssetId = _startingAssetId;

- (instancetype)initWithPageSize:(UInt32)pageSize startingAssetId:(nullable id<IRAssetId>)assetId {
    if (self = [super init]) {
        _pageSize = pageSize;
        _startingAssetId = assetId;
    }

    return self;
}

@end

@implementation IRAssetPaginationFactory

+ (nonnull id<IRAssetPagination>)assetPagination:(UInt32)pageSize startingAssetId:(nullable id<IRAssetId>)assetId {
    return [[IRAssetPagination alloc] initWithPageSize:pageSize startingAssetId:assetId];
}

@end

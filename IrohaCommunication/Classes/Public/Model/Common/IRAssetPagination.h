/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <Foundation/Foundation.h>
#import "IRAssetId.h"

@protocol IRAssetPagination <NSObject>

@property (nonatomic, readonly) UInt32 pageSize;

@property (nonatomic, readonly) id<IRAssetId> _Nullable startingAssetId;

@end

@protocol IRAssetPaginationFactoryProtocol <NSObject>

+ (nonnull id<IRAssetPagination>)assetPagination:(UInt32)pageSize
                                 startingAssetId:(nullable id<IRAssetId>)assetId;

@end

@interface IRAssetPaginationFactory : NSObject <IRAssetPaginationFactoryProtocol>

@end

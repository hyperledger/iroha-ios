/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <Foundation/Foundation.h>
#import "IRQueryResponse.h"

@interface IRAccountAssetsResponse : NSObject<IRAccountAssetsResponse>

- (nonnull instancetype)initWithAccountAssets:(nonnull NSArray<id<IRAccountAsset>>*)accountAssets
                                   totalCount:(UInt32)totalCount
                                  nextAssetId:(nullable id<IRAssetId>)assetId
                                    queryHash:(nonnull NSData*)queryHash;

@end

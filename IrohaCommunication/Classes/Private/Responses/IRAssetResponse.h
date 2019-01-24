/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <Foundation/Foundation.h>
#import "IRQueryResponse.h"

@interface IRAssetResponse : NSObject<IRAssetResponse>

- (nonnull instancetype)initWithAssetId:(nonnull id<IRAssetId>)assetId
                              precision:(UInt32)precision
                              queryHash:(nonnull NSData*)queryHash;

@end

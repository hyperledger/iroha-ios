/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <Foundation/Foundation.h>
#import "IRQueryResponse.h"

@interface IRAccountAssetsResponse : NSObject<IRAccountAssetsResponse>

- (nonnull instancetype)initWithAccountAssets:(nonnull NSArray<id<IRAccountAsset>>*)accountAssets
                                    queryHash:(nonnull NSData*)queryHash;

@end

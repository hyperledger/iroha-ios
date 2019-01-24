/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <Foundation/Foundation.h>
#import "IRQuery.h"
#import "IRProtobufTransformable.h"

@interface IRGetAssetInfo : NSObject<IRGetAssetInfo, IRProtobufTransformable>

- (nonnull instancetype)initWithAssetId:(nonnull id<IRAssetId>)assetId;

@end

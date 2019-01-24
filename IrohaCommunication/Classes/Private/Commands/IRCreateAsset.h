/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <Foundation/Foundation.h>
#import "IRCommand.h"
#import "IRProtobufTransformable.h"

@interface IRCreateAsset : NSObject<IRCreateAsset, IRProtobufTransformable>

- (nonnull instancetype)initWithAssetId:(nonnull id<IRAssetId>)assetId
                              precision:(UInt32)precision;

@end

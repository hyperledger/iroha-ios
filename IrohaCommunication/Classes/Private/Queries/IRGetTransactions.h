/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <Foundation/Foundation.h>
#import "IRQuery.h"
#import "IRProtobufTransformable.h"

@interface IRGetTransactions : NSObject<IRGetTransactions, IRProtobufTransformable>

- (nonnull instancetype)initWithTransactionHashes:(nonnull NSArray<NSData*> *)hashes;

@end

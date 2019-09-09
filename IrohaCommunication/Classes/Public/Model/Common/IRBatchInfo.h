/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <Foundation/Foundation.h>


@interface IRBatchInfo : NSObject

@property (nonatomic, readonly) NSString *nextHash;
@property (nonatomic, readonly) UInt32 batchSize;

- (instancetype)initWithNextHash:(NSString *)nextHash batchSize:(UInt32)batchSize;

@end

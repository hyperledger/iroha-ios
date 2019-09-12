/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import "IRBatchInfo.h"


@interface IRBatchInfo ()

@property (strong, nonatomic, nonnull) NSString *nextHash;
@property (nonatomic, assign) UInt32 batchSize;


@end


@implementation IRBatchInfo

- (nonnull instancetype)initWithNextHash:(nonnull NSString *)nextHash batchSize:(UInt32)batchSize {
    if (self = [super init]) {
        _nextHash = nextHash;
        _batchSize = batchSize;
    }
    
    return self;
}

@end

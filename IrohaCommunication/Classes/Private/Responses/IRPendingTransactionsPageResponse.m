/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import "IRPendingTransactionsPageResponse.h"


@implementation IRPendingTransactionsPageResponse

@synthesize transactions = _transactions;
@synthesize totalCount = _totalCount;
@synthesize nextBatch = _nextBatch;
@synthesize queryHash = _queryHash;

- (instancetype)initWithTransactions:(NSArray<id<IRTransaction>> *)transactions
                          totalCount:(UInt32)totalCount
                           nextBatch:(IRBatchInfo *)batchInfo
                           queryHash:(NSData *)queryHash {
    if (self = [super init]) {
        _transactions = transactions;
        _totalCount = totalCount;
        _nextBatch = batchInfo;
        _queryHash = queryHash;
    }
    
    return self;
}

@end

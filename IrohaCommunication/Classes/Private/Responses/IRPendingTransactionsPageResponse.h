/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <Foundation/Foundation.h>
#import "IRQueryResponse.h"
#import "IRBatchInfo.h"


@interface IRPendingTransactionsPageResponse : NSObject <IRPendingTransactionsPageResponse>

- (nonnull instancetype)initWithTransactions:(nonnull NSArray<id<IRTransaction>> *)transactions
                                  totalCount:(UInt32)totalCount
                                   nextBatch:(nullable IRBatchInfo *)batchInfo
                                   queryHash:(nonnull NSData *)queryHash;

@end

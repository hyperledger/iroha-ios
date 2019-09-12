/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import "IRTransactionImpl.h"

@class Transaction;

typedef NS_ENUM(NSUInteger, IRTransactionProtoError) {
    IRTransactionProtoErrorInvalidArgument
};

@interface IRTransaction(Proto)

+ (nullable IRTransaction*)transactionFromPbTransaction:(nonnull Transaction*)pbTransaction
                                                  error:(NSError *_Nullable*_Nullable)error;

@end

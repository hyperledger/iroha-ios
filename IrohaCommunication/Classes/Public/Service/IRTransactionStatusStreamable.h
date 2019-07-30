/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#ifndef IRTransactionStatusStreamable_h
#define IRTransactionStatusStreamable_h

#import "IRCancellable.h"
#import "IRTransactionStatusResponse.h"

typedef void (^IRTransactionStatusBlock)(id<IRTransactionStatusResponse> _Nullable response, BOOL done, NSError * _Nullable error);

@protocol IRTransactionStatusStreamable <NSObject>

- (nullable id<IRCancellable>)streamTransactionStatus:(nonnull NSData*)transactionHash
                                            withBlock:(nonnull IRTransactionStatusBlock)block;

@end

#endif

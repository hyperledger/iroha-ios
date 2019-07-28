/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#ifndef IRRepeatableStatusStream_h
#define IRRepeatableStatusStream_h

#import <Foundation/Foundation.h>
#import "IRTransactionStatusStreamable.h"
#import "IRPromise.h"

typedef NS_ENUM(NSUInteger, IRTransactionStatusStreamError) {
    IRTransactionStatusStreamErrorStatusNotReceived
};

@protocol IRRepeatableStatusStreamProtocol <NSObject>

+ (nonnull IRPromise*)onTransactionStatus:(IRTransactionStatus)transactionStatus
                                 withHash:(nonnull NSData*)transactionHash
                                     from:(nonnull id<IRTransactionStatusStreamable>)streamable
                          maxReconnection:(NSUInteger)trialsCount;

@end

@interface IRRepeatableStatusStream : NSObject<IRRepeatableStatusStreamProtocol>

+ (nonnull IRPromise*)onTransactionStatus:(IRTransactionStatus)transactionStatus
                                 withHash:(nonnull NSData*)transactionHash
                                     from:(nonnull id<IRTransactionStatusStreamable>)streamable;

@end

#endif

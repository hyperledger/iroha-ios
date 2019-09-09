/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <Foundation/Foundation.h>
#import "IRTransaction.h"
#import "IRQueryRequest.h"
#import "IRTransactionStatusResponse.h"
#import "IRPromise.h"
#import "IRBlockQueryRequest.h"
#import "IRBlockQueryResponse.h"
#import "IRCancellable.h"
#import "IRTransactionStatusStreamable.h"

typedef void (^IRCommitStreamBlock)(id<IRBlockQueryResponse> _Nullable response, BOOL done, NSError * _Nullable error);

typedef NS_ENUM(NSUInteger, IRNetworkServiceError) {
    IRNetworkServiceErrorTransactionStatusNotReceived
};

@interface IRNetworkService : NSObject<IRTransactionStatusStreamable>

@property (nonatomic, strong) dispatch_queue_t _Nonnull responseSerialQueue;

- (nonnull instancetype)initWithAddress:(nonnull id<IRAddress>)address;

- (nonnull instancetype)initWithAddress:(nonnull id<IRAddress>)address useSecuredConnection:(BOOL)secured;

- (nonnull IRPromise *)executeTransaction:(nonnull id<IRTransaction>)transaction;

- (nonnull IRPromise *)executeBatchTransactions:(nonnull NSArray<id<IRTransaction>>*)transactions;

- (nonnull IRPromise *)fetchTransactionStatus:(nonnull NSData *)transactionHash;

- (nonnull IRPromise*)executeQueryRequest:(nonnull id<IRQueryRequest>)queryRequest;

- (nullable id<IRCancellable>)streamCommits:(nonnull id<IRBlockQueryRequest>)request
                                  withBlock:(nonnull IRCommitStreamBlock)block;

@end

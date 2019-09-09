/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import "IRRepeatableStatusStream.h"
#import "GRPCProtoCall+Cancellable.h"
#import "IRTransactionStatusResponseImpl+Proto.h"
#import "Endpoint.pbrpc.h"

@interface IRRepeatableStatusStream()

@property (nonatomic, strong) NSData * _Nonnull transactionHash;
@property (nonatomic, weak) id<IRTransactionStatusStreamable> _Nullable streamable;
@property (nonatomic, strong) IRPromise * _Nullable promise;
@property (nonatomic, strong) id<IRCancellable> _Nullable operation;
@property (nonatomic, readonly) IRTransactionStatus expectedTransactionStatus;
@property (nonatomic, readonly) NSUInteger maxTrialsCount;
@property (nonatomic, readwrite) NSUInteger currentTrial;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *receivedStatuses;

@end

@implementation IRRepeatableStatusStream

- (instancetype)initWithTransactionHash:(nonnull NSData *)transactionHash
                          streamingFrom:(nonnull id<IRTransactionStatusStreamable>)streamable
                              expecting:(IRTransactionStatus)transactionStatus
                              maxTrials:(NSUInteger)trialsCount {

    if (self = [super init]) {
        _transactionHash = transactionHash;
        _streamable = streamable;
        _expectedTransactionStatus = transactionStatus;
        _maxTrialsCount = MAX(trialsCount, 1);
        _currentTrial = 0;
        _receivedStatuses = [NSMutableArray array];
    }

    return self;
}

- (IRPromise *)start {
    IRPromise *promise = [[IRPromise alloc] init];

    self.promise = promise;

    [self performAttempt];

    return promise;
}

- (void)performAttempt {
    _currentTrial++;

    id eventHandler = ^(id<IRTransactionStatusResponse> _Nullable response, BOOL done, NSError * _Nullable error) {
        [self handle:response done:done error:error];
    };

    _operation = [_streamable streamTransactionStatus:_transactionHash withBlock:eventHandler];
}

- (void)handle:(nullable id<IRTransactionStatusResponse>)response done:(BOOL)done error:(nullable NSError *)error {
    if (response) {

        if ([_receivedStatuses containsObject:@(response.status)]) {
            return;
        }

        [_receivedStatuses addObject:@(response.status)];

        if (response.status == _expectedTransactionStatus) {
            [_promise fulfillWithResult:@(_expectedTransactionStatus)];

            [_operation cancel];
            _operation = nil;
        } else if ([self isFinal:response.status]) {
            NSError *error = [self prepareNotReceivedError];
            [_promise fulfillWithResult:error];

            [_operation cancel];
            _operation = nil;
        }
    } else if (done && !_promise.isFulfilled) {
        if (_currentTrial < _maxTrialsCount) {
            [self performAttempt];
        } else if (error) {
            [_promise fulfillWithResult:error];

            _operation = nil;
        } else {
            NSError *error = [self prepareNotReceivedError];
            [_promise fulfillWithResult:error];

            _operation = nil;
        }
    }
}

- (BOOL)isFinal:(IRTransactionStatus)status {
    switch (status) {
        case IRTransactionStatusRejected: case IRTransactionStatusCommitted: case IRTransactionStatusMstExpired:
            return true;
        default:
            return false;
    }
}

- (nonnull NSError *)prepareNotReceivedError {
    NSString *message = [NSString stringWithFormat:@"Received statuses [%@], but waited for %@. Streaming closed",
                         [_receivedStatuses componentsJoinedByString:@","], @(_expectedTransactionStatus)];
    return [NSError errorWithDomain:NSStringFromClass([IRRepeatableStatusStream class])
                               code:IRTransactionStatusStreamErrorStatusNotReceived
                           userInfo:@{NSLocalizedDescriptionKey: message}];
}

#pragma mark - IRRepeatableStatusStreamProtocol Implementation

+ (nonnull IRPromise*)onTransactionStatus:(IRTransactionStatus)transactionStatus
                                 withHash:(NSData *)transactionHash
                                     from:(id<IRTransactionStatusStreamable>)streamable {
    return [self onTransactionStatus:transactionStatus
                            withHash:transactionHash
                                from:streamable
                     maxReconnection:3];
}

+ (nonnull IRPromise*)onTransactionStatus:(IRTransactionStatus)transactionStatus
                                 withHash:(nonnull NSData *)transactionHash
                                     from:(nonnull id<IRTransactionStatusStreamable>)streamable
                          maxReconnection:(NSUInteger)trialsCount {
    IRRepeatableStatusStream *executor = [[IRRepeatableStatusStream alloc] initWithTransactionHash:transactionHash
                                                                                     streamingFrom:streamable expecting:transactionStatus maxTrials:trialsCount];

    return [executor start];
}

@end

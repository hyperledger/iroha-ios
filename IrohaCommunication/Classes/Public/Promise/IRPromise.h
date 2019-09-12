/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <Foundation/Foundation.h>


@class IRPromise;


typedef IRPromise *_Nullable (^IRPromiseResultHandler)(id _Nullable);
typedef IRPromise *_Nullable (^IRPromiseErrorHandler)(NSError * _Nonnull);


@interface IRPromise : NSObject

@property (nonatomic, readonly) BOOL isFulfilled;
@property (nonatomic, readonly) BOOL isProcessed;
@property (nonatomic, readonly) id _Nullable result;
@property (nonatomic, readonly) IRPromise* _Nonnull (^ _Nonnull onThen)(IRPromiseResultHandler _Nonnull);
@property (nonatomic, readonly) IRPromise* _Nonnull (^ _Nonnull onError)(IRPromiseErrorHandler _Nonnull);

+ (nonnull instancetype)promise;
+ (nonnull instancetype)promiseWithResult:(nullable id)result;
- (void)fulfillWithResult:(id _Nullable)result;

@end

/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, IRTransactionStatus) {
    IRTransactionStatusStatelessValidationFailed,
    IRTransactionStatusStatelessValidationSuccess,
    IRTransactionStatusStatefulValidationFailed,
    IRTransactionStatusStatefulValidationSuccess,
    IRTransactionStatusRejected,
    IRTransactionStatusCommitted,
    IRTransactionStatusMstExpired,
    IRTransactionStatusNotReceived,
    IRTransactionStatusMstPending,
    IRTransactionStatusEnoughSignaturesCollected
};

@protocol IRTransactionStatusResponse <NSObject>

@property (nonatomic, readonly) IRTransactionStatus status;
@property (nonatomic, readonly) NSData * _Nonnull transactionHash;
@property (nonatomic, readonly) NSString * _Nullable statusDescription;

@end

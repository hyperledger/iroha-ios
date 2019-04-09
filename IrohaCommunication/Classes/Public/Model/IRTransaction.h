/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#ifndef IRTransaction_h
#define IRTransaction_h

#import "IRCommand.h"
#import "IRSignable.h"
#import "IRPeerSignature.h"
#import <IrohaCrypto/IRSignature.h>

typedef NS_ENUM(NSUInteger, IRTransactionBatchType) {
    IRTransactionBatchTypeNone,
    IRTransactionBatchTypeAtomic,
    IRTransactionBatchTypeOrdered
};

@protocol IRTransaction <NSObject, IRSignable>

@property(nonatomic, readonly)id<IRAccountId> _Nonnull creator;
@property(nonatomic, readonly)NSDate* _Nonnull createdAt;
@property(nonatomic, readonly)NSArray<id<IRCommand>>* _Nonnull commands;
@property(nonatomic, readonly)NSUInteger quorum;
@property(nonatomic, readonly)NSArray<id<IRPeerSignature>>* _Nullable signatures;
@property(nonatomic, readonly)NSArray<NSData*>* _Nullable batchHashes;
@property(nonatomic, readonly)IRTransactionBatchType batchType;

- (nullable NSData*)transactionHashWithError:(NSError*_Nullable*_Nullable)error;

- (nullable NSData*)batchHashWithError:(NSError*_Nullable*_Nullable)error;

- (nullable instancetype)signedWithSignatories:(nonnull NSArray<id<IRSignatureCreatorProtocol>>*)signatories
                           signatoryPublicKeys:(nonnull NSArray<id<IRPublicKeyProtocol>> *)signatoryPublicKeys
                                         error:(NSError*_Nullable*_Nullable)error;

- (nullable instancetype)batched:(nullable NSArray<NSData*>*)transactionBatchHashes
                       batchType:(IRTransactionBatchType)batchType
                           error:(NSError*_Nullable*_Nullable)error;

@end

#endif /* IRTransaction_h */

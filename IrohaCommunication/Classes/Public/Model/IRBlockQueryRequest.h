/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#ifndef IRBlockQueryRequest_h
#define IRBlockQueryRequest_h

#import "IRAccountId.h"
#import "IRSignable.h"
#import "IRPeerSignature.h"
#import <IrohaCrypto/IRSignature.h>

@protocol IRBlockQueryRequest <NSObject, IRSignable>

@property (nonatomic, readonly) id<IRAccountId> _Nonnull creator;
@property (nonatomic, readonly) NSDate * _Nonnull createdAt;
@property (nonatomic, readonly) UInt64 queryCounter;
@property (nonatomic, readonly) id<IRPeerSignature> _Nullable peerSignature;

- (nullable instancetype)signedWithSignatory:(nonnull id<IRSignatureCreatorProtocol>)signatory
                          signatoryPublicKey:(nonnull id<IRPublicKeyProtocol>)signatoryPublicKey
                                       error:(NSError *_Nullable*_Nullable)error;

@end

#endif

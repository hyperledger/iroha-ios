/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#ifndef IRSignable_h
#define IRSignable_h

#import <IrohaCrypto/IRSignatureCreator.h>
#import "IRPeerSignature.h"

@protocol IRSignable <NSObject>

- (nullable id<IRPeerSignature>)signWithSignatory:(nonnull id<IRSignatureCreatorProtocol>)signatory
                                   signatoryPublicKey:(nonnull id<IRPublicKeyProtocol>)signatoryPublicKey
                                                error:(NSError*_Nullable*_Nullable)error;

@end

#endif /* IRSignable_h */

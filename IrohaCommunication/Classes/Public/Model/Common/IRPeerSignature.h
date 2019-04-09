/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <Foundation/Foundation.h>
#import "IrohaCrypto/IRSignature.h"
#import "IrohaCrypto/IRPublicKey.h"

@protocol IRPeerSignature <NSObject>

@property(nonatomic, readonly)id<IRSignatureProtocol> _Nonnull signature;
@property(nonatomic, readonly)id<IRPublicKeyProtocol> _Nonnull publicKey;

@end

@protocol IRPeerSignatureFactoryProtocol <NSObject>

+ (nullable id<IRPeerSignature>)peerSignature:(nonnull id<IRSignatureProtocol>)signature
                                    publicKey:(nonnull id<IRPublicKeyProtocol>)publicKey
                                        error:(NSError*_Nullable*_Nullable)error;

@end

@interface IRPeerSignatureFactory : NSObject<IRPeerSignatureFactoryProtocol>

@end

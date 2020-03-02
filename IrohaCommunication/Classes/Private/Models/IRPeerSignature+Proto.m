/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import "IRPeerSignature+Proto.h"
#import "Primitive.pbobjc.h"
#import <IrohaCrypto/NSData+Hex.h>
#import <IrohaCrypto/IRIrohaSignature.h>
#import <IrohaCrypto/IRIrohaPublicKey.h>

@implementation IRPeerSignatureFactory (Proto)

+ (nullable id<IRPeerSignature>)peerSignatureFromPbSignature:(nonnull Signature *)pbSignature
                                                       error:(NSError *_Nullable*_Nullable)error {
    NSData *rawSignature = [[NSData alloc] initWithHexString:pbSignature.signature error:error];

    if (!rawSignature) {
        return nil;
    }

    id<IRSignatureProtocol> signature = [[IRIrohaSignature alloc] initWithRawData:rawSignature error:error];

    if (!signature) {
        return nil;
    }

    NSData *rawPublicKey = [[NSData alloc] initWithHexString:pbSignature.publicKey error:error];

    if (!rawPublicKey) {
        return nil;
    }

    id<IRPublicKeyProtocol> publicKey = [[IRIrohaPublicKey alloc] initWithRawData:rawPublicKey error:error];

    if (!publicKey) {
        return nil;
    }

    return [IRPeerSignatureFactory peerSignature:signature
                                       publicKey:publicKey
                                           error:error];
}

@end

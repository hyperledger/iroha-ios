/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import "IRPeerSignature.h"

@class Signature;

typedef NS_ENUM(NSUInteger, IRPeerSignatureFactoryProtoError) {
    IRPeerSignatureFactoryProtoErrorInvalidArgument
};

@interface IRPeerSignatureFactory (Proto)

+ (nullable id<IRPeerSignature>)peerSignatureFromPbSignature:(nonnull Signature *)pbSignature
                                                       error:(NSError *_Nullable*_Nullable)error;

@end

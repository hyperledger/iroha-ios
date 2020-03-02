/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <Foundation/Foundation.h>
#import "IRAddress.h"
#import <IrohaCrypto/IRCryptoKey.h>


@protocol IRPeer <NSObject>

@property (nonatomic, readonly, nonnull) id<IRAddress> address;
@property (nonatomic, readonly, nonnull) id<IRPublicKeyProtocol> peerKey;

@end


@protocol IRPeerFactoryProtocol <NSObject>

+ (nullable id<IRPeer>)peerWithAddress:(nonnull id<IRAddress>)address
                                   key:(nonnull id<IRPublicKeyProtocol>)key
                                 error:(NSError *_Nullable *_Nullable)error;

@end


@interface IRPeerFactory : NSObject<IRPeerFactoryProtocol>
@end

/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import "IRPeer.h"


@interface IRPeer : NSObject<IRPeer>

- (nonnull instancetype)initWithAddress:(nonnull id<IRAddress>)address
                                peerKey:(nonnull id<IRPublicKeyProtocol>)peerKey;

@end


@implementation IRPeer

@synthesize address = _address;
@synthesize peerKey = _peerKey;

- (nonnull instancetype)initWithAddress:(nonnull id<IRAddress>)address
                                peerKey:(nonnull id<IRPublicKeyProtocol>)peerKey {
    if (self = [super init]) {
        _address = address;
        _peerKey = peerKey;
    }
    
    return self;
}

@end


@implementation IRPeerFactory

+ (nullable id<IRPeer>)peerWithAddress:(nonnull id<IRAddress>)address
                                   key:(nonnull id<IRPublicKeyProtocol>)key
                                 error:(NSError *_Nullable *_Nullable)error {
    
    return [[IRPeer alloc] initWithAddress:address peerKey:key];
}

@end

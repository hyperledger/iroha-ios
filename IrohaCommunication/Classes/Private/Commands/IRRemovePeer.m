/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import "IRRemovePeer.h"
#import "Commands.pbobjc.h"
#import <IrohaCrypto/NSData+Hex.h>


@implementation IRRemovePeer

@synthesize peerKey = _peerKey;

- (nonnull instancetype)initWithPeerKey:(nonnull id<IRPublicKeyProtocol>)peerKey {
    
    if (self = [super init]) {
        _peerKey = peerKey;
    }
    
    return self;
}


#pragma mark - Protobuf Transformable

- (nullable id)transform:(NSError *__autoreleasing *)error {
    RemovePeer *removePeer = [RemovePeer new];
    removePeer.publicKey = [_peerKey.rawData toHexString];
    
    Command *command = [[Command alloc] init];
    command.removePeer = removePeer;
    
    return command;
}

@end

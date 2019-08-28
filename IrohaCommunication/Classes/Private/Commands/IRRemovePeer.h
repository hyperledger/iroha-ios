/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <Foundation/Foundation.h>
#import "IRCommand.h"
#import "IRProtobufTransformable.h"


@interface IRRemovePeer : NSObject<IRRemovePeer, IRProtobufTransformable>

- (nonnull instancetype)initWithPeerKey:(nonnull id<IRPublicKeyProtocol>)peerKey;

@end

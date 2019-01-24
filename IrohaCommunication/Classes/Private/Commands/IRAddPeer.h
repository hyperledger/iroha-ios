/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <Foundation/Foundation.h>
#import "IRCommand.h"
#import "IRProtobufTransformable.h"

@interface IRAddPeer : NSObject<IRAddPeer, IRProtobufTransformable>

- (nonnull instancetype)initWithAddress:(nonnull id<IRAddress>)address
                              publicKey:(nonnull id<IRPublicKeyProtocol>)publicKey;

@end

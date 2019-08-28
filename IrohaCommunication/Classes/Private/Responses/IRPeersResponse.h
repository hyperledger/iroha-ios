/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <Foundation/Foundation.h>
#import "IRQueryResponse.h"
#import "IRPeer.h"


@interface IRPeersResponse : NSObject<IRPeersResponse>

- (nonnull instancetype)initWithPeers:(nonnull NSArray<id<IRPeer>>*)peers queryHash:(nonnull NSData*)queryHash;

@end

/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import "IRPeersResponse.h"

@implementation IRPeersResponse

@synthesize peers = _peers;
@synthesize queryHash = _queryHash;

- (instancetype)initWithPeers:(NSArray<id<IRPeer>> *)peers queryHash:(NSData *)queryHash {
    if (self = [super init]) {
        _peers = peers;
        _queryHash = queryHash;
    }
    return self;
}

@end

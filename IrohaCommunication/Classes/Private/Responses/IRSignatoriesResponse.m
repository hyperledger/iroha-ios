/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import "IRSignatoriesResponse.h"

@implementation IRSignatoriesResponse
@synthesize publicKeys = _publicKeys;
@synthesize queryHash = _queryHash;

- (nonnull instancetype)initWithPublicKeys:(nonnull NSArray<id<IRPublicKeyProtocol>>*)publicKeys
                                 queryHash:(nonnull NSData*)queryHash {
    if (self = [super init]) {
        _publicKeys = publicKeys;
        _queryHash = queryHash;
    }

    return self;
}

@end

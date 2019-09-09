/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <Foundation/Foundation.h>
#import "IRQueryResponse.h"

@interface IRSignatoriesResponse : NSObject<IRSignatoriesResponse>

- (nonnull instancetype)initWithPublicKeys:(nonnull NSArray<id<IRPublicKeyProtocol>>*)publicKeys
                                 queryHash:(nonnull NSData *)queryHash;

@end

/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <Foundation/Foundation.h>
#import <IRQueryResponse.h>

@interface IRErrorResponse : NSObject<IRErrorResponse>

- (nonnull instancetype)initWithReason:(IRErrorResponseReason)reason
                               message:(nonnull NSString*)message
                                  code:(UInt32)code
                             queryHash:(nonnull NSData*)queryHash;

@end

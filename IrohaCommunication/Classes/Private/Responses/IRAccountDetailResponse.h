/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <Foundation/Foundation.h>
#import "IRQueryResponse.h"

@interface IRAccountDetailResponse : NSObject<IRAccountDetailResponse>

- (nonnull instancetype)initWithDetail:(nonnull NSString*)detail
                             queryHash:(nonnull NSData*)queryHash;

@end

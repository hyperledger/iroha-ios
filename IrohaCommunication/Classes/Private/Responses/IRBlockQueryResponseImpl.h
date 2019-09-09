/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <Foundation/Foundation.h>
#import "IRBlockQueryResponse.h"

@interface IRBlockQueryResponse : NSObject<IRBlockQueryResponse>

- (nonnull instancetype)initWithBlock:(nonnull id<IRBlock>)block;
- (nonnull instancetype)initWithError:(nonnull NSError *)error;

@end

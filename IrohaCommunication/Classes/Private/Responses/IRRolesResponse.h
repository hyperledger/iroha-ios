/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <Foundation/Foundation.h>
#import "IRQueryResponse.h"

@interface IRRolesResponse : NSObject<IRRolesResponse>

- (nonnull instancetype)initWithRoles:(nonnull NSArray<id<IRRoleName>>*)roles
                            queryHash:(nonnull NSData *)queryHash;

@end

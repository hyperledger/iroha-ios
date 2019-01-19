/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <Foundation/Foundation.h>
#import "IRQuery.h"
#import "IRProtobufTransformable.h"

@interface IRGetRolePermissions : NSObject<IRGetRolePermissions, IRProtobufTransformable>

- (nonnull instancetype)initWithRoleName:(nonnull id<IRRoleName>)roleName;

@end

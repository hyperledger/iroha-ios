/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <Foundation/Foundation.h>
#import "IRCommand.h"
#import "IRProtobufTransformable.h"

@interface IRRevokePermission : NSObject<IRRevokePermission, IRProtobufTransformable>

- (nonnull instancetype)initWithAccountId:(nonnull id<IRAccountId>)accountId
                               permission:(nonnull id<IRGrantablePermission>)permission;

@end

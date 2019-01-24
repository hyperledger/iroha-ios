/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <Foundation/Foundation.h>
#import "IRCommand.h"
#import "IRProtobufTransformable.h"

@interface IRAppendRole : NSObject<IRAppendRole, IRProtobufTransformable>

- (nonnull instancetype)initWithAccountId:(nonnull id<IRAccountId>)accountId
                                 roleName:(nonnull id<IRRoleName>)roleName;

@end

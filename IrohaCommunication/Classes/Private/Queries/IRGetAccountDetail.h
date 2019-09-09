/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <Foundation/Foundation.h>
#import "IRQuery.h"
#import "IRProtobufTransformable.h"

@interface IRGetAccountDetail : NSObject<IRGetAccountDetail, IRProtobufTransformable>

- (nonnull instancetype)initWithAccountId:(nullable id<IRAccountId>)accountId
                                   writer:(nullable id<IRAccountId>)writer
                                      key:(nullable NSString *)key;

- (nonnull instancetype)initWithPagination:(nonnull id<IRAccountDetailPagination>)pagination;

@end

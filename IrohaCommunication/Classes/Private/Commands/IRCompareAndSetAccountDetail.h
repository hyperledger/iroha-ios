/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <Foundation/Foundation.h>
#import "IRCommand.h"
#import "IRProtobufTransformable.h"


@interface IRCompareAndSetAccountDetail : NSObject<IRCompareAndSetAccountDetail, IRProtobufTransformable>

- (nonnull instancetype)initWithAccountId:(nonnull id<IRAccountId>)accountId
                                      key:(nonnull NSString *)key
                                    value:(nonnull NSString *)value
                                 oldValue:(nullable NSString *)oldValue;

@end

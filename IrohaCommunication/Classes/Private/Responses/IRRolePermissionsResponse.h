/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <Foundation/Foundation.h>
#import "IRQueryResponse.h"

@interface IRRolePermissionsResponse : NSObject<IRRolePermissionsResponse>

- (nonnull instancetype)initWithPermissions:(nonnull NSArray<id<IRRolePermission>>*)permissions
                                  queryHash:(nonnull NSData *)queryHash;

@end

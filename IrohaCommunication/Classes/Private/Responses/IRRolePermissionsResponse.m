/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import "IRRolePermissionsResponse.h"

@implementation IRRolePermissionsResponse
@synthesize permissions = _permissions;
@synthesize queryHash = _queryHash;

- (nonnull instancetype)initWithPermissions:(nonnull NSArray<id<IRRolePermission>>*)permissions
                                  queryHash:(nonnull NSData *)queryHash {
    if (self = [super init]) {
        _permissions = permissions;
        _queryHash = queryHash;
    }

    return self;
}

@end

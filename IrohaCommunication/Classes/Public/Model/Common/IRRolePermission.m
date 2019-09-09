/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import "IRRolePermission.h"
#import "Primitive.pbobjc.h"

@interface IRRolePermission : NSObject<IRRolePermission>

- (instancetype)initWithPermission:(RolePermission)permission;

@end

@implementation IRRolePermission
@synthesize value = _value;

- (instancetype)initWithPermission:(RolePermission)permission {
    if (self = [super init]) {
        _value = permission;
    }

    return self;
}

- (NSUInteger)hash {
    return (NSUInteger)_value;
}

- (BOOL)isEqual:(id)object {
    if (![object conformsToProtocol:@protocol(IRRolePermission)]) {
        return false;
    }

    return _value == [(id<IRRolePermission>)object value];
}

@end

@implementation IRRolePermissionFactory

+ (nullable id<IRRolePermission>)permissionWithValue:(int32_t)value error:(NSError *_Nullable*_Nullable)error {
    if (!RolePermission_IsValidValue(value)) {
        if (error) {
            NSString *message = @"Invalid role permission value passed.";
            *error = [NSError errorWithDomain:NSStringFromClass([IRRolePermissionFactory class])
                                         code:IRInvalidRolePermissionValue
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }
        return nil;
    }

    return [[IRRolePermission alloc] initWithPermission:value];
}

#pragma mark - Command Permissions

+ (nonnull id<IRRolePermission>)canAppendRole {
    return [self permissionWithValue:RolePermission_CanAppendRole error:nil];
}

+ (nonnull id<IRRolePermission>)canCreateRole {
    return [self permissionWithValue:RolePermission_CanCreateRole error:nil];
}

+ (nonnull id<IRRolePermission>)canDetachRole {
    return [self permissionWithValue:RolePermission_CanDetachRole error:nil];
}

+ (nonnull id<IRRolePermission>)canAddAssetQuantity {
    return [self permissionWithValue:RolePermission_CanAddAssetQty error:nil];
}

+ (nonnull id<IRRolePermission>)canSubtractAssetQuantity {
    return [self permissionWithValue:RolePermission_CanSubtractAssetQty error:nil];
}

+ (nonnull id<IRRolePermission>)canAddPeer {
    return [self permissionWithValue:RolePermission_CanAddPeer error:nil];
}

+ (id<IRRolePermission>)canRemovePeer {
    return [self permissionWithValue:RolePermission_CanRemovePeer error:nil];
}

+ (nonnull id<IRRolePermission>)canAddSignatory {
    return [self permissionWithValue:RolePermission_CanAddSignatory error:nil];
}

+ (nonnull id<IRRolePermission>)canRemoveSignatory {
    return [self permissionWithValue:RolePermission_CanRemoveSignatory error:nil];
}

+ (nonnull id<IRRolePermission>)canSetQuorum {
    return [self permissionWithValue:RolePermission_CanSetQuorum error:nil];
}

+ (nonnull id<IRRolePermission>)canCreateAccount {
    return [self permissionWithValue:RolePermission_CanCreateAccount error:nil];
}

+ (nonnull id<IRRolePermission>)canSetDetail {
    return [self permissionWithValue:RolePermission_CanSetDetail error:nil];
}

+ (nonnull id<IRRolePermission>)canCreateAsset {
    return [self permissionWithValue:RolePermission_CanCreateAsset error:nil];
}

+ (nonnull id<IRRolePermission>)canTransfer {
    return [self permissionWithValue:RolePermission_CanTransfer error:nil];
}

+ (nonnull id<IRRolePermission>)canReceive {
    return [self permissionWithValue:RolePermission_CanReceive error:nil];
}

+ (nonnull id<IRRolePermission>)canCreateDomain {
    return [self permissionWithValue:RolePermission_CanCreateDomain error:nil];
}

+ (nonnull id<IRRolePermission>)canAddDomainAssetQuantity {
    return [self permissionWithValue:RolePermission_CanAddDomainAssetQty error:nil];
}

+ (nonnull id<IRRolePermission>)canSubtractDomainAssetQuantity {
    return [self permissionWithValue:RolePermission_CanSubtractDomainAssetQty error:nil];
}

#pragma mark - Query permissions

+ (nonnull id<IRRolePermission>)canReadAssets {
    return [self permissionWithValue:RolePermission_CanReadAssets error:nil];
}

+ (nonnull id<IRRolePermission>)canGetRoles {
    return [self permissionWithValue:RolePermission_CanGetRoles error:nil];
}

+ (nonnull id<IRRolePermission>)canGetMyAccount {
    return [self permissionWithValue:RolePermission_CanGetMyAccount error:nil];
}

+ (nonnull id<IRRolePermission>)canGetAllAccounts {
    return [self permissionWithValue:RolePermission_CanGetAllAccounts error:nil];
}

+ (nonnull id<IRRolePermission>)canGetDomainAccounts {
    return [self permissionWithValue:RolePermission_CanGetDomainAccounts error:nil];
}

+ (nonnull id<IRRolePermission>)canGetMySignatories {
    return [self permissionWithValue:RolePermission_CanGetMySignatories error:nil];
}

+ (nonnull id<IRRolePermission>)canGetAllSignatories {
    return [self permissionWithValue:RolePermission_CanGetAllSignatories error:nil];
}

+ (nonnull id<IRRolePermission>)canGetDomainSignatories {
    return [self permissionWithValue:RolePermission_CanGetDomainSignatories error:nil];
}

+ (nonnull id<IRRolePermission>)canGetMyAccountAssets {
    return [self permissionWithValue:RolePermission_CanGetMyAccAst error:nil];
}

+ (nonnull id<IRRolePermission>)canGetAllAccountAssets {
    return [self permissionWithValue:RolePermission_CanGetAllAccAst error:nil];
}

+ (nonnull id<IRRolePermission>)canGetDomainAccountAssets {
    return [self permissionWithValue:RolePermission_CanGetDomainAccAst error:nil];
}

+ (nonnull id<IRRolePermission>)canGetMyAccountDetail {
    return [self permissionWithValue:RolePermission_CanGetMyAccDetail error:nil];
}

+ (nonnull id<IRRolePermission>)canGetAllAccountDetail {
    return [self permissionWithValue:RolePermission_CanGetAllAccDetail error:nil];
}

+ (nonnull id<IRRolePermission>)canGetDomainAccountDetail {
    return [self permissionWithValue:RolePermission_CanGetDomainAccDetail error:nil];
}

+ (nonnull id<IRRolePermission>)canGetMyAccountTransactions {
    return [self permissionWithValue:RolePermission_CanGetMyAccTxs error:nil];
}

+ (nonnull id<IRRolePermission>)canGetAllAccountTransactions {
    return [self permissionWithValue:RolePermission_CanGetAllAccTxs error:nil];
}

+ (nonnull id<IRRolePermission>)canGetDomainAccountTransactions {
    return [self permissionWithValue:RolePermission_CanGetDomainAccTxs error:nil];
}

+ (nonnull id<IRRolePermission>)canGetMyAccountAssetTransactions {
    return [self permissionWithValue:RolePermission_CanGetMyAccAstTxs error:nil];
}

+ (nonnull id<IRRolePermission>)canGetAllAccountAssetTransactions {
    return [self permissionWithValue:RolePermission_CanGetAllAccAstTxs error:nil];
}

+ (nonnull id<IRRolePermission>)canGetDomainAccountAsssetTransactions {
    return [self permissionWithValue:RolePermission_CanGetDomainAccAstTxs error:nil];
}

+ (nonnull id<IRRolePermission>)canGetMyTransactions {
    return [self permissionWithValue:RolePermission_CanGetMyTxs error:nil];
}

+ (nonnull id<IRRolePermission>)canGetAllTransactions {
    return [self permissionWithValue:RolePermission_CanGetAllTxs error:nil];
}

+ (nonnull id<IRRolePermission>)canGetBlocks {
    return [self permissionWithValue:RolePermission_CanGetBlocks error:nil];
}

+ (id<IRRolePermission>)canGetPeers {
    return [self permissionWithValue:RolePermission_CanGetPeers error:nil];
}

#pragma mark - Grant permissions

+ (nonnull id<IRRolePermission>)canGrantCanSetMyQuorum {
    return [self permissionWithValue:RolePermission_CanGrantCanSetMyQuorum error:nil];
}

+ (nonnull id<IRRolePermission>)canGrantCanAddMySignatory {
    return [self permissionWithValue:RolePermission_CanGrantCanAddMySignatory error:nil];
}

+ (nonnull id<IRRolePermission>)canGrantCanRemoveMySignatory {
    return [self permissionWithValue:RolePermission_CanGrantCanRemoveMySignatory error:nil];
}

+ (nonnull id<IRRolePermission>)canGrantCanTransferMyAssets {
    return [self permissionWithValue:RolePermission_CanGrantCanTransferMyAssets error:nil];
}

+ (nonnull id<IRRolePermission>)canGrantCanSetMyAccountDetail {
    return [self permissionWithValue:RolePermission_CanGrantCanSetMyAccountDetail error:nil];
}

@end

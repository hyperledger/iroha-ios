/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <Foundation/Foundation.h>

@protocol IRRolePermission <NSObject>

@property(nonatomic, readonly)int32_t value;

@end

typedef NS_ENUM(NSUInteger, IRRolePermissionError) {
    IRInvalidRolePermissionValue
};

@protocol IRRolePermissionFactoryProtocol <NSObject>

+ (nullable id<IRRolePermission>)permissionWithValue:(int32_t)value error:(NSError*_Nullable*_Nullable)error;

@end

@interface IRRolePermissionFactory : NSObject<IRRolePermissionFactoryProtocol>

#pragma mark - Command Permissions

+ (nonnull id<IRRolePermission>)canAppendRole;
+ (nonnull id<IRRolePermission>)canCreateRole;
+ (nonnull id<IRRolePermission>)canDetachRole;
+ (nonnull id<IRRolePermission>)canAddAssetQuantity;
+ (nonnull id<IRRolePermission>)canSubtractAssetQuantity;
+ (nonnull id<IRRolePermission>)canAddPeer;
+ (nonnull id<IRRolePermission>)canRemovePeer;
+ (nonnull id<IRRolePermission>)canAddSignatory;
+ (nonnull id<IRRolePermission>)canRemoveSignatory;
+ (nonnull id<IRRolePermission>)canSetQuorum;
+ (nonnull id<IRRolePermission>)canCreateAccount;
+ (nonnull id<IRRolePermission>)canSetDetail;
+ (nonnull id<IRRolePermission>)canCreateAsset;
+ (nonnull id<IRRolePermission>)canTransfer;
+ (nonnull id<IRRolePermission>)canReceive;
+ (nonnull id<IRRolePermission>)canCreateDomain;
+ (nonnull id<IRRolePermission>)canAddDomainAssetQuantity;
+ (nonnull id<IRRolePermission>)canSubtractDomainAssetQuantity;

#pragma mark - Query permissions

+ (nonnull id<IRRolePermission>)canReadAssets;
+ (nonnull id<IRRolePermission>)canGetRoles;
+ (nonnull id<IRRolePermission>)canGetMyAccount;
+ (nonnull id<IRRolePermission>)canGetAllAccounts;
+ (nonnull id<IRRolePermission>)canGetDomainAccounts;
+ (nonnull id<IRRolePermission>)canGetMySignatories;
+ (nonnull id<IRRolePermission>)canGetAllSignatories;
+ (nonnull id<IRRolePermission>)canGetDomainSignatories;
+ (nonnull id<IRRolePermission>)canGetMyAccountAssets;
+ (nonnull id<IRRolePermission>)canGetAllAccountAssets;
+ (nonnull id<IRRolePermission>)canGetDomainAccountAssets;
+ (nonnull id<IRRolePermission>)canGetMyAccountDetail;
+ (nonnull id<IRRolePermission>)canGetAllAccountDetail;
+ (nonnull id<IRRolePermission>)canGetDomainAccountDetail;
+ (nonnull id<IRRolePermission>)canGetMyAccountTransactions;
+ (nonnull id<IRRolePermission>)canGetAllAccountTransactions;
+ (nonnull id<IRRolePermission>)canGetDomainAccountTransactions;
+ (nonnull id<IRRolePermission>)canGetMyAccountAssetTransactions;
+ (nonnull id<IRRolePermission>)canGetAllAccountAssetTransactions;
+ (nonnull id<IRRolePermission>)canGetDomainAccountAsssetTransactions;
+ (nonnull id<IRRolePermission>)canGetMyTransactions;
+ (nonnull id<IRRolePermission>)canGetAllTransactions;
+ (nonnull id<IRRolePermission>)canGetBlocks;
+ (nonnull id<IRRolePermission>)canGetPeers;

#pragma mark - Grant permissions

+ (nonnull id<IRRolePermission>)canGrantCanSetMyQuorum;
+ (nonnull id<IRRolePermission>)canGrantCanAddMySignatory;
+ (nonnull id<IRRolePermission>)canGrantCanRemoveMySignatory;
+ (nonnull id<IRRolePermission>)canGrantCanTransferMyAssets;
+ (nonnull id<IRRolePermission>)canGrantCanSetMyAccountDetail;

@end

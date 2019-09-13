/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger, IRRolePermissionError) {
    IRInvalidRolePermissionValue
};


@protocol IRRolePermission <NSObject>

@property (nonatomic, readonly) int32_t value;

@end


@protocol IRRolePermissionFactoryProtocol <NSObject>

+ (nullable id<IRRolePermission>)permissionWithValue:(int32_t)value error:(NSError *_Nullable*_Nullable)error;

@end


@interface IRRolePermissionFactory : NSObject<IRRolePermissionFactoryProtocol>


#pragma mark - Command Permissions

+ (id<IRRolePermission>)canAppendRole;
+ (id<IRRolePermission>)canCreateRole;
+ (id<IRRolePermission>)canDetachRole;
+ (id<IRRolePermission>)canAddAssetQuantity;
+ (id<IRRolePermission>)canSubtractAssetQuantity;
+ (id<IRRolePermission>)canAddPeer;
+ (id<IRRolePermission>)canRemovePeer;
+ (id<IRRolePermission>)canAddSignatory;
+ (id<IRRolePermission>)canRemoveSignatory;
+ (id<IRRolePermission>)canSetQuorum;
+ (id<IRRolePermission>)canCreateAccount;
+ (id<IRRolePermission>)canSetDetail;
+ (id<IRRolePermission>)canCreateAsset;
+ (id<IRRolePermission>)canTransfer;
+ (id<IRRolePermission>)canReceive;
+ (id<IRRolePermission>)canCreateDomain;
+ (id<IRRolePermission>)canAddDomainAssetQuantity;
+ (id<IRRolePermission>)canSubtractDomainAssetQuantity;


#pragma mark - Query permissions

+ (id<IRRolePermission>)canReadAssets;
+ (id<IRRolePermission>)canGetRoles;
+ (id<IRRolePermission>)canGetMyAccount;
+ (id<IRRolePermission>)canGetAllAccounts;
+ (id<IRRolePermission>)canGetDomainAccounts;
+ (id<IRRolePermission>)canGetMySignatories;
+ (id<IRRolePermission>)canGetAllSignatories;
+ (id<IRRolePermission>)canGetDomainSignatories;
+ (id<IRRolePermission>)canGetMyAccountAssets;
+ (id<IRRolePermission>)canGetAllAccountAssets;
+ (id<IRRolePermission>)canGetDomainAccountAssets;
+ (id<IRRolePermission>)canGetMyAccountDetail;
+ (id<IRRolePermission>)canGetAllAccountDetail;
+ (id<IRRolePermission>)canGetDomainAccountDetail;
+ (id<IRRolePermission>)canGetMyAccountTransactions;
+ (id<IRRolePermission>)canGetAllAccountTransactions;
+ (id<IRRolePermission>)canGetDomainAccountTransactions;
+ (id<IRRolePermission>)canGetMyAccountAssetTransactions;
+ (id<IRRolePermission>)canGetAllAccountAssetTransactions;
+ (id<IRRolePermission>)canGetDomainAccountAsssetTransactions;
+ (id<IRRolePermission>)canGetMyTransactions;
+ (id<IRRolePermission>)canGetAllTransactions;
+ (id<IRRolePermission>)canGetBlocks;
+ (id<IRRolePermission>)canGetPeers;


#pragma mark - Grant permissions

+ (id<IRRolePermission>)canGrantCanSetMyQuorum;
+ (id<IRRolePermission>)canGrantCanAddMySignatory;
+ (id<IRRolePermission>)canGrantCanRemoveMySignatory;
+ (id<IRRolePermission>)canGrantCanTransferMyAssets;
+ (id<IRRolePermission>)canGrantCanSetMyAccountDetail;

@end


NS_ASSUME_NONNULL_END

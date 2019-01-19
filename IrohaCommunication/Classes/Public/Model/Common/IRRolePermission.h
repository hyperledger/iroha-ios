#import <Foundation/Foundation.h>

@protocol IRRolePermission <NSObject>

@property(nonatomic, readonly)int32_t value;

@end

typedef NS_ENUM(NSUInteger, IRRolePermissionError) {
    IRInvalidRolePermissionValue
};

@protocol IRRolePermissionFactoryProtocol <NSObject>

+ (nullable id<IRRolePermission>)permissionWithValue:(int32_t)value error:(NSError**)error;

@end

@interface IRRolePermissionFactory : NSObject<IRRolePermissionFactoryProtocol>

#pragma mark - Command Permissions

+ (id<IRRolePermission>)canAppendRole;
+ (id<IRRolePermission>)canCreateRole;
+ (id<IRRolePermission>)canDetachRole;
+ (id<IRRolePermission>)canAddAssetQuantity;
+ (id<IRRolePermission>)canSubtractAssetQuantity;
+ (id<IRRolePermission>)canAddPeer;
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

#pragma mark - Grant permissions

+ (id<IRRolePermission>)canGrantCanSetMyQuorum;
+ (id<IRRolePermission>)canGrantCanAddMySignatory;
+ (id<IRRolePermission>)canGrantCanRemoveMySignatory;
+ (id<IRRolePermission>)canGrantCanTransferMyAssets;
+ (id<IRRolePermission>)canGrantCanSetMyAccountDetail;

@end

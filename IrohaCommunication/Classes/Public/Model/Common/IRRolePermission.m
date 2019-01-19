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

+ (nullable id<IRRolePermission>)permissionWithValue:(int32_t)value error:(NSError**)error {
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

+ (id<IRRolePermission>)canAppendRole {
    return [self permissionWithValue:RolePermission_CanAppendRole error:nil];
}

+ (id<IRRolePermission>)canCreateRole {
    return [self permissionWithValue:RolePermission_CanCreateRole error:nil];
}

+ (id<IRRolePermission>)canDetachRole {
    return [self permissionWithValue:RolePermission_CanDetachRole error:nil];
}

+ (id<IRRolePermission>)canAddAssetQuantity {
    return [self permissionWithValue:RolePermission_CanAddAssetQty error:nil];
}

+ (id<IRRolePermission>)canSubtractAssetQuantity {
    return [self permissionWithValue:RolePermission_CanSubtractAssetQty error:nil];
}

+ (id<IRRolePermission>)canAddPeer {
    return [self permissionWithValue:RolePermission_CanAddPeer error:nil];
}

+ (id<IRRolePermission>)canAddSignatory {
    return [self permissionWithValue:RolePermission_CanAddSignatory error:nil];
}

+ (id<IRRolePermission>)canRemoveSignatory {
    return [self permissionWithValue:RolePermission_CanRemoveSignatory error:nil];
}

+ (id<IRRolePermission>)canSetQuorum {
    return [self permissionWithValue:RolePermission_CanSetQuorum error:nil];
}

+ (id<IRRolePermission>)canCreateAccount {
    return [self permissionWithValue:RolePermission_CanCreateAccount error:nil];
}

+ (id<IRRolePermission>)canSetDetail {
    return [self permissionWithValue:RolePermission_CanSetDetail error:nil];
}

+ (id<IRRolePermission>)canCreateAsset {
    return [self permissionWithValue:RolePermission_CanCreateAsset error:nil];
}

+ (id<IRRolePermission>)canTransfer {
    return [self permissionWithValue:RolePermission_CanTransfer error:nil];
}

+ (id<IRRolePermission>)canReceive {
    return [self permissionWithValue:RolePermission_CanReceive error:nil];
}

+ (id<IRRolePermission>)canCreateDomain {
    return [self permissionWithValue:RolePermission_CanCreateDomain error:nil];
}

+ (id<IRRolePermission>)canAddDomainAssetQuantity {
    return [self permissionWithValue:RolePermission_CanAddDomainAssetQty error:nil];
}

+ (id<IRRolePermission>)canSubtractDomainAssetQuantity {
    return [self permissionWithValue:RolePermission_CanSubtractDomainAssetQty error:nil];
}

#pragma mark - Query permissions

+ (id<IRRolePermission>)canReadAssets {
    return [self permissionWithValue:RolePermission_CanReadAssets error:nil];
}

+ (id<IRRolePermission>)canGetRoles {
    return [self permissionWithValue:RolePermission_CanGetRoles error:nil];
}

+ (id<IRRolePermission>)canGetMyAccount {
    return [self permissionWithValue:RolePermission_CanGetMyAccount error:nil];
}

+ (id<IRRolePermission>)canGetAllAccounts {
    return [self permissionWithValue:RolePermission_CanGetAllAccounts error:nil];
}

+ (id<IRRolePermission>)canGetDomainAccounts {
    return [self permissionWithValue:RolePermission_CanGetDomainAccounts error:nil];
}

+ (id<IRRolePermission>)canGetMySignatories {
    return [self permissionWithValue:RolePermission_CanGetMySignatories error:nil];
}

+ (id<IRRolePermission>)canGetAllSignatories {
    return [self permissionWithValue:RolePermission_CanGetAllSignatories error:nil];
}

+ (id<IRRolePermission>)canGetDomainSignatories {
    return [self permissionWithValue:RolePermission_CanGetDomainSignatories error:nil];
}

+ (id<IRRolePermission>)canGetMyAccountAssets {
    return [self permissionWithValue:RolePermission_CanGetMyAccAst error:nil];
}

+ (id<IRRolePermission>)canGetAllAccountAssets {
    return [self permissionWithValue:RolePermission_CanGetAllAccAst error:nil];
}

+ (id<IRRolePermission>)canGetDomainAccountAssets {
    return [self permissionWithValue:RolePermission_CanGetDomainAccAst error:nil];
}

+ (id<IRRolePermission>)canGetMyAccountDetail {
    return [self permissionWithValue:RolePermission_CanGetMyAccDetail error:nil];
}

+ (id<IRRolePermission>)canGetAllAccountDetail {
    return [self permissionWithValue:RolePermission_CanGetAllAccDetail error:nil];
}

+ (id<IRRolePermission>)canGetDomainAccountDetail {
    return [self permissionWithValue:RolePermission_CanGetDomainAccDetail error:nil];
}

+ (id<IRRolePermission>)canGetMyAccountTransactions {
    return [self permissionWithValue:RolePermission_CanGetMyAccTxs error:nil];
}

+ (id<IRRolePermission>)canGetAllAccountTransactions {
    return [self permissionWithValue:RolePermission_CanGetAllAccTxs error:nil];
}

+ (id<IRRolePermission>)canGetDomainAccountTransactions {
    return [self permissionWithValue:RolePermission_CanGetDomainAccTxs error:nil];
}

+ (id<IRRolePermission>)canGetMyAccountAssetTransactions {
    return [self permissionWithValue:RolePermission_CanGetMyAccAstTxs error:nil];
}

+ (id<IRRolePermission>)canGetAllAccountAssetTransactions {
    return [self permissionWithValue:RolePermission_CanGetAllAccAstTxs error:nil];
}

+ (id<IRRolePermission>)canGetDomainAccountAsssetTransactions {
    return [self permissionWithValue:RolePermission_CanGetDomainAccAstTxs error:nil];
}

+ (id<IRRolePermission>)canGetMyTransactions {
    return [self permissionWithValue:RolePermission_CanGetMyTxs error:nil];
}

+ (id<IRRolePermission>)canGetAllTransactions {
    return [self permissionWithValue:RolePermission_CanGetAllTxs error:nil];
}

+ (id<IRRolePermission>)canGetBlocks {
    return [self permissionWithValue:RolePermission_CanGetBlocks error:nil];
}

#pragma mark - Grant permissions

+ (id<IRRolePermission>)canGrantCanSetMyQuorum {
    return [self permissionWithValue:RolePermission_CanGrantCanSetMyQuorum error:nil];
}

+ (id<IRRolePermission>)canGrantCanAddMySignatory {
    return [self permissionWithValue:RolePermission_CanGrantCanAddMySignatory error:nil];
}

+ (id<IRRolePermission>)canGrantCanRemoveMySignatory {
    return [self permissionWithValue:RolePermission_CanGrantCanRemoveMySignatory error:nil];
}

+ (id<IRRolePermission>)canGrantCanTransferMyAssets {
    return [self permissionWithValue:RolePermission_CanGrantCanTransferMyAssets error:nil];
}

+ (id<IRRolePermission>)canGrantCanSetMyAccountDetail {
    return [self permissionWithValue:RolePermission_CanGrantCanSetMyAccountDetail error:nil];
}

@end

#import "IRCommand+Proto.h"
#import "Commands.pbobjc.h"
#import "Primitive.pbobjc.h"
#import "IrohaCrypto/NSData+Hex.h"

@implementation IRCommandProtoFactory

+ (nullable id<IRCommand>)commandFromPbCommand:(nonnull Command*)command
                                         error:(NSError*_Nullable*_Nullable)error {
    switch (command.commandOneOfCase) {
        case Command_Command_OneOfCase_AddPeer:
            return [self addPeerCommandFromPbCommand:command.addPeer
                                               error:error];
            break;
        case Command_Command_OneOfCase_AppendRole:
            return [self appendRoleCommandFromPbCommand:command.appendRole
                                                  error:error];
            break;
        case Command_Command_OneOfCase_CreateRole:
            return [self createRoleCommandFromPbCommand:command.createRole
                                                  error:error];
            break;
        case Command_Command_OneOfCase_DetachRole:
            return [self detachRoleCommandFromPbCommand:command.detachRole
                                                  error:error];
            break;
        case Command_Command_OneOfCase_CreateAsset:
            return [self createAssetCommandFromPbCommand:command.createAsset
                                                   error:error];
            break;
        case Command_Command_OneOfCase_AddSignatory:
            return [self addSignatoryCommandFromPbCommand:command.addSignatory
                                                    error:error];
            break;
        case Command_Command_OneOfCase_CreateDomain:
            return [self createDomainCommandFromPbCommand:command.createDomain
                                                    error:error];
            break;
        case Command_Command_OneOfCase_CreateAccount:
            return [self createAccountCommandFromPbCommand:command.createAccount
                                                     error:error];
            break;
        case Command_Command_OneOfCase_TransferAsset:
            return [self transferAssetCommandWithPbCommand:command.transferAsset
                                                     error:error];
            break;
        case Command_Command_OneOfCase_GrantPermission:
            return [self grantPermissionCommandFromPbCommand:command.grantPermission
                                                       error:error];
            break;
        case Command_Command_OneOfCase_RemoveSignatory:
            return [self removeSignatoryCommandFromPbCommand:command.removeSignatory
                                                       error:error];
            break;
        case Command_Command_OneOfCase_AddAssetQuantity:
            return [self addAssetQuantityCommandFromPbCommand:command.addAssetQuantity
                                                        error:error];
            break;
        case Command_Command_OneOfCase_RevokePermission:
            return [self revokePermissionCommandFromPbCommand:command.revokePermission
                                                        error:error];
            break;
        case Command_Command_OneOfCase_SetAccountDetail:
            return [self setAccountDetailCommandFromPbCommand:command.setAccountDetail
                                                        error:error];
            break;
        case Command_Command_OneOfCase_SetAccountQuorum:
            return [self setAccountQuorumCommandPbCommand:command.setAccountQuorum
                                                    error:error];
            break;
        case Command_Command_OneOfCase_SubtractAssetQuantity:
            return [self subtractAssetQuantityCommandFromPbCommand:command.subtractAssetQuantity
                                                             error:error];
            break;
        default:
            if (error) {
                NSString *message = [NSString stringWithFormat:@"Invalid transaction command %@", @(command.commandOneOfCase)];
                *error = [NSError errorWithDomain:NSStringFromClass([IRCommandProtoFactory class])
                                             code:IRCommandProtoFactoryErrorInvalidArgument
                                         userInfo:@{NSLocalizedDescriptionKey: message}];
            }
            return nil;
            break;
    }
}

+ (nullable id<IRAddPeer>)addPeerCommandFromPbCommand:(nonnull AddPeer*)pbCommand
                                                error:(NSError*_Nullable*_Nullable)error {

    id<IRAddress> address = [IRAddressFactory addressWithValue:pbCommand.peer.address
                                                         error:error];

    if (!address) {
        return nil;
    }

    NSData *rawPublicKey = [[NSData alloc] initWithHexString:pbCommand.peer.peerKey];

    if (!rawPublicKey) {
        if (error) {
            NSString *message = [NSString stringWithFormat:@"Invalid public key hex %@", pbCommand.peer.peerKey];
            *error = [NSError errorWithDomain:NSStringFromClass([IRCommandProtoFactory class])
                                         code:IRCommandProtoFactoryErrorInvalidArgument
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }
        return nil;
    }

    id<IRPublicKeyProtocol> publicKey = [self createPublicKeyFromRawData:rawPublicKey
                                                                   error:error];

    if (!publicKey) {
        return nil;
    }

    return [[IRAddPeer alloc] initWithAddress:address
                                    publicKey:publicKey];
}

+ (nullable id<IRAppendRole>)appendRoleCommandFromPbCommand:(nonnull AppendRole*)pbCommand
                                                      error:(NSError**)error {
    id<IRAccountId> accountId = [IRAccountIdFactory accountWithIdentifier:pbCommand.accountId
                                                                    error:error];
    if (!accountId) {
        return nil;
    }

    id<IRRoleName> roleName = [IRRoleNameFactory roleWithName:pbCommand.roleName
                                                        error:error];

    if (!roleName) {
        return nil;
    }

    return [[IRAppendRole alloc] initWithAccountId:accountId
                                          roleName:roleName];
}

+ (nullable id<IRCreateRole>)createRoleCommandFromPbCommand:(nonnull CreateRole*)pbCommand error:(NSError**)error {
    id<IRRoleName> roleName = [IRRoleNameFactory roleWithName:pbCommand.roleName
                                                        error:error];

    if (!roleName) {
        return nil;
    }

    NSMutableArray<id<IRRolePermission>> *permissions = [NSMutableArray array];
    for (NSUInteger i = 0; i < pbCommand.permissionsArray.count; i++) {
        uint32_t pbPermission = [pbCommand.permissionsArray valueAtIndex:i];
        id<IRRolePermission> permission = [IRRolePermissionFactory permissionWithValue:pbPermission
                                                                                 error:error];

        if (!permission) {
            return nil;
        }

        [permissions addObject:permission];
    }

    return [[IRCreateRole alloc] initWithRoleName:roleName
                                      permissions:permissions];
}

+ (nullable id<IRDetachRole>)detachRoleCommandFromPbCommand:(nonnull DetachRole*)pbCommand error:(NSError**)error {
    id<IRAccountId> accountId = [IRAccountIdFactory accountWithIdentifier:pbCommand.accountId
                                                                    error:error];

    if (!accountId) {
        return nil;
    }

    id<IRRoleName> roleName = [IRRoleNameFactory roleWithName:pbCommand.roleName
                                                        error:error];

    if (!roleName) {
        return nil;
    }

    return [[IRDetachRole alloc] initWithAccountId:accountId
                                          roleName:roleName];
}

+ (nullable id<IRCreateAsset>)createAssetCommandFromPbCommand:(nonnull CreateAsset*)pbCommand
                                                        error:(NSError**)error {

    id<IRDomain> domain = [IRDomainFactory domainWithIdentitifer:pbCommand.domainId
                                                           error:error];

    if (!domain) {
        return nil;
    }

    id<IRAssetId> assetId = [IRAssetIdFactory assetIdWithName:pbCommand.assetName
                                                       domain:domain
                                                        error:error];

    if (!assetId) {
        return nil;
    }

    return [[IRCreateAsset alloc] initWithAssetId:assetId
                                        precision:pbCommand.precision];
}

+ (nullable id<IRAddSignatory>)addSignatoryCommandFromPbCommand:(nonnull AddSignatory*)pbCommand
                                                          error:(NSError**)error {

    id<IRAccountId> accountId = [IRAccountIdFactory accountWithIdentifier:pbCommand.accountId
                                                                    error:error];

    if (!accountId) {
        return nil;
    }

    NSData *rawPublicKey = [[NSData alloc] initWithHexString:pbCommand.publicKey];

    if (!rawPublicKey) {
        if (error) {
            NSString *message = [NSString stringWithFormat:@"Invalid public key hex %@", pbCommand.publicKey];
            *error = [NSError errorWithDomain:NSStringFromClass([IRCommandProtoFactory class])
                                         code:IRCommandProtoFactoryErrorInvalidArgument
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }
        return nil;
    }

    id<IRPublicKeyProtocol> publicKey = [self createPublicKeyFromRawData:rawPublicKey
                                                                   error:error];

    if (!publicKey) {
        return nil;
    }

    return [[IRAddSignatory alloc] initWithAccountId:accountId
                                           publicKey:publicKey];
}

+ (nullable id<IRCreateDomain>)createDomainCommandFromPbCommand:(nonnull CreateDomain*)pbCommand error:(NSError**)error {
    id<IRDomain> domain = [IRDomainFactory domainWithIdentitifer:pbCommand.domainId
                                                           error:error];

    if (!domain) {
        return nil;
    }

    id<IRRoleName> defaultRole = nil;

    if (pbCommand.defaultRole) {
        defaultRole = [IRRoleNameFactory roleWithName:pbCommand.defaultRole error:error];

        if (!defaultRole) {
            return nil;
        }
    }

    return [[IRCreateDomain alloc] initWithDomain:domain
                                      defaultRole:defaultRole];
}

+ (nullable id<IRCreateAccount>)createAccountCommandFromPbCommand:(nonnull CreateAccount*)pbCommand
                                                            error:(NSError**)error {

    id<IRDomain> domain = [IRDomainFactory domainWithIdentitifer:pbCommand.domainId
                                                           error:error];

    if (!domain) {
        return nil;
    }

    id<IRAccountId> accountId = [IRAccountIdFactory accountIdWithName:pbCommand.accountName
                                                               domain:domain
                                                                error:error];

    if (!accountId) {
        return nil;
    }

    NSData *rawPublicKey = [[NSData alloc] initWithHexString:pbCommand.publicKey];

    if (!rawPublicKey) {
        if (error) {
            NSString *message = [NSString stringWithFormat:@"Invalid public key hex %@", pbCommand.publicKey];
            *error = [NSError errorWithDomain:NSStringFromClass([IRCommandProtoFactory class])
                                         code:IRCommandProtoFactoryErrorInvalidArgument
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }
        return nil;
    }

    id<IRPublicKeyProtocol> publicKey = [self createPublicKeyFromRawData:rawPublicKey
                                                                   error:error];

    return [[IRCreateAccount alloc] initWithAccountId:accountId
                                            publicKey:publicKey];
}

+ (nullable id<IRTransferAsset>)transferAssetCommandWithPbCommand:(nonnull TransferAsset*)pbCommand
                                                            error:(NSError**)error {
    id<IRAccountId> sourceAccountId = [IRAccountIdFactory accountWithIdentifier:pbCommand.srcAccountId
                                                                          error:error];

    if (!sourceAccountId) {
        return nil;
    }

    id<IRAccountId> destinationAccountId = [IRAccountIdFactory accountWithIdentifier:pbCommand.destAccountId
                                                                               error:error];

    if (!destinationAccountId) {
        return nil;
    }

    id<IRAssetId> assetId = [IRAssetIdFactory assetWithIdentifier:pbCommand.assetId
                                                            error:error];

    if (!assetId) {
        return nil;
    }

    NSString *transferDescription = pbCommand.description_p ? pbCommand.description_p : @"";

    id<IRAmount> amount = [IRAmountFactory amountFromString:pbCommand.amount
                                                      error:error];

    if (!amount) {
        return nil;
    }

    return [[IRTransferAsset alloc] initWithSourceAccountId:sourceAccountId
                                       destinationAccountId:destinationAccountId
                                                    assetId:assetId
                                        transferDescription:transferDescription
                                                     amount:amount];
}

+ (nullable id<IRGrantPermission>)grantPermissionCommandFromPbCommand:(nonnull GrantPermission*)pbCommand
                                                                error:(NSError**)error {
    id<IRAccountId> accountId = [IRAccountIdFactory accountWithIdentifier:pbCommand.accountId
                                                                    error:error];

    if (!accountId) {
        return nil;
    }

    id<IRGrantablePermission> permission = [IRGrantablePermissionFactory permissionWithValue:pbCommand.permission
                                                                                       error:error];

    if (!permission) {
        return nil;
    }

    return [[IRGrantPermission alloc] initWithAccountId:accountId
                                             permission:permission];
}

+ (nullable id<IRRemoveSignatory>)removeSignatoryCommandFromPbCommand:(nonnull RemoveSignatory*)pbCommand
                                                                error:(NSError**)error {

    id<IRAccountId> accountId = [IRAccountIdFactory accountWithIdentifier:pbCommand.accountId
                                                                    error:error];

    if (!accountId) {
        return nil;
    }

    NSData *rawPublicKey = [[NSData alloc] initWithHexString:pbCommand.publicKey];

    if (!rawPublicKey) {
        if (error) {
            NSString *message = [NSString stringWithFormat:@"Invalid public key hex %@", pbCommand.publicKey];
            *error = [NSError errorWithDomain:NSStringFromClass([IRCommandProtoFactory class])
                                         code:IRCommandProtoFactoryErrorInvalidArgument
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }
        return nil;
    }

    id<IRPublicKeyProtocol> publicKey = [self createPublicKeyFromRawData:rawPublicKey
                                                                   error:error];

    if (!publicKey) {
        return nil;
    }

    return [[IRRemoveSignatory alloc] initWithAccountId:accountId
                                              publicKey:publicKey];
}

+ (nullable id<IRAddAssetQuantity>)addAssetQuantityCommandFromPbCommand:(nonnull AddAssetQuantity*)pbCommand
                                                                  error:(NSError**)error {

    id<IRAssetId> assetId = [IRAssetIdFactory assetWithIdentifier:pbCommand.assetId
                                                            error:error];

    if (!assetId) {
        return nil;
    }

    id<IRAmount> amount = [IRAmountFactory amountFromString:pbCommand.amount
                                                      error:error];

    if (!amount) {
        return nil;
    }

    return [[IRAddAssetQuantity alloc] initWithAssetId:assetId
                                                amount:amount];
}

+ (nullable id<IRRevokePermission>)revokePermissionCommandFromPbCommand:(nonnull RevokePermission*)pbCommand error:(NSError**)error {
    id<IRAccountId> accountId = [IRAccountIdFactory accountWithIdentifier:pbCommand.accountId
                                                                    error:error];

    if (!accountId) {
        return nil;
    }

    id<IRGrantablePermission> permission = [IRGrantablePermissionFactory permissionWithValue:pbCommand.permission
                                                                                       error:error];

    if (!permission) {
        return nil;
    }

    return [[IRRevokePermission alloc] initWithAccountId:accountId
                                              permission:permission];
}

+ (nullable id<IRSetAccountDetail>)setAccountDetailCommandFromPbCommand:(nonnull SetAccountDetail*)pbCommand
                                                                  error:(NSError**)error {

    id<IRAccountId> accountId = [IRAccountIdFactory accountWithIdentifier:pbCommand.accountId
                                                                    error:error];

    if (!accountId) {
        return nil;
    }

    return [[IRSetAccountDetail alloc] initWithAccountId:accountId
                                                     key:pbCommand.key
                                                   value:pbCommand.value];
}

+ (nullable id<IRSetAccountQuorum>)setAccountQuorumCommandPbCommand:(nonnull SetAccountQuorum*)pbCommand
                                                              error:(NSError**)error {

    id<IRAccountId> accountId = [IRAccountIdFactory accountWithIdentifier:pbCommand.accountId
                                                                    error:error];

    if (!accountId) {
        return nil;
    }

    return [[IRSetAccountQuorum alloc] initWithAccountId:accountId
                                                  quorum:pbCommand.quorum];
}

+ (nullable id<IRSubtractAssetQuantity>)subtractAssetQuantityCommandFromPbCommand:(nonnull SubtractAssetQuantity*)pbCommand error:(NSError**)error {

    id<IRAssetId> assetId = [IRAssetIdFactory assetWithIdentifier:pbCommand.assetId
                                                            error:error];

    if (!assetId) {
        return nil;
    }

    id<IRAmount> amount = [IRAmountFactory amountFromString:pbCommand.amount
                                                      error:error];

    if (!amount) {
        return nil;
    }

    return [[IRSubtractAssetQuantity alloc] initWithAssetId:assetId
                                                     amount:amount];
}

+ (nullable id<IRPublicKeyProtocol>)createPublicKeyFromRawData:(nonnull NSData*)rawData error:(NSError**)error {
    id<IRPublicKeyProtocol> publicKey = [[IREd25519PublicKey alloc] initWithRawData:rawData];

    if (!publicKey) {
        if (error) {
            NSString *message = [NSString stringWithFormat:@"Invalid public key %@", [rawData toHexString]];
            *error = [NSError errorWithDomain:NSStringFromClass([IRCommandProtoFactory class])
                                         code:IRCommandProtoFactoryErrorInvalidArgument
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }
        return nil;
    }

    return publicKey;
}

@end

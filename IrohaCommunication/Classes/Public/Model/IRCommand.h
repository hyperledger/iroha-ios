#ifndef IRCommand_h
#define IRCommand_h

#import "IRAssetId.h"
#import "IRAccountId.h"
#import "IRAddress.h"
#import "IRAmount.h"
#import "IRDomain.h"
#import "IRGrantablePermission.h"
#import "IRRoleName.h"
#import "IRRolePermission.h"
#import <IrohaCrypto/IRPublicKey.h>

@protocol IRCommand <NSObject>

@end

@protocol IRAddAssetQuantity <IRCommand>

@property(nonatomic, readonly)id<IRAssetId> _Nonnull assetId;
@property(nonatomic, readonly)id<IRAmount> _Nonnull amount;

@end

@protocol IRAddPeer <IRCommand>

@property(nonatomic, readonly)id<IRAddress> _Nonnull address;
@property(nonatomic, readonly)id<IRPublicKeyProtocol> _Nonnull publicKey;

@end

@protocol IRAddSignatory <IRCommand>

@property(nonatomic, readonly)id<IRAccountId> _Nonnull accountId;
@property(nonatomic, readonly)id<IRPublicKeyProtocol> _Nonnull publicKey;

@end

@protocol IRAppendRole <IRCommand>

@property(nonatomic, readonly)id<IRAccountId> _Nonnull accountId;
@property(nonatomic, readonly)id<IRRoleName> _Nonnull roleName;

@end

@protocol IRCreateAccount <IRCommand>

@property(nonatomic, readonly)id<IRAccountId> _Nonnull accountId;
@property(nonatomic, readonly)id<IRPublicKeyProtocol> _Nonnull publicKey;

@end

@protocol IRCreateAsset <IRCommand>

@property(nonatomic, readonly)id<IRAssetId> _Nonnull assetId;
@property(nonatomic, readonly)UInt32 precision;

@end

@protocol IRCreateDomain <IRCommand>

@property(nonatomic, readonly)id<IRDomain> _Nonnull domainId;
@property(nonatomic, readonly)id<IRRoleName> _Nullable defaultRole;

@end

@protocol IRCreateRole <IRCommand>

@property(nonatomic, readonly)id<IRRoleName> _Nonnull roleName;
@property(nonatomic, readonly)NSArray<id<IRRolePermission>> * _Nonnull permissions;

@end

@protocol IRDetachRole <IRCommand>

@property(nonatomic, readonly)id<IRAccountId> _Nonnull accountId;
@property(nonatomic, readonly)id<IRRoleName> _Nonnull roleName;

@end

@protocol IRGrantPermission <IRCommand>

@property(nonatomic, readonly)id<IRAccountId> _Nonnull accountId;
@property(nonatomic, readonly)id<IRGrantablePermission> _Nonnull permission;

@end

@protocol IRRemoveSignatory <IRCommand>

@property(nonatomic, readonly)id<IRAccountId> _Nonnull accountId;
@property(nonatomic, readonly)id<IRPublicKeyProtocol> _Nonnull publicKey;

@end

@protocol IRRevokePermission <IRCommand>

@property(nonatomic, readonly)id<IRAccountId> _Nonnull accountId;
@property(nonatomic, readonly)id<IRGrantablePermission> _Nonnull permission;

@end

@protocol IRSetAccountDetail <IRCommand>

@property(nonatomic, readonly)id<IRAccountId> _Nonnull accountId;
@property(nonatomic, readonly)NSString* _Nonnull key;
@property(nonatomic, readonly)NSString* _Nonnull value;

@end

@protocol IRSetAccountQuorum <IRCommand>

@property(nonatomic, readonly)id<IRAccountId> _Nonnull accountId;
@property(nonatomic, readonly)UInt32 quorum;

@end

@protocol IRSubtractAssetQuantity <IRCommand>

@property(nonatomic, readonly)id<IRAssetId> _Nonnull assetId;
@property(nonatomic, readonly)id<IRAmount> _Nonnull amount;

@end

@protocol IRTransferAsset <IRCommand>

@property(nonatomic, readonly)id<IRAccountId> _Nonnull sourceAccountId;
@property(nonatomic, readonly)id<IRAccountId> _Nonnull destinationAccountId;
@property(nonatomic, readonly)id<IRAssetId> _Nonnull assetId;
@property(nonatomic, readonly)NSString* _Nonnull transferDescription;
@property(nonatomic, readonly)id<IRAmount> _Nonnull amount;

@end

#endif

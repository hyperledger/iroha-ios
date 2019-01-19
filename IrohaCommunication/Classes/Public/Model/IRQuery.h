#ifndef IRQuery_h
#define IRQuery_h

#import "IRAccountId.h"
#import "IRAssetId.h"
#import "IRPagination.h"
#import "IRRoleName.h"

@protocol IRQuery <NSObject>

@end

@protocol IRGetAccount <IRQuery>

@property(nonatomic, readonly)id<IRAccountId> _Nonnull accountId;

@end

@protocol IRGetSignatories <IRQuery>

@property(nonatomic, readonly)id<IRAccountId> _Nonnull accountId;

@end

@protocol IRGetAccountTransactions <IRQuery>

@property(nonatomic, readonly)id<IRAccountId> _Nonnull accountId;
@property(nonatomic, readonly)id<IRPagination> _Nullable pagination;

@end

@protocol IRGetAccountAssetTransactions <IRQuery>

@property(nonatomic, readonly)id<IRAccountId> _Nonnull accountId;
@property(nonatomic, readonly)id<IRAssetId> _Nonnull assetId;
@property(nonatomic, readonly)id<IRPagination> _Nullable pagination;

@end

@protocol IRGetTransactions <IRQuery>

@property(nonatomic, readonly)NSArray<NSData*> * _Nonnull transactionHashes;

@end

@protocol IRGetAccountAssets <IRQuery>

@property(nonatomic, readonly)id<IRAccountId> _Nonnull accountId;

@end

@protocol IRGetAccountDetail <IRQuery>

@property(nonatomic, readonly)id<IRAccountId> _Nullable accountId;
@property(nonatomic, readonly)id<IRAccountId> _Nullable writer;
@property(nonatomic, readonly)NSString * _Nullable key;

@end

@protocol IRGetRoles <IRQuery>

@end

@protocol IRGetRolePermissions <IRQuery>

@property(nonatomic, readonly)id<IRRoleName> _Nonnull roleName;

@end

@protocol IRGetAssetInfo <IRQuery>

@property(nonatomic, readonly)id<IRAssetId> _Nonnull assetId;

@end

@protocol IRGetPendingTransactions <IRQuery>

@end

#endif

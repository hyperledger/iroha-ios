/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#ifndef IRQueryResponse_h
#define IRQueryResponse_h

#import "IRAccountId.h"
#import "IRAccountAsset.h"
#import "IRRoleName.h"
#import "IRRolePermission.h"
#import "IRTransaction.h"
#import "IrohaCrypto/IRPublicKey.h"
#import "IRAccountDetailRecordId.h"
#import "IRPeer.h"


@protocol IRQueryResponse <NSObject>

@property (nonatomic, readonly) NSData* _Nonnull queryHash;

@end


@protocol IRAccountAssetsResponse <IRQueryResponse>

@property(nonatomic, readonly)NSArray<id<IRAccountAsset>>* _Nonnull accountAssets;
@property(nonatomic, readonly)UInt32 totalCount;
@property(nonatomic, readonly)id<IRAssetId> _Nullable nextAssetId;

@end


@protocol IRAccountDetailResponse <IRQueryResponse>

@property(nonatomic, readonly)NSString* _Nonnull detail;
@property(nonatomic, readonly)UInt64 totalCount;
@property(nonatomic, readonly)id<IRAccountDetailRecordId> _Nullable nextRecordId;

@end


@protocol IRSignatoriesResponse <IRQueryResponse>

@property(nonatomic, readonly)NSArray<id<IRPublicKeyProtocol>>* _Nonnull publicKeys;

@end


@protocol IRTransactionsResponse <IRQueryResponse>

@property(nonatomic, readonly)NSArray<id<IRTransaction>>* _Nonnull transactions;

@end


@protocol IRRolesResponse <IRQueryResponse>

@property(nonatomic, readonly)NSArray<id<IRRoleName>>* _Nonnull roles;

@end


@protocol IRRolePermissionsResponse <IRQueryResponse>

@property(nonatomic, readonly)NSArray<id<IRRolePermission>>* _Nonnull permissions;

@end


@protocol IRAccountResponse <IRQueryResponse>

@property(nonatomic, readonly)id<IRAccountId> _Nonnull accountId;
@property(nonatomic, readonly)UInt32 quorum;
@property(nonatomic, readonly)NSString * _Nullable details;
@property(nonatomic, readonly)NSArray<id<IRRoleName>> * _Nonnull roles;

@end


typedef NS_ENUM(NSUInteger, IRErrorResponseReason) {
    IRErrorResponseReasonStatelessInvalid,
    IRErrorResponseReasonStatefulInvalid,
    IRErrorResponseReasonNoAccount,
    IRErrorResponseReasonNoAccountAssets,
    IRErrorResponseReasonNoAccountDetail,
    IRErrorResponseReasonNoSignatories,
    IRErrorResponseReasonNotSupported,
    IRErrorResponseReasonNoAsset,
    IRErrorResponseReasonNoRoles
};


@protocol IRErrorResponse <IRQueryResponse>

@property(nonatomic, readonly)IRErrorResponseReason reason;
@property(nonatomic, readonly)NSString * _Nonnull message;
@property(nonatomic, readonly)UInt32 code;

@end


@protocol IRAssetResponse <IRQueryResponse>

@property(nonatomic, readonly)id<IRAssetId> _Nonnull assetId;
@property(nonatomic, readonly)UInt32 precision;

@end


@protocol IRTransactionsPageResponse <IRQueryResponse>

@property(nonatomic, readonly)NSArray<id<IRTransaction>>* _Nonnull transactions;
@property(nonatomic, readonly)UInt32 totalCount;
@property(nonatomic, readonly)NSData * _Nullable nextTransactionHash;

@end


@protocol IRPeersResponse <IRQueryResponse>

@property(nonatomic, readonly)NSArray<id<IRPeer>>* _Nonnull peers;

@end

#endif

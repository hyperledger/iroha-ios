/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <Foundation/Foundation.h>
#import "IRDomain.h"

@protocol IRAssetId <NSObject>

@property (nonatomic, readonly) NSString * _Nonnull name;
@property (nonatomic, readonly) id<IRDomain> _Nonnull domain;

- (nonnull NSString *)identifier;

@end

typedef NS_ENUM(NSUInteger, IRAssetIdFactoryError) {
    IRInvalidAssetName,
    IRInvalidAssetIdentifier
};

@protocol IRAssetIdFactoryProtocol <NSObject>

+ (nullable id<IRAssetId>)assetIdWithName:(nonnull NSString *)name
                                   domain:(nonnull id<IRDomain>)domain
                                    error:(NSError *_Nullable*_Nullable)error;

+ (nullable id<IRAssetId>)assetWithIdentifier:(nonnull NSString *)assetId
                                        error:(NSError *_Nullable*_Nullable)error;

@end

@interface IRAssetIdFactory : NSObject<IRAssetIdFactoryProtocol>

@end

/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <Foundation/Foundation.h>
#import "IRDomain.h"

@protocol IRAccountId <NSObject>

@property (nonatomic, readonly) NSString * _Nonnull name;
@property (nonatomic, readonly) id<IRDomain> _Nonnull domain;

- (nonnull NSString *)identifier;

@end

typedef NS_ENUM(NSUInteger, IRAccountIdFactoryError) {
    IRInvalidAccountName,
    IRInvalidAccountIdentifier
};

@protocol IRAccountIdFactoryProtocol <NSObject>

+ (nullable id<IRAccountId>)accountIdWithName:(nonnull NSString *)name
                                       domain:(nonnull id<IRDomain>)domain
                                        error:(NSError *_Nullable*_Nullable)error;

+ (nullable id<IRAccountId>)accountWithIdentifier:(nonnull NSString *)accountId
                                          error:(NSError *_Nullable*_Nullable)error;

@end

@interface IRAccountIdFactory : NSObject<IRAccountIdFactoryProtocol>

@end

/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <Foundation/Foundation.h>

@protocol IRRoleName <NSObject>

@property (nonatomic, readonly) NSString * _Nonnull value;

@end

typedef NS_ENUM(NSUInteger, IRRoleNameFactoryError) {
    IRInvalidRoleName
};

@protocol IRRoleNameFactoryProtocol <NSObject>

+ (nullable id<IRRoleName>)roleWithName:(nonnull NSString *)name error:(NSError *_Nullable*_Nullable)error;

@end

@interface IRRoleNameFactory : NSObject<IRRoleNameFactoryProtocol>

@end

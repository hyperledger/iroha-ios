/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <Foundation/Foundation.h>

@protocol IRDomain <NSObject>

@property(nonatomic, readonly)NSString * _Nonnull identifier;

@end

typedef NS_ENUM(NSUInteger, IRDomainFactoryError) {
    IRInvalidDomainIdentifier
};

@protocol IRDomainFactoryProtocol <NSObject>

+ (nullable id<IRDomain>)domainWithIdentitifer:(nonnull NSString*)identifier
                                         error:(NSError*_Nullable*_Nullable)error;

@end

@interface IRDomainFactory : NSObject<IRDomainFactoryProtocol>

@end

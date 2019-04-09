/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <Foundation/Foundation.h>

@protocol IRAddress <NSObject>

@property(nonatomic, readonly)NSString * _Nonnull value;

@end

typedef NS_ENUM(NSUInteger, IRAddressError) {
    IRInvalidAddressIp,
    IRInvalidAddressPort,
    IRInvalidAddressDomain,
    IRInvalidAddressValue
};

@protocol IRAddressFactoryProtocol <NSObject>

+ (nullable id<IRAddress>)addressWithIp:(nonnull NSString*)ipV4 port:(nonnull NSString*)port error:(NSError*_Nullable*_Nullable)error;
+ (nullable id<IRAddress>)addressWithDomain:(nonnull NSString*)domain port:(nonnull NSString*)port error:(NSError*_Nullable*_Nullable)error;
+ (nullable id<IRAddress>)addressWithValue:(nonnull NSString*)value error:(NSError*_Nullable*_Nullable)error;

@end

@interface IRAddressFactory : NSObject<IRAddressFactoryProtocol>

@end

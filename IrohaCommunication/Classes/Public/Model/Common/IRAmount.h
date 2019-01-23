/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <Foundation/Foundation.h>

@protocol IRAmount <NSObject>

@property(nonatomic, readonly)NSString* _Nonnull value;

@end

typedef NS_ENUM(NSUInteger, IRAmountError) {
    IRInvalidAmountValue
};

@protocol IRAmountFactoryProtocol <NSObject>

+ (nullable id<IRAmount>)amountFromString:(nonnull NSString*)amount error:(NSError**)error;
+ (nullable id<IRAmount>)amountFromUnsignedInteger:(NSUInteger)amount error:(NSError**)error;

@end

@interface IRAmountFactory : NSObject<IRAmountFactoryProtocol>

@end

/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <Foundation/Foundation.h>
#import "IRTransaction.h"
#import "IRQueryRequest.h"
#import "IRQueryResponse.h"

@protocol IRSerializationFactoryProtocol <NSObject>

+ (nullable NSData*)serializeTransaction:(nonnull id<IRTransaction>)transaction error:(NSError**)error;
+ (nullable NSData*)serializeQueryRequest:(nonnull id<IRQueryRequest>)queryRequest error:(NSError**)error;

+ (nullable id<IRTransaction>)deserializeTransactionFromData:(nonnull NSData*)data error:(NSError**)error;
+ (nullable id<IRQueryResponse>)deserializeQueryResponseFromData:(nonnull NSData*)data error:(NSError**)error;

@end

@interface IRSerializationFactory : NSObject<IRSerializationFactoryProtocol>

@end

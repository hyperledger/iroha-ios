/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, IRPaginationFactoryError) {
    IRPaginationFactoryErrorInvalidHash
};


@protocol IRPagination <NSObject>

@property (nonatomic, readonly) UInt32 pageSize;
@property (nonatomic, readonly) NSData * _Nullable firstItemHash;

@end


@protocol IRPaginationFactoryProtocol <NSObject>

+ (nullable id<IRPagination>)pagination:(UInt32)pageSize
                          firstItemHash:(nullable NSData *)firstItemHash
                                  error:(NSError *_Nullable*_Nullable)error;

@end


@interface IRPaginationFactory : NSObject<IRPaginationFactoryProtocol>
@end

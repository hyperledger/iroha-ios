/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <Foundation/Foundation.h>


@protocol IRAccountDetailRecordId <NSObject>

@property(nonatomic, readonly)NSString * _Nonnull writer;
@property(nonatomic, readonly)NSString * _Nonnull key;

@end


@protocol IRAccountDetailRecordIdFactoryProtocol <NSObject>

+ (nullable id<IRAccountDetailRecordId>)accountDetailRecordIdWithWriter:(nonnull NSString *)writer
                                                                    key:(nonnull NSString *)key;

@end


@interface IRAccountDetailRecordIdFactory : NSObject<IRAccountDetailRecordIdFactoryProtocol>
@end

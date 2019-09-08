/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <Foundation/Foundation.h>
@import IrohaCommunication;


@interface IRIrohaContainer : NSObject

@property(nonatomic, readonly)IRNetworkService * _Nonnull iroha;

+ (nonnull instancetype)shared;
- (nullable NSError*)start;
- (nullable NSError*)stop;

@end

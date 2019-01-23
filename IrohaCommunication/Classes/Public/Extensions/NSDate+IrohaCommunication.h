/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <Foundation/Foundation.h>

@interface NSDate (IrohaCommunication)

- (UInt64)milliseconds;

+ (nonnull instancetype)dateWithTimestampInMilliseconds:(UInt64)milliseconds;

@end

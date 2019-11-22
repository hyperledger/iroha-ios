/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <Foundation/Foundation.h>
#import "IRAmount.h"

@interface NSDecimalNumber (IRAmount)

+ (nullable NSDecimalNumber*)decimalNumberWithAmountValue:(nonnull NSString*)value;
+ (nullable NSDecimalNumber*)decimalNumberWithAmount:(nonnull id<IRAmount>)amount;

@end

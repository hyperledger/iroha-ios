/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: Apache-2.0
*/

#import "NSDecimalNumber+IRAmount.h"

static NSString * const DECIMAL_SEPARATOR = @".";

@implementation NSDecimalNumber (IRAmount)

+ (nullable NSDecimalNumber *)decimalNumberWithAmountValue:(nonnull NSString *)value {
    return [NSDecimalNumber decimalNumberWithString:value
                                             locale:@{NSLocaleDecimalSeparator: DECIMAL_SEPARATOR}];
}

+ (nullable NSDecimalNumber *)decimalNumberWithAmount:(id<IRAmount>)amount {
    return [NSDecimalNumber decimalNumberWithAmountValue:amount.value];
}

@end

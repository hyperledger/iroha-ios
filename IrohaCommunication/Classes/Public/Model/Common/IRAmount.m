/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import "IRAmount.h"
#import "NSDecimalNumber+IRAmount.h"

@interface IRAmount : NSObject<IRTransferAmount>

- (instancetype)initWithString:(nonnull NSString *)amountString;

@end


@implementation IRAmount

@synthesize value = _value;

- (instancetype)initWithString:(nonnull NSString *)amountString {
    if (self = [super init]) {
        _value = amountString;
    }

    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", _value];
}

@end


@implementation IRAmountFactory

+ (nullable IRAmount *)concreteAmountFromString:(nonnull NSString *)amount
                                          error:(NSError *_Nullable*_Nullable)error {
    NSCharacterSet *invalidSymbols = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];

    if ([amount rangeOfCharacterFromSet:invalidSymbols].location != NSNotFound) {
        if (error) {
            NSString *message = @"Amount must be a valid positive decimal number with point separator";
            *error = [NSError errorWithDomain:NSStringFromClass([IRAmountFactory class])
                                         code:IRInvalidAmountValue
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }
        return nil;
    }

    NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithAmountValue:amount];

    if (!decimalNumber || [decimalNumber isEqualToNumber:[NSDecimalNumber notANumber]]) {
        if (error) {
            NSString *message = @"Invalid amount value";
            *error = [NSError errorWithDomain:NSStringFromClass([IRAmountFactory class])
                                         code:IRInvalidAmountValue
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }
        return nil;
    }

    return [[IRAmount alloc] initWithString:[decimalNumber stringValue]];
}

+ (nullable id<IRAmount>)amountFromString:(nonnull NSString *)amount error:(NSError *_Nullable*_Nullable)error {
    return [self concreteAmountFromString:amount error:error];
}

+ (nullable id<IRAmount>)amountFromUnsignedInteger:(NSUInteger)amount error:(NSError *_Nullable*_Nullable)error {
    return [self amountFromString:[@(amount) stringValue] error:error];
}

+ (nullable id<IRTransferAmount>)transferAmountFromString:(nonnull NSString *)amount
                                                    error:(NSError *_Nullable*_Nullable)error {
    IRAmount *irAmount = [self concreteAmountFromString:amount error:error];

    NSComparisonResult result = [[NSDecimalNumber decimalNumberWithAmount:irAmount] compare:NSDecimalNumber.zero];
    if (result == NSOrderedDescending) {
        return irAmount;
    } else {
        if (error) {
            NSString *message = @"Amount value must be positive";
            *error = [NSError errorWithDomain:NSStringFromClass([IRAmountFactory class])
                                         code:IRInvalidAmountValue
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }
        return nil;
    }
}

+ (nullable id<IRTransferAmount>)transferAmountFromUnsignedInteger:(NSUInteger)amount
                                                             error:(NSError *_Nullable*_Nullable)error {
    return [self transferAmountFromString:[@(amount) stringValue] error:error];
}

@end

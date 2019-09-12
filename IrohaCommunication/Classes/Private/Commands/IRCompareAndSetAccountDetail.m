/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import "IRCompareAndSetAccountDetail.h"
#import "Commands.pbobjc.h"

@implementation IRCompareAndSetAccountDetail

@synthesize accountId = _accountId;
@synthesize key = _key;
@synthesize value = _value;
@synthesize oldValue = _oldValue;

- (instancetype)initWithAccountId:(id<IRAccountId>)accountId
                              key:(NSString *)key
                            value:(NSString *)value
                         oldValue:(NSString *)oldValue {
    if (self = [super init]) {
        _accountId = accountId;
        _key = key;
        _value = value;
        _oldValue = oldValue;
    }
    
    return self;
}


#pragma mark - Protobuf Transformable

- (nullable id)transform:(NSError *__autoreleasing *)error {
    CompareAndSetAccountDetail *compare = [CompareAndSetAccountDetail new];
    compare.accountId = _accountId.identifier;
    compare.key = _key;
    compare.value = _value;
    compare.oldValue = _oldValue;
    
    Command *command = [[Command alloc] init];
    command.compareAndSetAccountDetail = compare;
    
    return command;
}

@end

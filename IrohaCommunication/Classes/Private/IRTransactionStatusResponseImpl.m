/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import "IRTransactionStatusResponseImpl.h"

@implementation IRTransactionStatusResponse
@synthesize status = _status;
@synthesize transactionHash = _transactionHash;
@synthesize statusDescription = _statusDescription;

- (nonnull instancetype)initWithStatus:(IRTransactionStatus)status
                       transactionHash:(nonnull NSData *)transactionHash
                           description:(nullable NSString *)statusDescription {

    if (self = [super init]) {
        _status = status;
        _transactionHash = transactionHash;
        _statusDescription = statusDescription;
    }

    return self;
}

@end

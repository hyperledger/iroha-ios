/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import "IRAccountDetailResponse.h"

@implementation IRAccountDetailResponse

@synthesize detail = _detail;
@synthesize queryHash = _queryHash;
@synthesize totalCount = _totalCount;
@synthesize nextRecordId = _nextRecordId;

- (nonnull instancetype)initWithDetail:(nonnull NSString *)detail
                            totalCount:(UInt64)totalCount
                          nextRecordId:(nullable id<IRAccountDetailRecordId>)nextRecordId
                             queryHash:(nonnull NSData *)queryHash {
    if (self = [super init]) {
        _detail = detail;
        _totalCount = totalCount;
        _nextRecordId = nextRecordId;
        _queryHash = queryHash;
    }

    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Detail: %@\nTotal count:%@\nNext record id:%@", _detail, @(_totalCount), _nextRecordId];
}

@end

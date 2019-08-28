/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import "IRAccountDetailPagination.h"


@interface IRAccountDetailPagination: NSObject <IRAccountDetailPagination>
@end


@implementation IRAccountDetailPagination

@synthesize pageSize = _pageSize;
@synthesize nextRecordId = _nextRecordId;

- (instancetype)initWithPageSize:(UInt32)pageSize
                  nextRecordId:(nonnull id<IRAccountDetailRecordId>)nextRecordId {
    if (self = [super init]) {
        _pageSize = pageSize;
        _nextRecordId = nextRecordId;
    }
    
    return self;
}

@end


@implementation IRAccountDetailPaginationFactory

+ (nonnull id<IRAccountDetailPagination>)accountDetailPagination:(UInt32)pageSize
                                                    nextRecordId:(nonnull id<IRAccountDetailRecordId>)nextRecordId {
    if (!nextRecordId) {
        return nil;
    }
    
    return [[IRAccountDetailPagination alloc] initWithPageSize:pageSize nextRecordId:nextRecordId];
}

@end

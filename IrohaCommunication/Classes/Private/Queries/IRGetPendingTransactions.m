/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import "IRGetPendingTransactions.h"
#import "Queries.pbobjc.h"
@import IrohaCrypto;

@implementation IRGetPendingTransactions

@synthesize pagination = _pagination;

- (instancetype)initWithPagination:(id<IRPagination>)pagination {
    if (self = [super init]) {
        _pagination = pagination;
    }
    
    return self;
}

#pragma mark - Protobuf Transformable

- (nullable id)transform:(NSError **)error {
    GetPendingTransactions *query = [[GetPendingTransactions alloc] init];
    
    if (_pagination) {
        TxPaginationMeta *meta = [TxPaginationMeta new];
        meta.pageSize = _pagination.pageSize;
        meta.firstTxHash = [_pagination.firstItemHash toHexString];
        
        query.paginationMeta = meta;
    }

    Query_Payload *payload = [[Query_Payload alloc] init];
    payload.getPendingTransactions = query;

    return payload;
}

@end

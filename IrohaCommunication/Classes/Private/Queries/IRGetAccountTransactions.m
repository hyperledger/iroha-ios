#import "IRGetAccountTransactions.h"
#import "Queries.pbobjc.h"
#import <IrohaCrypto/NSData+Hex.h>

@implementation IRGetAccountTransactions
@synthesize accountId = _accountId;
@synthesize pagination = _pagination;

- (nonnull instancetype)initWithAccountId:(nonnull id<IRAccountId>)accountId
                               pagination:(nullable id<IRPagination>)pagination {
    if (self = [super init]) {
        _accountId = accountId;
        _pagination = pagination;
    }

    return self;
}

#pragma mark - Protobuf Transformable

- (nullable id)transform:(NSError**)error {
    GetAccountTransactions *query = [[GetAccountTransactions alloc] init];
    query.accountId = [_accountId identifier];

    if (_pagination) {
        TxPaginationMeta *pagination = [[TxPaginationMeta alloc] init];
        pagination.pageSize = (uint32_t)_pagination.pageSize;
        pagination.firstTxHash = [_pagination.firstItemHash toHexString];

        query.paginationMeta = pagination;
    }

    Query_Payload *payload = [[Query_Payload alloc] init];
    payload.getAccountTransactions = query;

    return payload;
}

@end

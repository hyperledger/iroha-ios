#import "IRGetAccountAssetTransactions.h"
#import "Queries.pbobjc.h"
#import <IrohaCrypto/NSData+Hex.h>

@implementation IRGetAccountAssetTransactions
@synthesize accountId = _accountId;
@synthesize assetId = _assetId;
@synthesize pagination = _pagination;

- (nonnull instancetype)initWithAccountId:(nonnull id<IRAccountId>)accountId
                                  assetId:(nonnull id<IRAssetId>)assetId
                               pagination:(nullable id<IRPagination>)pagination {
    if (self = [super init]) {
        _accountId = accountId;
        _assetId = assetId;
        _pagination = pagination;
    }

    return self;
}

#pragma mark - Protobuf Transformable

- (nullable id)transform:(NSError**)error {
    GetAccountAssetTransactions *query = [[GetAccountAssetTransactions alloc] init];
    query.accountId = [_accountId identifier];
    query.assetId = [_assetId identifier];

    if (_pagination) {
        TxPaginationMeta *pagination = [[TxPaginationMeta alloc] init];
        pagination.pageSize = (uint32_t)_pagination.pageSize;
        pagination.firstTxHash = [_pagination.firstItemHash toHexString];

        query.paginationMeta = pagination;
    }

    Query_Payload *payload = [[Query_Payload alloc] init];
    payload.getAccountAssetTransactions = query;

    return payload;
}

@end

#import "IRQueryBuilder.h"
#import "IRQueryRequestImpl.h"
#import "IRQueryAll.h"

static const UInt64 DEFAULT_QUERY_COUNTER = 1;

@interface IRQueryBuilder()

@property(strong, nonatomic)id<IRAccountId> _Nullable creator;
@property(strong, nonatomic)NSDate* _Nullable createdAt;
@property(strong, nonatomic)id<IRQuery> _Nullable query;
@property(nonatomic, readwrite)UInt64 queryCounter;

@end

@implementation IRQueryBuilder

#pragma mark - Initialization

- (nonnull instancetype)init {
    if (self = [super init]) {
        _queryCounter = DEFAULT_QUERY_COUNTER;
    }

    return self;
}

+ (nonnull instancetype)builderWithCreatorAccountId:(id<IRAccountId>)creator {
    return [[[IRQueryBuilder alloc] init] withCreatorAccountId:creator];
}

#pragma mark - Query

- (nonnull instancetype)getAccount:(nonnull id<IRAccountId>)accountId {
    id<IRGetAccount> query = [[IRGetAccount alloc] initWithAccountId:accountId];

    return [self withQuery:query];
}

- (nonnull instancetype)getSignatories:(nonnull id<IRAccountId>)accountId {
    id<IRGetSignatories> query = [[IRGetSignatories alloc] initWithAccountId:accountId];

    return [self withQuery:query];
}

- (nonnull instancetype)getAccountTransactions:(nonnull id<IRAccountId>)accountId
                                    pagination:(nullable id<IRPagination>)pagination {
    id<IRGetAccountTransactions> query = [[IRGetAccountTransactions alloc] initWithAccountId:accountId
                                                                                  pagination:pagination];

    return [self withQuery:query];
}

- (nonnull instancetype)getAccountAssetTransactions:(nonnull id<IRAccountId>)accountId
                                            assetId:(nonnull id<IRAssetId>)assetId
                                         pagination:(nullable id<IRPagination>)pagination {
    id<IRGetAccountAssetTransactions> query = [[IRGetAccountAssetTransactions alloc] initWithAccountId:accountId
                                                                                               assetId:assetId
                                                                                            pagination:pagination];

    return [self withQuery:query];
}

- (nonnull instancetype)getTransactions:(nonnull NSArray<NSData*>*)hashes {
    id<IRGetTransactions> query = [[IRGetTransactions alloc] initWithTransactionHashes:hashes];

    return [self withQuery:query];
}

- (nonnull instancetype)getAccountAssets:(nonnull id<IRAccountId>)accountId {
    id<IRGetAccountAssets> query = [[IRGetAccountAssets alloc] initWithAccountId:accountId];

    return [self withQuery:query];
}

- (nonnull instancetype)getAccountDetail:(nullable id<IRAccountId>)accountId
                                  writer:(nullable id<IRAccountId>)writer
                                     key:(nullable NSString*)key {
    id<IRGetAccountDetail> query = [[IRGetAccountDetail alloc] initWithAccountId:accountId
                                                                          writer:writer
                                                                             key:key];

    return [self withQuery:query];
}

- (nonnull instancetype)getRoles {
    id<IRGetRoles> query = [[IRGetRoles alloc] init];

    return [self withQuery:query];
}

- (nonnull instancetype)getRolePermissions:(nonnull id<IRRoleName>)roleName {
    id<IRGetRolePermissions> query = [[IRGetRolePermissions alloc] initWithRoleName:roleName];

    return [self withQuery:query];
}

- (nonnull instancetype)getAssetInfo:(nonnull id<IRAssetId>)assetId {
    id<IRGetAssetInfo> query = [[IRGetAssetInfo alloc] initWithAssetId:assetId];

    return [self withQuery:query];
}

- (nonnull instancetype)getPendingTransactions {
    id<IRGetPendingTransactions> query = [[IRGetPendingTransactions alloc] init];

    return [self withQuery:query];
}

#pragma mark - IRQueryBuilderProtocol

- (nonnull instancetype)withCreatorAccountId:(nonnull id<IRAccountId>)creatorAccountId {
    _creator = creatorAccountId;

    return self;
}

- (nonnull instancetype)withCreatedDate:(nonnull NSDate*)date {
    _createdAt = date;

    return self;
}

- (nonnull instancetype)withQueryCounter:(UInt64)queryCounter {
    _queryCounter = queryCounter > 0 ? queryCounter : DEFAULT_QUERY_COUNTER;

    return self;
}

- (nonnull instancetype)withQuery:(nonnull id<IRQuery>)query {
    _query = query;

    return self;
}

- (nullable id<IRQueryRequest>)build:(NSError*_Nullable*_Nullable)error {
    if (!_creator) {
        if (error) {
            NSString *message = @"Creator's account id is required!";
            *error = [NSError errorWithDomain:NSStringFromClass([IRQueryBuilder class])
                                         code:IRQueryBuilderErrorMissingCreator
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }

        return nil;
    }

    if (!_query) {
        if (error) {
            NSString *message = @"Query is not set!";
            *error = [NSError errorWithDomain:NSStringFromClass([IRQueryBuilder class])
                                         code:IRQueryBuilderErrorMissingQuery
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }

        return nil;
    }

    NSDate *createdAt = _createdAt ? _createdAt: [NSDate date];

    return [[IRQueryRequest alloc] initWithCreator:_creator
                                         createdAt:createdAt
                                             query:_query
                                      queryCounter:_queryCounter
                                     peerSignature:nil];
}

@end

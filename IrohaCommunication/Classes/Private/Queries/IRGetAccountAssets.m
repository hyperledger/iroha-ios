#import "IRGetAccountAssets.h"
#import "Queries.pbobjc.h"

@implementation IRGetAccountAssets
@synthesize accountId = _accountId;

- (nonnull instancetype)initWithAccountId:(nonnull id<IRAccountId>)accountId {
    if (self = [super init]) {
        _accountId = accountId;
    }

    return self;
}

#pragma mark - Protobuf Transformable

- (nullable id)transform:(NSError**)error {
    GetAccountAssets *query = [[GetAccountAssets alloc] init];
    query.accountId = [_accountId identifier];

    Query_Payload *payload = [[Query_Payload alloc] init];
    payload.getAccountAssets = query;

    return payload;
}

@end

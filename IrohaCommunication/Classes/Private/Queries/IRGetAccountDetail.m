#import "IRGetAccountDetail.h"
#import "Queries.pbobjc.h"

@implementation IRGetAccountDetail
@synthesize accountId = _accountId;
@synthesize writer = _writer;
@synthesize key = _key;

- (nonnull instancetype)initWithAccountId:(nullable id<IRAccountId>)accountId
                                   writer:(nullable id<IRAccountId>)writer
                                      key:(nullable NSString*)key {
    if (self = [super init]) {
        _accountId = accountId;
        _writer = writer;
        _key = key;
    }

    return self;
}

#pragma mark - Protobuf Transformable

- (nullable id)transform:(NSError**)error {
    GetAccountDetail *query = [[GetAccountDetail alloc] init];
    query.accountId = [_accountId identifier];
    query.writer = [_writer identifier];
    query.key = _key;

    Query_Payload *payload = [[Query_Payload alloc] init];
    payload.getAccountDetail = query;

    return payload;
}

@end

#import "IRAccountResponse.h"

@implementation IRAccountResponse
@synthesize accountId = _accountId;
@synthesize quorum = _quorum;
@synthesize details = _details;
@synthesize roles = _roles;
@synthesize queryHash = _queryHash;

- (nonnull instancetype)initWithAccountId:(nonnull id<IRAccountId>)accountId
                                   quorum:(UInt32)quorum
                                  details:(nullable NSString*)details
                                    roles:(nonnull NSArray<id<IRRoleName>>*)roles
                                queryHash:(nonnull NSData*)queryHash {

    if (self = [super init]) {
        _accountId = accountId;
        _quorum = quorum;
        _details = details;
        _roles = roles;
        _queryHash = queryHash;
    }

    return self;
}

@end

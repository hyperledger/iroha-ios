#import "IRSetAccountQuorum.h"
#import "Commands.pbobjc.h"

@implementation IRSetAccountQuorum
@synthesize accountId = _accountId;
@synthesize quorum = _quorum;

- (nonnull instancetype)initWithAccountId:(nonnull id<IRAccountId>)accountId
                                   quorum:(UInt32)quorum {

    if (self = [super init]) {
        _accountId = accountId;
        _quorum = quorum;
    }

    return self;
}

#pragma mark - Protobuf Transformable

- (nullable id)transform:(NSError *__autoreleasing *)error {
    SetAccountQuorum *setAccountQuorum = [[SetAccountQuorum alloc] init];
    setAccountQuorum.accountId = [_accountId identifier];
    setAccountQuorum.quorum = _quorum;

    Command *command = [[Command alloc] init];
    command.setAccountQuorum = setAccountQuorum;

    return command;
}

@end

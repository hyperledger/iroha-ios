#import "IRAppendRole.h"
#import "Commands.pbobjc.h"

@implementation IRAppendRole
@synthesize accountId = _accountId;
@synthesize roleName = _roleName;

- (nonnull instancetype)initWithAccountId:(nonnull id<IRAccountId>)accountId
                                 roleName:(nonnull id<IRRoleName>)roleName {

    if (self = [super init]) {
        _accountId = accountId;
        _roleName = roleName;
    }

    return self;
}

#pragma mark - Protobuf Transformable

- (nullable id)transform:(NSError *__autoreleasing *)error {
    AppendRole *appendRole = [[AppendRole alloc] init];
    appendRole.accountId = [_accountId identifier];
    appendRole.roleName = [_roleName value];

    Command *command = [[Command alloc] init];
    command.appendRole = appendRole;

    return command;
}

@end

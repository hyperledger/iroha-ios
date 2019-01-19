#import "IRDetachRole.h"
#import "Commands.pbobjc.h"

@implementation IRDetachRole
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
    DetachRole *detachRole = [[DetachRole alloc] init];
    detachRole.accountId = [_accountId identifier];
    detachRole.roleName = [_roleName value];

    Command *command = [[Command alloc] init];
    command.detachRole = detachRole;

    return command;
}

@end

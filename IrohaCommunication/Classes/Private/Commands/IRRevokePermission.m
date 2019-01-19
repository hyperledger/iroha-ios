#import "IRRevokePermission.h"
#import "Commands.pbobjc.h"

@implementation IRRevokePermission
@synthesize accountId = _accountId;
@synthesize permission = _permission;

- (nonnull instancetype)initWithAccountId:(nonnull id<IRAccountId>)accountId
                               permission:(nonnull id<IRGrantablePermission>)permission {

    if (self = [super init]) {
        _accountId = accountId;
        _permission = permission;
    }

    return self;
}

#pragma mark - Protobuf Transformable

- (nullable id)transform:(NSError *__autoreleasing *)error {
    RevokePermission *revokePermission = [[RevokePermission alloc] init];
    revokePermission.accountId = [_accountId identifier];
    revokePermission.permission = [_permission value];

    Command *command = [[Command alloc] init];
    command.revokePermission = revokePermission;

    return command;
}

@end

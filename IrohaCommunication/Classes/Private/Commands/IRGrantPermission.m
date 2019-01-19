#import "IRGrantPermission.h"
#import "Commands.pbobjc.h"

@implementation IRGrantPermission
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
    GrantPermission *grantPermission = [[GrantPermission alloc] init];
    grantPermission.accountId = [_accountId identifier];
    grantPermission.permission = _permission.value;

    Command *command = [[Command alloc] init];
    command.grantPermission = grantPermission;

    return command;
}

@end

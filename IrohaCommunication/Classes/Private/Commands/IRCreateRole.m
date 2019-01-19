#import "IRCreateRole.h"
#import "Commands.pbobjc.h"

@implementation IRCreateRole
@synthesize roleName = _roleName;
@synthesize permissions = _permissions;

- (nonnull instancetype)initWithRoleName:(nonnull id<IRRoleName>)roleName
                             permissions:(nonnull NSArray<id<IRRolePermission>>*)permissions {

    if (self = [super init]) {
        _roleName = roleName;
        _permissions = permissions;
    }

    return self;
}

#pragma mark - Protobuf Transformable

- (nullable id)transform:(NSError *__autoreleasing *)error {
    CreateRole *createRole = [[CreateRole alloc] init];
    createRole.roleName = [_roleName value];

    GPBEnumArray *protobufPermissions = [[GPBEnumArray alloc] init];

    for (id<IRRolePermission> permission in _permissions) {
        [protobufPermissions addRawValue:permission.value];
    }

    createRole.permissionsArray = protobufPermissions;

    Command *command = [[Command alloc] init];
    command.createRole = createRole;

    return command;
}

@end

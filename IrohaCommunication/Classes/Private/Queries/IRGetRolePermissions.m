#import "IRGetRolePermissions.h"
#import "Queries.pbobjc.h"

@implementation IRGetRolePermissions
@synthesize roleName = _roleName;

- (nonnull instancetype)initWithRoleName:(nonnull id<IRRoleName>)roleName {
    if (self = [super init]) {
        _roleName = roleName;
    }

    return self;
}

#pragma mark - Protobuf Transformable

- (nullable id)transform:(NSError**)error {
    GetRolePermissions *query = [[GetRolePermissions alloc] init];
    query.roleId = [_roleName value];

    Query_Payload *payload = [[Query_Payload alloc] init];
    payload.getRolePermissions = query;

    return payload;
}

@end

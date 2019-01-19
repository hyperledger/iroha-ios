#import <Foundation/Foundation.h>
#import "IRQuery.h"
#import "IRProtobufTransformable.h"

@interface IRGetRolePermissions : NSObject<IRGetRolePermissions, IRProtobufTransformable>

- (nonnull instancetype)initWithRoleName:(nonnull id<IRRoleName>)roleName;

@end

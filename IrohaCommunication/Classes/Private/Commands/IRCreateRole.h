#import <Foundation/Foundation.h>
#import "IRCommand.h"
#import "IRProtobufTransformable.h"

@interface IRCreateRole : NSObject<IRCreateRole, IRProtobufTransformable>

- (nonnull instancetype)initWithRoleName:(nonnull id<IRRoleName>)roleName
                             permissions:(nonnull NSArray<id<IRRolePermission>>*)permissions;

@end

#import <Foundation/Foundation.h>
#import "IRQueryResponse.h"

@interface IRRolesResponse : NSObject<IRRolesResponse>

- (nonnull instancetype)initWithRoles:(nonnull NSArray<id<IRRoleName>>*)roles
                            queryHash:(nonnull NSData*)queryHash;

@end

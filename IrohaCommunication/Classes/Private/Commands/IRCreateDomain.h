#import <Foundation/Foundation.h>
#import "IRCommand.h"
#import "IRProtobufTransformable.h"

@interface IRCreateDomain : NSObject<IRCreateDomain, IRProtobufTransformable>

- (nonnull instancetype)initWithDomain:(nonnull id<IRDomain>)domain
                           defaultRole:(nullable id<IRRoleName>)defaultRole;

@end

#import "IRRoleName.h"

static NSString * const ROLE_NAME_FORMAT = @"[a-z_0-9]{1,32}";

@interface IRRoleName : NSObject<IRRoleName>

- (instancetype)initWithName:(nonnull NSString*)name;

@end

@implementation IRRoleName
@synthesize value = _value;

- (instancetype)initWithName:(nonnull NSString*)name {
    if (self = [super init]) {
        _value = name;
    }

    return self;
}

@end

@implementation IRRoleNameFactory

+ (nullable id<IRRoleName>)roleWithName:(nonnull NSString*)name error:(NSError**)error {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ROLE_NAME_FORMAT];

    if ([predicate evaluateWithObject:name]) {
        return [[IRRoleName alloc] initWithName:name];
    } else {
        if (error) {
            NSString *message = [NSString stringWithFormat:@"Role name %@ is invalid. Expected: %@", name, ROLE_NAME_FORMAT];
            *error = [NSError errorWithDomain:NSStringFromClass([IRRoleNameFactory class])
                                         code:IRInvalidRoleName
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }
        
        return nil;
    }
}

@end

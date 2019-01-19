#import "IRGrantablePermission.h"
#import "Primitive.pbobjc.h"

@interface IRGrantablePermission : NSObject<IRGrantablePermission>

- (instancetype)initWithPermission:(GrantablePermission)permission;

@end

@implementation IRGrantablePermission
@synthesize value = _value;

- (instancetype)initWithPermission:(GrantablePermission)permission {
    if (self = [super init]) {
        _value = permission;
    }

    return self;
}

- (NSUInteger)hash {
    return (NSUInteger)_value;
}

- (BOOL)isEqual:(id)object {
    if (![object conformsToProtocol:@protocol(IRGrantablePermission)]) {
        return false;
    }

    return _value == [(id<IRGrantablePermission>)object value];
}

@end

@implementation IRGrantablePermissionFactory

+ (nullable id<IRGrantablePermission>)permissionWithValue:(int32_t)value error:(NSError**)error {
    if (!GrantablePermission_IsValidValue(value)) {
        if (error) {
            NSString *message = @"Invalid grantable permission value passed.";
            *error = [NSError errorWithDomain:NSStringFromClass([IRGrantablePermissionFactory class])
                                         code:IRInvalidGrantablePermissionValue
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }
        return nil;
    }

    return [[IRGrantablePermission alloc] initWithPermission:value];
}

+ (nonnull id<IRGrantablePermission>)canAddMySignatory {
    return [self permissionWithValue:GrantablePermission_CanAddMySignatory error:nil];
}

+ (nonnull id<IRGrantablePermission>)canRemoveMySignatory {
    return [self permissionWithValue:GrantablePermission_CanRemoveMySignatory error:nil];
}

+ (nonnull id<IRGrantablePermission>)canSetMyQuorum {
    return [self permissionWithValue:GrantablePermission_CanSetMyQuorum error:nil];
}

+ (nonnull id<IRGrantablePermission>)canSetMyAccountDetail {
    return [self permissionWithValue:GrantablePermission_CanSetMyAccountDetail error:nil];
}

@end

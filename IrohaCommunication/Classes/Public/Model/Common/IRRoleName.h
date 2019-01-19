#import <Foundation/Foundation.h>

@protocol IRRoleName <NSObject>

@property(nonatomic, readonly)NSString * _Nonnull value;

@end

typedef NS_ENUM(NSUInteger, IRRoleNameFactoryError) {
    IRInvalidRoleName
};

@protocol IRRoleNameFactoryProtocol <NSObject>

+ (nullable id<IRRoleName>)roleWithName:(nonnull NSString*)name error:(NSError**)error;

@end

@interface IRRoleNameFactory : NSObject<IRRoleNameFactoryProtocol>

@end

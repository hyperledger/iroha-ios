#import <Foundation/Foundation.h>

@protocol IRDomain <NSObject>

@property(nonatomic, readonly)NSString * _Nonnull identifier;

@end

typedef NS_ENUM(NSUInteger, IRDomainFactoryError) {
    IRInvalidDomainIdentifier
};

@protocol IRDomainFactoryProtocol <NSObject>

+ (nullable id<IRDomain>)domainWithIdentitifer:(nonnull NSString*)identifier error:(NSError**)error;

@end

@interface IRDomainFactory : NSObject<IRDomainFactoryProtocol>

@end

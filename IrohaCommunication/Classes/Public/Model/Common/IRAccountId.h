#import <Foundation/Foundation.h>
#import "IRDomain.h"

@protocol IRAccountId <NSObject>

@property(nonatomic, readonly)NSString * _Nonnull name;
@property(nonatomic, readonly)id<IRDomain> _Nonnull domain;

- (nonnull NSString*)identifier;

@end

typedef NS_ENUM(NSUInteger, IRAccountIdFactoryError) {
    IRInvalidAccountName,
    IRInvalidAccountIdentifier
};

@protocol IRAccountIdFactoryProtocol <NSObject>

+ (nullable id<IRAccountId>)accountIdWithName:(nonnull NSString*)name
                                       domain:(nonnull id<IRDomain>)domain
                                        error:(NSError**)error;

+ (nullable id<IRAccountId>)accountWithIdentifier:(nonnull NSString*)accountId
                                          error:(NSError**)error;

@end

@interface IRAccountIdFactory : NSObject<IRAccountIdFactoryProtocol>

@end

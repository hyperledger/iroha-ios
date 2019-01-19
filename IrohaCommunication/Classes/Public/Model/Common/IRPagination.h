#import <Foundation/Foundation.h>

@protocol IRPagination <NSObject>

@property(nonatomic, readonly)UInt32 pageSize;

@property(nonatomic, readonly)NSData * _Nullable firstItemHash;

@end

typedef NS_ENUM(NSUInteger, IRPaginationFactoryError) {
    IRPaginationFactoryErrorInvalidHash
};

@protocol IRPaginationFactoryProtocol <NSObject>

+ (nullable id<IRPagination>)pagination:(UInt32)pageSize
                          firstItemHash:(nullable NSData*)firstItemHash
                                  error:(NSError **)error;

@end

@interface IRPaginationFactory : NSObject<IRPaginationFactoryProtocol>

@end

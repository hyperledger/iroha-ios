#import "IRPagination.h"

@interface IRPagination : NSObject<IRPagination>

@end

@implementation IRPagination
@synthesize pageSize = _pageSize;
@synthesize firstItemHash = _firstItemHash;

- (nonnull instancetype)initWithPageSize:(UInt32)pageSize
                           firstItemHash:(nullable NSData*)firstItemHash {
    if (self = [super init]) {
        _pageSize = pageSize;
        _firstItemHash = firstItemHash;
    }

    return self;
}

@end

@implementation IRPaginationFactory

+ (nullable id<IRPagination>)pagination:(UInt32)pageSize
                          firstItemHash:(nullable NSData*)firstItemHash
                                  error:(NSError **)error {
    if (firstItemHash && firstItemHash.length != 32) {
        if (error) {
            NSString *message = @"Item hash must be 32 byte length";
            *error = [NSError errorWithDomain:NSStringFromClass([IRPaginationFactory class])
                                         code:IRPaginationFactoryErrorInvalidHash
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }
        return nil;
    }

    return [[IRPagination alloc] initWithPageSize:pageSize firstItemHash:firstItemHash];
}

@end

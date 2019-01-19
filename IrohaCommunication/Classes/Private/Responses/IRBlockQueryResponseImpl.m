#import "IRBlockQueryResponseImpl.h"

@implementation IRBlockQueryResponse
@synthesize block = _block;
@synthesize error = _error;

- (nonnull instancetype)initWithBlock:(nonnull id<IRBlock>)block {
    if (self = [super init]) {
        _block = block;
    }

    return self;
}

- (nonnull instancetype)initWithError:(nonnull NSError*)error {
    if (self = [super init]) {
        _error = error;
    }

    return self;
}

@end

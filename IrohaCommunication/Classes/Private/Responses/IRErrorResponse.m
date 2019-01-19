#import "IRErrorResponse.h"

@implementation IRErrorResponse
@synthesize reason = _reason;
@synthesize message = _message;
@synthesize code = _code;
@synthesize queryHash = _queryHash;

- (nonnull instancetype)initWithReason:(IRErrorResponseReason)reason
                               message:(nonnull NSString*)message
                                  code:(UInt32)code
                             queryHash:(nonnull NSData*)queryHash {

    if (self = [super init]) {
        _reason = reason;
        _message = message;
        _code = code;
        _queryHash = queryHash;
    }

    return self;
}

@end

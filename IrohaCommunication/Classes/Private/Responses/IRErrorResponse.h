#import <Foundation/Foundation.h>
#import <IRQueryResponse.h>

@interface IRErrorResponse : NSObject<IRErrorResponse>

- (nonnull instancetype)initWithReason:(IRErrorResponseReason)reason
                               message:(nonnull NSString*)message
                                  code:(UInt32)code
                             queryHash:(nonnull NSData*)queryHash;

@end

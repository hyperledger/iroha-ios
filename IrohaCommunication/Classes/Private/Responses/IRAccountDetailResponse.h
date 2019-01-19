#import <Foundation/Foundation.h>
#import "IRQueryResponse.h"

@interface IRAccountDetailResponse : NSObject<IRAccountDetailResponse>

- (nonnull instancetype)initWithDetail:(nonnull NSString*)detail
                             queryHash:(nonnull NSData*)queryHash;

@end

#import <Foundation/Foundation.h>
#import "IRQueryResponse.h"

@interface IRAccountResponse : NSObject<IRAccountResponse>

- (nonnull instancetype)initWithAccountId:(nonnull id<IRAccountId>)accountId
                                   quorum:(UInt32)quorum
                                  details:(nullable NSString*)details
                                    roles:(nonnull NSArray<id<IRRoleName>>*)roles
                                queryHash:(nonnull NSData*)queryHash;

@end

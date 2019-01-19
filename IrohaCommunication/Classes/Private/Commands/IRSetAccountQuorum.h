#import <Foundation/Foundation.h>
#import "IRCommand.h"
#import "IRProtobufTransformable.h"

@interface IRSetAccountQuorum : NSObject<IRSetAccountQuorum, IRProtobufTransformable>

- (nonnull instancetype)initWithAccountId:(nonnull id<IRAccountId>)accountId
                                   quorum:(UInt32)quorum;

@end

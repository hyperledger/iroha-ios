#import <Foundation/Foundation.h>
#import "IRCommand.h"
#import "IRProtobufTransformable.h"

@interface IRSetAccountDetail : NSObject<IRSetAccountDetail, IRProtobufTransformable>

- (nonnull instancetype)initWithAccountId:(nonnull id<IRAccountId>)accountId
                                      key:(nonnull NSString*)key
                                    value:(nonnull NSString*)value;

@end

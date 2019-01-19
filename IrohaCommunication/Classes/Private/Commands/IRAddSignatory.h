#import <Foundation/Foundation.h>
#import "IRCommand.h"
#import "IRProtobufTransformable.h"

@interface IRAddSignatory : NSObject<IRAddSignatory, IRProtobufTransformable>

- (nonnull instancetype)initWithAccountId:(nonnull id<IRAccountId>)accountId
                                 publicKey:(nonnull id<IRPublicKeyProtocol>)publicKey;

@end

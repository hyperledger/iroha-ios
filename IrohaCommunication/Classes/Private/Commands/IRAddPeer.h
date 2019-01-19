#import <Foundation/Foundation.h>
#import "IRCommand.h"
#import "IRProtobufTransformable.h"

@interface IRAddPeer : NSObject<IRAddPeer, IRProtobufTransformable>

- (nonnull instancetype)initWithAddress:(nonnull id<IRAddress>)address
                              publicKey:(nonnull id<IRPublicKeyProtocol>)publicKey;

@end

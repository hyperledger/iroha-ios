#import "IRAddPeer.h"
#import "Commands.pbobjc.h"
#import "Primitive.pbobjc.h"
#import <IrohaCrypto/NSData+Hex.h>

@implementation IRAddPeer
@synthesize address = _address;
@synthesize publicKey = _publicKey;

- (nonnull instancetype)initWithAddress:(nonnull id<IRAddress>)address
                              publicKey:(nonnull id<IRPublicKeyProtocol>)publicKey {
    
    if (self = [super init]) {
        _address = address;
        _publicKey = publicKey;
    }

    return self;
}

#pragma mark - Protobuf Transformable

- (nullable id)transform:(NSError *__autoreleasing *)error {
    AddPeer *addPeer = [[AddPeer alloc] init];

    Peer *peer = [[Peer alloc] init];
    peer.address = [_address value];
    peer.peerKey = [_publicKey.rawData toHexString];

    addPeer.peer = peer;

    Command *command = [[Command alloc] init];
    command.addPeer = addPeer;

    return command;
}

@end

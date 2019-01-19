#import "IRPeerSignature.h"

@interface IRPeerSignature : NSObject<IRPeerSignature>

- (nonnull instancetype)initWithSignature:(nonnull id<IRSignatureProtocol>)signature
                                publicKey:(nonnull id<IRPublicKeyProtocol>)publicKey;

@end

@implementation IRPeerSignature
@synthesize signature = _signature;
@synthesize publicKey = _publicKey;

- (nonnull instancetype)initWithSignature:(nonnull id<IRSignatureProtocol>)signature
                                publicKey:(nonnull id<IRPublicKeyProtocol>)publicKey {

    if (self = [super init]) {
        _signature = signature;
        _publicKey = publicKey;
    }

    return self;
}

@end

@implementation IRPeerSignatureFactory

+ (nullable id<IRPeerSignature>)peerSignature:(nonnull id<IRSignatureProtocol>)signature
                                    publicKey:(nonnull id<IRPublicKeyProtocol>)publicKey
                                        error:(NSError**)error {
    
    return [[IRPeerSignature alloc] initWithSignature:signature
                                            publicKey:publicKey];
}

@end

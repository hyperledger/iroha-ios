#import "IRPeerSignature+Proto.h"
#import "Primitive.pbobjc.h"
#import <IrohaCrypto/NSData+Hex.h>

@implementation IRPeerSignatureFactory (Proto)

+ (nullable id<IRPeerSignature>)peerSignatureFromPbSignature:(nonnull Signature *)pbSignature
                                                       error:(NSError*_Nullable*_Nullable)error {
    NSData *rawSignature = [[NSData alloc] initWithHexString:pbSignature.signature];

    if (!rawSignature) {
        if (error) {
            NSString *message = [NSString stringWithFormat:@"Unexpected hex signature %@", pbSignature.signature];
            *error = [NSError errorWithDomain:NSStringFromClass([IRPeerSignatureFactory class])
                                         code:IRPeerSignatureFactoryProtoErrorInvalidArgument
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }

        return nil;
    }

    id<IRSignatureProtocol> signature = [[IREd25519Sha512Signature alloc] initWithRawData:rawSignature];

    if (!signature) {
        if (error) {
            NSString *message = [NSString stringWithFormat:@"Invalid signature %@", pbSignature.signature];
            *error = [NSError errorWithDomain:NSStringFromClass([IRPeerSignatureFactory class])
                                         code:IRPeerSignatureFactoryProtoErrorInvalidArgument
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }
        return nil;
    }

    NSData *rawPublicKey = [[NSData alloc] initWithHexString:pbSignature.publicKey];

    if (!rawPublicKey) {
        if (error) {
            NSString *message = [NSString stringWithFormat:@"Unexpected hex public key %@", pbSignature.publicKey];
            *error = [NSError errorWithDomain:NSStringFromClass([IRPeerSignatureFactory class])
                                         code:IRPeerSignatureFactoryProtoErrorInvalidArgument
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }

        return nil;
    }

    id<IRPublicKeyProtocol> publicKey = [[IREd25519PublicKey alloc] initWithRawData:rawPublicKey];

    if (!publicKey) {
        if (error) {
            NSString *message = [NSString stringWithFormat:@"Invalid public key %@", pbSignature.publicKey];
            *error = [NSError errorWithDomain:NSStringFromClass([IRPeerSignatureFactory class])
                                         code:IRPeerSignatureFactoryProtoErrorInvalidArgument
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }
        return nil;
    }

    return [IRPeerSignatureFactory peerSignature:signature
                                       publicKey:publicKey
                                           error:error];
}

@end

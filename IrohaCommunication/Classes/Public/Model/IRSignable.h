#ifndef IRSignable_h
#define IRSignable_h

#import <IrohaCrypto/IRSignatureCreator.h>
#import "IRPeerSignature.h"

@protocol IRSignable <NSObject>

- (nullable id<IRPeerSignature>)signWithSignatory:(nonnull id<IRSignatureCreatorProtocol>)signatory
                                   signatoryPublicKey:(nonnull id<IRPublicKeyProtocol>)signatoryPublicKey
                                                error:(NSError**)error;

@end

#endif /* IRSignable_h */

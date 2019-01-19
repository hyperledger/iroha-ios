#ifndef IRQueryRequest_h
#define IRQueryRequest_h

#import "IRQuery.h"
#import "IRSignable.h"
#import "IRPeerSignature.h"
#import <IrohaCrypto/IRSignature.h>

@protocol IRQueryRequest <NSObject, IRSignable>

@property(nonatomic, readonly)id<IRAccountId> _Nonnull creator;
@property(nonatomic, readonly)NSDate* _Nonnull createdAt;
@property(nonatomic, readonly)UInt64 queryCounter;
@property(nonatomic, readonly)id<IRQuery> _Nonnull query;
@property(nonatomic, readonly)id<IRPeerSignature> _Nullable peerSignature;

- (nullable instancetype)signedWithSignatory:(nonnull id<IRSignatureCreatorProtocol>)signatory
                          signatoryPublicKey:(nonnull id<IRPublicKeyProtocol>)signatoryPublicKey
                                       error:(NSError**)error;

@end

#endif

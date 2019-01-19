#import "IRBlockQueryRequestImpl.h"
#import "Queries.pbobjc.h"
#import "Primitive.pbobjc.h"
#import <IrohaCrypto/NSData+SHA3.h>
#import <IrohaCrypto/NSData+Hex.h>
#import "NSDate+IrohaCommunication.h"

@implementation IRBlockQueryRequest
@synthesize creator = _creator;
@synthesize createdAt = _createdAt;
@synthesize queryCounter = _queryCounter;
@synthesize peerSignature = _peerSignature;

- (nonnull instancetype)initWithCreator:(nonnull id<IRAccountId>)creator
                              createdAt:(nonnull NSDate*)createdAt
                           queryCounter:(UInt64)queryCounter
                          peerSignature:(nullable id<IRPeerSignature>)peerSignature {

    if (self = [super init]) {
        _creator = creator;
        _createdAt = createdAt;
        _queryCounter = queryCounter;
        _peerSignature = peerSignature;
    }

    return self;
}

#pragma mark - Signable

- (nullable instancetype)signedWithSignatory:(nonnull id<IRSignatureCreatorProtocol>)signatory
                          signatoryPublicKey:(nonnull id<IRPublicKeyProtocol>)signatoryPublicKey
                                       error:(NSError**)error {

    id<IRPeerSignature> peerSignature = [self signWithSignatory:signatory
                                             signatoryPublicKey:signatoryPublicKey
                                                          error:error];

    if (!peerSignature) {
        return nil;
    }

    return [[IRBlockQueryRequest alloc] initWithCreator:_creator
                                               createdAt:_createdAt
                                            queryCounter:_queryCounter
                                           peerSignature:peerSignature];
}

- (nullable id<IRPeerSignature>)signWithSignatory:(id<IRSignatureCreatorProtocol>)signatory
                               signatoryPublicKey:(id<IRPublicKeyProtocol>)signatoryPublicKey
                                            error:(NSError *__autoreleasing *)error {

    QueryPayloadMeta *payload = [self createPayload:error];

    if (!payload) {
        return nil;
    }

    id<IRSignatureProtocol> signature = [self signPayload:payload
                                                signatory:signatory
                                                    error:error];

    if (!signature) {
        return nil;
    }

    id<IRPeerSignature> peerSignature = [IRPeerSignatureFactory peerSignature:signature
                                                                    publicKey:signatoryPublicKey
                                                                        error:error];

    return peerSignature;
}

#pragma mark - Protobuf Transformables

- (nullable id)transform:(NSError*_Nullable*_Nullable)error {
    QueryPayloadMeta *payload = [self createPayload:error];

    if (!payload) {
        return nil;
    }

    BlocksQuery *query = [[BlocksQuery alloc] init];
    query.meta = payload;

    if (_peerSignature) {
        Signature *signature = [[Signature alloc] init];
        signature.signature = [_peerSignature.signature.rawData toHexString];
        signature.publicKey = [_peerSignature.publicKey.rawData toHexString];

        query.signature = signature;
    }

    return query;
}

#pragma mark - Private

- (nullable QueryPayloadMeta*)createPayload:(NSError**)error {
    QueryPayloadMeta *meta = [[QueryPayloadMeta alloc] init];
    meta.creatorAccountId = [_creator identifier];
    meta.createdTime = [_createdAt milliseconds];
    meta.queryCounter = _queryCounter;

    return meta;
}

- (nullable id<IRSignatureProtocol>)signPayload:(nonnull QueryPayloadMeta*)payload
                                      signatory:(nonnull id<IRSignatureCreatorProtocol>)signatory
                                          error:(NSError**)error {
    NSData *payloadData = [payload data];

    if (!payloadData) {
        if (error) {
            NSString *message = @"Empty payload received";
            *error = [IRBlockQueryRequest errorWithType:IRQueryRequestErrorSigning
                                                 message:message];
        }
        return nil;
    }

    NSData *sha3Data = [payloadData sha3:IRSha3Variant256];

    if (!sha3Data) {
        if (error) {
            NSString *message = @"Hashing function failed";
            *error = [IRBlockQueryRequest errorWithType:IRQueryRequestErrorSigning
                                                 message:message];
        }
        return nil;
    }

    id<IRSignatureProtocol> signature = [signatory sign:sha3Data];

    if (!signature) {
        if (error) {
            NSString *message = @"Signing function failed";
            *error = [IRBlockQueryRequest errorWithType:IRQueryRequestErrorSigning
                                                 message:message];
        }
        return nil;
    }

    return signature;
}

#pragma mark - Helpers

+ (nonnull NSError*)errorWithType:(IRQueryRequestError)errorType message:(nonnull NSString*)message {
    return [NSError errorWithDomain:NSStringFromClass([IRBlockQueryRequest class])
                               code:errorType
                           userInfo:@{NSLocalizedDescriptionKey: message}];
}


@end

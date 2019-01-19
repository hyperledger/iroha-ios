#import "IRTransactionImpl.h"
#import "Transaction.pbobjc.h"
#import "Commands.pbobjc.h"
#import "Primitive.pbobjc.h"
#import "IRProtobufTransformable.h"
#import <IrohaCrypto/NSData+SHA3.h>
#import <IrohaCrypto/NSData+Hex.h>
#import "NSDate+IrohaCommunication.h"

@implementation IRTransaction
@synthesize creator = _creator;
@synthesize createdAt = _createdAt;
@synthesize commands = _commands;
@synthesize quorum = _quorum;
@synthesize signatures = _signatures;
@synthesize batchHashes = _batchHashes;
@synthesize batchType = _batchType;

- (nonnull instancetype)initWithCreatorAccountId:(nonnull id<IRAccountId>)creatorAccountId
                                       createdAt:(nonnull NSDate*)createdAt
                                        commands:(nonnull NSArray<id<IRCommand>>*)commands
                                          quorum:(NSUInteger)quorum
                                      signatures:(nullable NSArray<id<IRPeerSignature>>*)signatures
                                     batchHashes:(nullable NSArray<NSData*>*)batchHashes
                                       batchType:(IRTransactionBatchType)batchType {

    if (self = [super init]) {
        _creator = creatorAccountId;
        _createdAt = createdAt;
        _commands = commands;
        _quorum = quorum;
        _signatures = signatures;
        _batchHashes = batchHashes;
        _batchType = batchType;
    }

    return self;
}

#pragma mark - Protobuf Transformable

- (nullable id)transform:(NSError*_Nullable*_Nullable)error {
    Transaction_Payload *payload = [self createPayload:error];

    if (!payload) {
        return nil;
    }

    Transaction *transaction = [[Transaction alloc] init];
    transaction.payload = payload;

    NSMutableArray<Signature*> *rawSignatures = [NSMutableArray array];
    for (id<IRPeerSignature> signature in _signatures) {
        Signature *protobufSignature = [[Signature alloc] init];
        protobufSignature.signature = [signature.signature.rawData toHexString];
        protobufSignature.publicKey = [signature.publicKey.rawData toHexString];

        [rawSignatures addObject:protobufSignature];
    }

    transaction.signaturesArray = rawSignatures;

    return transaction;
}

#pragma mark - Signable

- (nullable NSData*)transactionHashWithError:(NSError **)error {
    Transaction_Payload *payload = [self createPayload:error];

    if (!payload) {
        return nil;
    }

    NSData *payloadData = [payload data];

    if (!payloadData) {
        if (error) {
            NSString *message = @"Empty payload received";
            *error = [IRTransaction errorWithType:IRTransactionErrorHashing
                                          message:message];
        }
        return nil;
    }

    NSData *sha3Data = [payloadData sha3:IRSha3Variant256];

    if (!sha3Data) {
        if (error) {
            NSString *message = @"Hashing function failed";
            *error = [IRTransaction errorWithType:IRTransactionErrorHashing
                                          message:message];
        }
        return nil;
    }

    return sha3Data;
}

- (nullable id<IRPeerSignature>)signWithSignatory:(nonnull id<IRSignatureCreatorProtocol>)signatory
                               signatoryPublicKey:(nonnull id<IRPublicKeyProtocol>)signatoryPublicKey
                                            error:(NSError**)error {

    Transaction_Payload *payload = [self createPayload:error];

    if (!payload) {
        return nil;
    }

    id<IRSignatureProtocol> signature = [self signPayload:payload
                                                signatory:signatory
                                                    error:error];

    id<IRPeerSignature> peerSignature = [IRPeerSignatureFactory peerSignature:signature
                                                                    publicKey:signatoryPublicKey
                                                                        error:error];

    return peerSignature;
}

- (nullable instancetype)signedWithSignatories:(nonnull NSArray<id<IRSignatureCreatorProtocol>>*)signatories
                           signatoryPublicKeys:(nonnull NSArray<id<IRPublicKeyProtocol>> *)signatoryPublicKeys
                                         error:(NSError**)error {

    if ([signatories count] == 0) {
        if (error) {
            *error = [IRTransaction errorWithType:IRTransactionErrorInvalidField
                                          message:@"Unexpected empty signatories list found"];
        }

        return nil;
    }

    if ([signatories count] != [signatoryPublicKeys count]) {
        if (error) {
            NSString *message = @"Number of signatories must be the same as number of public keys.";
            *error = [IRTransaction errorWithType:IRTransactionErrorInvalidField
                                          message:message];
        }

        return nil;
    }

    Transaction_Payload *payload = [self createPayload:error];

    if (!payload) {
        return nil;
    }

    NSMutableArray<id<IRPeerSignature>> *peerSignatures = [NSMutableArray array];

    if (_signatures) {
        [peerSignatures addObjectsFromArray:_signatures];
    }

    for(NSUInteger i = 0; i < [signatories count]; i++) {
        id<IRSignatureProtocol> signature = [self signPayload:payload
                                                    signatory:signatories[i]
                                                        error:error];

        if (!signature) {
            return nil;
        }

        id<IRPeerSignature> peerSignature = [IRPeerSignatureFactory peerSignature:signature
                                                                        publicKey:signatoryPublicKeys[i]
                                                                            error:error];

        if (!peerSignature) {
            return nil;
        }

        [peerSignatures addObject:peerSignature];
    }

    return [[IRTransaction alloc] initWithCreatorAccountId:_creator
                                                 createdAt:_createdAt
                                                  commands:_commands
                                                    quorum:_quorum
                                                signatures:peerSignatures
                                               batchHashes:_batchHashes
                                                 batchType:_batchType];
}

#pragma mark - Batch

- (nullable instancetype)batched:(nullable NSArray<NSData*>*)transactionBatchHashes
                       batchType:(IRTransactionBatchType)batchType
                           error:(NSError**)error {

    if (batchType == IRTransactionBatchTypeNone) {
        return [[IRTransaction alloc] initWithCreatorAccountId:_creator
                                                     createdAt:_createdAt
                                                      commands:_commands
                                                        quorum:_quorum
                                                    signatures:nil
                                                   batchHashes:nil
                                                     batchType:IRTransactionBatchTypeNone];
    }

    if (!transactionBatchHashes || [transactionBatchHashes count] == 0) {
        if (error) {
            *error = [IRTransaction errorWithType:IRTransactionErrorInvalidField
                                          message:@"Unexpected empty batch hash list found"];
        }

        return nil;
    }

    return [[IRTransaction alloc] initWithCreatorAccountId:_creator
                                                 createdAt:_createdAt
                                                  commands:_commands
                                                    quorum:_quorum
                                                signatures:nil
                                               batchHashes:transactionBatchHashes
                                                 batchType:batchType];
}

- (nullable NSData*)batchHashWithError:(NSError **)error {
    Transaction_Payload_ReducedPayload *reducedPayload = [self createReducedPayload:error];

    if (!reducedPayload) {
        return nil;
    }

    NSData *reducedPayloadData = [reducedPayload data];

    if (!reducedPayload) {
        if (error) {
            NSString *message = @"Empty reduced payload received";
            *error = [IRTransaction errorWithType:IRTransactionErrorHashing
                                          message:message];
        }
        return nil;
    }

    NSData *sha3Data = [reducedPayloadData sha3:IRSha3Variant256];

    if (!sha3Data) {
        if (error) {
            NSString *message = @"Hashing function failed";
            *error = [IRTransaction errorWithType:IRTransactionErrorHashing
                                          message:message];
        }
        return nil;
    }

    return sha3Data;
}

#pragma mark - Private

- (nullable Transaction_Payload_ReducedPayload*)createReducedPayload:(NSError**)error {
    NSMutableArray<Command*> *protobufCommands = [NSMutableArray array];

    for (id<IRCommand> command in _commands) {
        if (![command conformsToProtocol:@protocol(IRProtobufTransformable)]) {
            if (error) {
                NSString *message = [NSString stringWithFormat:@"%@ command must conform %@",
                                     NSStringFromClass([command class]),
                                     NSStringFromProtocol(@protocol(IRProtobufTransformable))];

                *error = [IRTransaction errorWithType:IRTransactionErrorSerialization
                                              message:message];
            }
            return nil;
        }

        id protobufCommand = [(id<IRProtobufTransformable>)command transform:error];

        if (![protobufCommand isKindOfClass:[Command class]]) {
            if (error) {
                NSString *message = [NSString stringWithFormat:@"%@ command must tranform %@",
                                     NSStringFromClass([command class]),
                                     NSStringFromProtocol(@protocol(IRProtobufTransformable))];

                *error = [IRTransaction errorWithType:IRTransactionErrorSerialization
                                              message:message];
            }
            return nil;
        }

        [protobufCommands addObject:(Command*)protobufCommand];
    }

    Transaction_Payload_ReducedPayload *reducedPayload = [[Transaction_Payload_ReducedPayload alloc] init];
    reducedPayload.commandsArray = protobufCommands;
    reducedPayload.creatorAccountId = [_creator identifier];
    reducedPayload.createdTime = [_createdAt milliseconds];
    reducedPayload.quorum = (uint32_t)_quorum;

    return reducedPayload;
}

- (nullable Transaction_Payload*)createPayload:(NSError**)error {
    Transaction_Payload_ReducedPayload *reducedPayload = [self createReducedPayload:error];

    if (!reducedPayload) {
        return nil;
    }

    Transaction_Payload *payload = [[Transaction_Payload alloc] init];
    payload.reducedPayload = reducedPayload;

    Transaction_Payload_BatchMeta_BatchType pbBatchType = Transaction_Payload_BatchMeta_BatchType_GPBUnrecognizedEnumeratorValue;

    switch (_batchType) {
        case IRTransactionBatchTypeAtomic:
            pbBatchType = Transaction_Payload_BatchMeta_BatchType_Atomic;
            break;
        case IRTransactionBatchTypeOrdered:
            pbBatchType = Transaction_Payload_BatchMeta_BatchType_Ordered;
            break;
        default:
            break;
    }

    if (pbBatchType != Transaction_Payload_BatchMeta_BatchType_GPBUnrecognizedEnumeratorValue) {
        Transaction_Payload_BatchMeta *pbBatchMeta = [[Transaction_Payload_BatchMeta alloc] init];
        pbBatchMeta.type = pbBatchType;

        NSMutableArray<NSString*> *pbReducedHashes = [NSMutableArray array];

        for (NSData *batchHash in _batchHashes) {
            [pbReducedHashes addObject:[batchHash toHexString]];
        }

        pbBatchMeta.reducedHashesArray = pbReducedHashes;

        payload.batch = pbBatchMeta;
    }

    return payload;
}

- (nullable id<IRSignatureProtocol>)signPayload:(nonnull Transaction_Payload*)payload
                                      signatory:(nonnull id<IRSignatureCreatorProtocol>)signatory
                                          error:(NSError**)error {
    NSData *payloadData = [payload data];

    if (!payloadData) {
        if (error) {
            NSString *message = @"Empty payload received";
            *error = [IRTransaction errorWithType:IRTransactionErrorSigning
                                          message:message];
        }
        return nil;
    }

    NSData *sha3Data = [payloadData sha3:IRSha3Variant256];

    if (!sha3Data) {
        if (error) {
            NSString *message = @"Hashing function failed";
            *error = [IRTransaction errorWithType:IRTransactionErrorSigning
                                          message:message];
        }
        return nil;
    }

    id<IRSignatureProtocol> signature = [signatory sign:sha3Data];

    if (!signature) {
        if (error) {
            NSString *message = @"Signing function failed";
            *error = [IRTransaction errorWithType:IRTransactionErrorSigning
                                          message:message];
        }
        return nil;
    }

    return signature;
}

#pragma mark - Helpers

+ (nonnull NSError*)errorWithType:(IRTransactionError)errorType message:(nonnull NSString*)message {
    return [NSError errorWithDomain:NSStringFromClass([IRTransaction class])
                               code:errorType
                           userInfo:@{NSLocalizedDescriptionKey: message}];
}

@end

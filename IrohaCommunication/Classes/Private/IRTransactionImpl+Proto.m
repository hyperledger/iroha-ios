#import "IRTransactionImpl+Proto.h"
#import "Transaction.pbobjc.h"
#import "IRPeerSignature+Proto.h"
#import "NSDate+IrohaCommunication.h"
#import "IRCommand+Proto.h"
#import <IrohaCrypto/NSData+Hex.h>

@implementation IRTransaction(Proto)

+ (nullable IRTransaction*)transactionFromPbTransaction:(nonnull Transaction*)pbTransaction
                                                  error:(NSError*_Nullable*_Nullable)error {

    NSMutableArray<id<IRPeerSignature>> *signatures = [NSMutableArray array];
    for (Signature *pbSignature in pbTransaction.signaturesArray) {
        id<IRPeerSignature> signature = [IRPeerSignatureFactory peerSignatureFromPbSignature:pbSignature
                                                                                       error:error];

        if (!signature) {
            return nil;
        }

        [signatures addObject:signature];
    }

    if (!pbTransaction.payload) {
        return nil;
    }

    if (!pbTransaction.payload.reducedPayload) {
        return nil;
    }

    id<IRAccountId> creator = [IRAccountIdFactory accountWithIdentifier:pbTransaction.payload.reducedPayload.creatorAccountId
                                                                  error:error];

    if (!creator) {
        return nil;
    }

    NSDate *createdAt = [NSDate dateWithTimestampInMilliseconds:pbTransaction.payload.reducedPayload.createdTime];

    if (!createdAt) {
        if (error) {
            NSString *message = [NSString stringWithFormat:@"Invalid transaction created time %@", @(pbTransaction.payload.reducedPayload.createdTime)];
            *error = [NSError errorWithDomain:NSStringFromClass([IRTransaction class])
                                         code:IRTransactionProtoErrorInvalidArgument
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }
        return nil;
    }

    NSMutableArray<id<IRCommand>> *commands = [NSMutableArray array];

    for (Command *pbCommand in pbTransaction.payload.reducedPayload.commandsArray) {
        id<IRCommand> command = [IRCommandProtoFactory commandFromPbCommand:pbCommand
                                                                      error:error];

        if (!command) {
            return nil;
        }

        [commands addObject:command];
    }

    NSMutableArray<NSData*> *batchHashes = [NSMutableArray array];
    IRTransactionBatchType batchType = IRTransactionBatchTypeNone;

    if (pbTransaction.payload.optionalBatchMetaOneOfCase == Transaction_Payload_OptionalBatchMeta_OneOfCase_Batch) {
        switch (pbTransaction.payload.batch.type) {
            case Transaction_Payload_BatchMeta_BatchType_Ordered:
                batchType = IRTransactionBatchTypeOrdered;
                break;
            case Transaction_Payload_BatchMeta_BatchType_Atomic:
                batchType = IRTransactionBatchTypeAtomic;
                break;
            default:
                if (error) {
                    NSString *message = [NSString stringWithFormat:@"Invalid batch type %@", @(pbTransaction.payload.batch.type)];
                    *error = [NSError errorWithDomain:NSStringFromClass([IRTransaction class])
                                                 code:IRTransactionProtoErrorInvalidArgument
                                             userInfo:@{NSLocalizedDescriptionKey: message}];
                }
                return nil;
                break;
        }

        for (NSString *pbReducedHash in pbTransaction.payload.batch.reducedHashesArray) {
            NSData *batchHash = [[NSData alloc] initWithHexString:pbReducedHash];

            if (!batchHash) {
                if (error) {
                    NSString *message = [NSString stringWithFormat:@"Invalid batch hash hex %@", pbReducedHash];
                    *error = [NSError errorWithDomain:NSStringFromClass([IRTransaction class])
                                                 code:IRTransactionProtoErrorInvalidArgument
                                             userInfo:@{NSLocalizedDescriptionKey: message}];
                }
                return nil;
            }

            [batchHashes addObject:batchHash];
        }
    }

    return [[IRTransaction alloc] initWithCreatorAccountId:creator
                                                 createdAt:createdAt
                                                  commands:commands
                                                    quorum:pbTransaction.payload.reducedPayload.quorum
                                                signatures:signatures
                                               batchHashes:batchHashes
                                                 batchType:batchType];
}

@end

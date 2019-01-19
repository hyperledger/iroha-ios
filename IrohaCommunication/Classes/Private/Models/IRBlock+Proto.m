#import "IRBlock+Proto.h"
#import "Block.pbobjc.h"
#import "Primitive.pbobjc.h"
#import "IRPeerSignature+Proto.h"
#import "IRTransactionImpl+Proto.h"
#import "NSDate+IrohaCommunication.h"
#import <IrohaCrypto/NSData+Hex.h>

@implementation IRBlock (Proto)

+ (nullable id<IRBlock>)blockFromPbBlock:(nonnull Block*)block error:(NSError*_Nullable*_Nullable)error {
    if (!block.blockV1) {
        if (error) {
            *error = [IRBlock errorWithMessage:@"Versioned block expected but nil found."];
        }

        return nil;
    }

    NSMutableArray<id<IRPeerSignature>> * peerSignatures = [NSMutableArray array];

    for (Signature *pbSignature in block.blockV1.signaturesArray) {
        id<IRPeerSignature> peerSignature = [IRPeerSignatureFactory peerSignatureFromPbSignature:pbSignature
                                                                                           error:error];

        if (!peerSignature) {
            return nil;
        }

        [peerSignatures addObject:peerSignature];
    }

    if (!block.blockV1.payload) {
        if (error) {
            *error = [IRBlock errorWithMessage:@"Payload expected but nil found."];
        }

        return nil;
    }

    NSMutableArray<id<IRTransaction>> *transactions = [NSMutableArray array];

    for (Transaction *pbTransaction in block.blockV1.payload.transactionsArray) {
        id<IRTransaction> transaction = [IRTransaction transactionFromPbTransaction:pbTransaction
                                                                              error:error];

        if (!transaction) {
            return nil;
        }

        [transactions addObject:transaction];
    }

    NSDate *createdAt = [NSDate dateWithTimestampInMilliseconds:block.blockV1.payload.createdTime];

    NSMutableArray<NSData*> *rejectedHashes = [NSMutableArray array];

    if (!block.blockV1.payload.rejectedTransactionsHashesArray) {
        if (error) {
            *error = [IRBlock errorWithMessage:@"Expected rejected transaction hashes list but nil found"];
        }
        return nil;
    }

    for (NSString *pbRejectedHash in block.blockV1.payload.rejectedTransactionsHashesArray)  {
        NSData *rejectedHash = [[NSData alloc] initWithHexString:pbRejectedHash];

        if (!rejectedHash) {
            if (error) {
                NSString *message = [NSString stringWithFormat:@"Can't parse rejected hash hex string: %@", pbRejectedHash];
                *error = [IRBlock errorWithMessage:message];
            }
            return nil;
        }

        [rejectedHashes addObject:rejectedHash];
    }

    NSData *previousBlockHash = [[NSData alloc] initWithHexString:block.blockV1.payload.prevBlockHash];

    if (!previousBlockHash) {
        if (error) {
            NSString *message = [NSString stringWithFormat:@"Can't parse previous block hash hex string: %@", block.blockV1.payload.prevBlockHash];
            *error = [IRBlock errorWithMessage:message];
        }
        return nil;
    }

    return [[IRBlock alloc] initWithHeight:block.blockV1.payload.height
                         previousBlockHash:previousBlockHash
                                 createdAt:createdAt
                              transactions:transactions
                 rejectedTransactionHashes:rejectedHashes
                            peerSignatures:peerSignatures];
}

#pragma mark - Helper

+ (nonnull NSError*)errorWithMessage:(NSString*)message {
    return [NSError errorWithDomain:NSStringFromClass([IRBlock class])
                               code:IRBlockProtoErrorInvalidField
                           userInfo:@{NSLocalizedDescriptionKey: message}];
}

@end

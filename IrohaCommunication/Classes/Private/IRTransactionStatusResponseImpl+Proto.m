#import "IRTransactionStatusResponseImpl+Proto.h"
#import "Endpoint.pbobjc.h"
#import <IrohaCrypto/NSData+Hex.h>

@implementation IRTransactionStatusResponse (Proto)

+ (nullable instancetype)statusResponseWithToriiResponse:(nonnull ToriiResponse *)toriiResponse error:(NSError **)error {
    NSData *transactionHash = [[NSData alloc] initWithHexString:toriiResponse.txHash];

    if (!transactionHash) {
        if (error) {
            NSString *message = [NSString stringWithFormat:@"Unexpected hex transaction hash %@", toriiResponse.txHash];
            *error = [NSError errorWithDomain:@"IRTransactionStatusResponseProtoError"
                                         code:IRTransactionStatusResponseProtoErrorInvalidField
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }

        return nil;
    }

    IRTransactionStatus status;

    switch (toriiResponse.txStatus) {
        case TxStatus_StatelessValidationFailed:
            status = IRTransactionStatusStatelessValidationFailed;
            break;
        case TxStatus_StatelessValidationSuccess:
            status = IRTransactionStatusStatelessValidationSuccess;
            break;
        case TxStatus_StatefulValidationFailed:
            status = IRTransactionStatusStatefulValidationFailed;
            break;
        case TxStatus_StatefulValidationSuccess:
            status = IRTransactionStatusStatefulValidationSuccess;
            break;
        case TxStatus_Rejected:
            status = IRTransactionStatusRejected;
            break;
        case TxStatus_Committed:
            status = IRTransactionStatusCommitted;
            break;
        case TxStatus_MstExpired:
            status = IRTransactionStatusMstExpired;
            break;
        case TxStatus_NotReceived:
            status = IRTransactionStatusNotReceived;
            break;
        case TxStatus_MstPending:
            status = IRTransactionStatusMstPending;
            break;
        case TxStatus_EnoughSignaturesCollected:
            status = IRTransactionStatusEnoughSignaturesCollected;
            break;
        default:
            if (error) {
                NSString *message = [NSString stringWithFormat:@"Unexpected proto transaction status %@", @(toriiResponse.txStatus)];
                *error = [NSError errorWithDomain:@"IRTransactionStatusResponseProtoError"
                                             code:IRTransactionStatusResponseProtoErrorInvalidField
                                         userInfo:@{NSLocalizedDescriptionKey: message}];
            }
            return nil;
            break;
    }

    NSString *statusDescription;

    if (toriiResponse.errOrCmdName && toriiResponse.errOrCmdName.length > 0) {
        statusDescription = [NSString stringWithFormat:@"Error: %@; code=%@",
                             toriiResponse.errOrCmdName, @(toriiResponse.errorCode)];
    }

    return [[IRTransactionStatusResponse alloc] initWithStatus:status
                                               transactionHash:transactionHash
                                                   description:statusDescription];
}

- (int32_t)protobufTransactionStatus {
    switch (self.status) {
        case IRTransactionStatusStatelessValidationFailed:
            return TxStatus_StatelessValidationFailed;
            break;
        case IRTransactionStatusStatelessValidationSuccess:
            return TxStatus_StatelessValidationSuccess;
            break;
        case IRTransactionStatusStatefulValidationFailed:
            return TxStatus_StatefulValidationFailed;
            break;
        case IRTransactionStatusStatefulValidationSuccess:
            return TxStatus_StatefulValidationSuccess;
            break;
        case IRTransactionStatusRejected:
            return TxStatus_Rejected;
            break;
        case IRTransactionStatusCommitted:
            return TxStatus_Committed;
            break;
        case IRTransactionStatusMstExpired:
            return TxStatus_MstExpired;
            break;
        case IRTransactionStatusNotReceived:
            return TxStatus_NotReceived;
            break;
        case IRTransactionStatusMstPending:
            return TxStatus_MstPending;
            break;
        case IRTransactionStatusEnoughSignaturesCollected:
            return TxStatus_EnoughSignaturesCollected;
            break;
        default:
            return TxStatus_GPBUnrecognizedEnumeratorValue;
            break;
    }
}

@end

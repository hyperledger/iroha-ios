/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import "IRSerializationFactory.h"
#import "IRTransactionImpl.h"
#import "IRQueryRequestImpl.h"
#import "IRTransactionImpl+Proto.h"
#import "IRQueryResponse+Proto.h"
#import "Transaction.pbobjc.h"
#import "Queries.pbobjc.h"
#import "QryResponses.pbobjc.h"

@implementation IRSerializationFactory

+ (nullable NSData*)serializeTransaction:(nonnull id<IRTransaction>)transaction error:(NSError**)error {
    if (![transaction conformsToProtocol:@protocol(IRProtobufTransformable)]) {

        if (error) {
            NSString *message = @"Unsupported transaction implementation";
            *error = [NSError errorWithDomain:NSStringFromClass([IRSerializationFactory class])
                                         code:IRTransactionErrorSerialization
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }

        return nil;
    }

    Transaction *pbTransaction = [(id<IRProtobufTransformable>)transaction transform:error];

    if (!pbTransaction) {
        return nil;
    }

    return [pbTransaction data];
}

+ (nullable NSData*)serializeQueryRequest:(nonnull id<IRQueryRequest>)queryRequest error:(NSError**)error {
    if (![queryRequest conformsToProtocol:@protocol(IRProtobufTransformable)]) {

        if (error) {
            NSString *message = @"Unsupported query request implementation";
            *error = [NSError errorWithDomain:NSStringFromClass([IRSerializationFactory class])
                                         code:IRQueryRequestErrorSerialization
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }

        return nil;
    }

    Query *protobufQuery = [(id<IRProtobufTransformable>)queryRequest transform:error];

    if (!protobufQuery) {
        return nil;
    }

    return [protobufQuery data];
}

+ (nullable id<IRTransaction>)deserializeTransactionFromData:(nonnull NSData*)data error:(NSError**)error {
    Transaction *transaction = [[Transaction alloc] initWithData:data error:error];

    if (!transaction) {
        return nil;
    }

    return [IRTransaction transactionFromPbTransaction:transaction error:error];
}

+ (nullable id<IRQueryResponse>)deserializeQueryResponseFromData:(nonnull NSData*)data error:(NSError**)error {
    QueryResponse *response = [[QueryResponse alloc] initWithData:data error:error];

    if (!response) {
        return nil;
    }

    return [IRQueryResponseProtoFactory responseFromProtobuf:response error:error];
}

@end

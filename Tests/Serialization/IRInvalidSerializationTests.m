/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

@import XCTest;
@import IrohaCommunication;

@interface IRInvalidSerializationTests : XCTestCase

@end

@implementation IRInvalidSerializationTests

- (void)testInvalidTransactionDeserialization {
    NSError *error = nil;
    NSData *invalidTransactionData = [[NSData alloc] init];
    id<IRTransaction> invalidTransaction = [IRSerializationFactory deserializeTransactionFromData:invalidTransactionData
                                                                                            error:&error];

    XCTAssertNil(invalidTransaction);
    XCTAssertNotNil(error);
}

- (void)testInvalidQueryResponseDeserialization {
    NSError *error = nil;
    NSData *invalidQueryResponseData = [[NSData alloc] init];
    id<IRQueryResponse> invalidQueryResponse = [IRSerializationFactory deserializeQueryResponseFromData:invalidQueryResponseData
                                                                                                  error:&error];

    XCTAssertNil(invalidQueryResponse);
    XCTAssertNotNil(error);
}

@end

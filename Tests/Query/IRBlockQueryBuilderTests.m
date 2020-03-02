/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

@import XCTest;
@import IrohaCommunication;

static NSString * const VALID_ACCOUNT_IDENTIFIER = @"bob@gmail.com";

@interface IRBlockQueryBuilderTests : XCTestCase

@end

@implementation IRBlockQueryBuilderTests

- (void)testMissingAccountId {
    IRBlockQueryBuilder *queryBuilder = [[IRBlockQueryBuilder alloc] init];

    NSError *error = nil;
    id<IRBlockQueryRequest> query = [queryBuilder build:&error];

    XCTAssertNil(query);
    XCTAssertTrue(error && error.code == IRQueryBuilderErrorMissingCreator);
}

- (void)testUnsignedWithCreatedTime {
    id<IRAccountId> accountId = [IRAccountIdFactory accountWithIdentifier:VALID_ACCOUNT_IDENTIFIER
                                                                    error:nil];

    NSDate *createdAt = [NSDate date];
    UInt32 counter = 10;

    NSError *error = nil;
    IRBlockQueryBuilder *queryBuilder = [IRBlockQueryBuilder builderWithCreatorAccountId:accountId];
    queryBuilder = [queryBuilder withCreatedDate:createdAt];
    queryBuilder = [queryBuilder withQueryCounter:counter];

    id<IRBlockQueryRequest> query = [queryBuilder build:&error];

    XCTAssertNil(error);
    XCTAssertNotNil(query);
    XCTAssertNil(query.peerSignature);
    XCTAssertEqualObjects(accountId.identifier, query.creator.identifier);
    XCTAssertEqualObjects(createdAt, query.createdAt);
    XCTAssertEqual(counter, query.queryCounter);
}

- (void)testSignedWithDefaultCreatedTime {
    id<IRAccountId> accountId = [IRAccountIdFactory accountWithIdentifier:VALID_ACCOUNT_IDENTIFIER
                                                                    error:nil];

    NSError *error = nil;
    IRBlockQueryBuilder *queryBuilder = [IRBlockQueryBuilder builderWithCreatorAccountId:accountId];

    id<IRBlockQueryRequest> query = [queryBuilder build:&error];

    XCTAssertNil(error);
    XCTAssertNotNil(query);
    XCTAssertNil(query.peerSignature);
    XCTAssertEqualObjects(accountId.identifier, query.creator.identifier);

    error = nil;

    id<IRCryptoKeypairProtocol> keypair = [[[IRIrohaKeyFactory alloc] init] createRandomKeypair:&error];

    XCTAssertNil(error);

    error = nil;

    id<IRSignatureCreatorProtocol> signer = [[IRIrohaSigner alloc] initWithPrivateKey:keypair.privateKey];

    id<IRBlockQueryRequest> signedQuery = [query signedWithSignatory:signer
                                                  signatoryPublicKey:keypair.publicKey
                                                               error:&error];

    XCTAssertNotNil(signedQuery);
    XCTAssertNil(error);
}

@end

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

    id<IRCryptoKeypairProtocol> keypair = [[[IREd25519KeyFactory alloc] init] createRandomKeypair];
    id<IRSignatureCreatorProtocol> signer = [[IREd25519Sha512Signer alloc] initWithPrivateKey:keypair.privateKey];

    error = nil;
    id<IRBlockQueryRequest> signedQuery = [query signedWithSignatory:signer
                                                  signatoryPublicKey:keypair.publicKey
                                                               error:&error];

    XCTAssertNotNil(signedQuery);
    XCTAssertNil(error);
}

@end

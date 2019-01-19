@import XCTest;
@import IrohaCommunication;

static const NSUInteger VALID_ACCOUNT_NAMES_COUNT = 5;
static NSString* const VALID_ACCOUNT_NAMES[] = {
    @"bob",
    @"123",
    @"bob123bob123bob123bob123bob__123",
    @"1",
    @"b"
};

static const NSUInteger INVALID_ACCOUNT_NAMES_COUNT = 5;
static NSString* const INVALID_ACCOUNT_NAMES[] = {
    @"",
    @"-",
    @"bOb",
    @"bob@gmail.com",
    @"bOb123bOb123bOb123bOb123bOb123ALEX"
};

static const NSUInteger INVALID_ACCOUNT_IDENTIFIERS_COUNT = 4;
static NSString* const INVALID_ACCOUNT_IDENTIFIERS[] = {
    @"",
    @"-",
    @"bOb@gmail.com",
    @"bOb123bOb123bOb123bOb123bOb123ALEX"
};

static NSString * const VALID_DOMAIN = @"gmail.com";

@interface IRAccountIdTests : XCTestCase

@end

@implementation IRAccountIdTests

- (void)testValidAccountNames {
    for (NSUInteger i = 0; i < VALID_ACCOUNT_NAMES_COUNT; i++) {
        id<IRAccountId> accountId = [IRAccountIdFactory
                                     accountIdWithName:VALID_ACCOUNT_NAMES[i]
                                     domain:[IRDomainFactory domainWithIdentitifer:VALID_DOMAIN error:nil]
                                     error:nil];
        XCTAssertNotNil(accountId);
        XCTAssertEqualObjects(accountId.name, VALID_ACCOUNT_NAMES[i]);
        XCTAssertEqualObjects(accountId.domain.identifier, VALID_DOMAIN);
    }
}

- (void)testInvalidAccountNamesWithError {
    for (NSUInteger i = 0; i < INVALID_ACCOUNT_NAMES_COUNT; i++) {
        NSError *error;
        id<IRAccountId> accountId = [IRAccountIdFactory accountIdWithName:INVALID_ACCOUNT_NAMES[i]
                                                                   domain:[IRDomainFactory domainWithIdentitifer:VALID_DOMAIN error:nil]
                                                                    error:&error];
        XCTAssertNil(accountId);
        XCTAssertNotNil(error);
        XCTAssertEqual(error.code, IRInvalidAccountName);
    }
}

- (void)testInvalidAccountNamesWithoutError {
    for (NSUInteger i = 0; i < INVALID_ACCOUNT_NAMES_COUNT; i++) {
        id<IRAccountId> accountId = [IRAccountIdFactory accountIdWithName:INVALID_ACCOUNT_NAMES[i]
                                                                   domain:[IRDomainFactory domainWithIdentitifer:VALID_DOMAIN error:nil]
                                                                    error:nil];
        XCTAssertNil(accountId);
    }
}

- (void)testValidIdentifier {
    for (NSUInteger i = 0; i < VALID_ACCOUNT_NAMES_COUNT; i++) {
        NSString *identifier = [NSString stringWithFormat:@"%@@%@", VALID_ACCOUNT_NAMES[i], VALID_DOMAIN];
        id<IRAccountId> accountId = [IRAccountIdFactory accountWithIdentifier:identifier
                                                                        error:nil];
        XCTAssertNotNil(accountId);
        XCTAssertEqualObjects(accountId.identifier, identifier);
    }
}

- (void)testInvalidAccountIdentifierWithError {
    for (NSUInteger i = 0; i < INVALID_ACCOUNT_IDENTIFIERS_COUNT; i++) {
        NSError *error;
        id<IRAccountId> accountId = [IRAccountIdFactory accountWithIdentifier:INVALID_ACCOUNT_IDENTIFIERS[i]
                                                                        error:&error];
        XCTAssertNil(accountId);
        XCTAssertNotNil(error);
    }
}

@end


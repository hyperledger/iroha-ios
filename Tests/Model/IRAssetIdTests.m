@import XCTest;
@import IrohaCommunication;

static const NSUInteger VALID_ASSET_NAMES_COUNT = 5;
static NSString* const VALID_ASSET_NAMES[] = {
    @"bob",
    @"123",
    @"bob123bob123bob123bob123bob__123",
    @"1",
    @"b"
};

static const NSUInteger INVALID_ASSET_NAMES_COUNT = 5;
static NSString* const INVALID_ASSET_NAMES[] = {
    @"",
    @"-",
    @"bOb",
    @"bob@gmail.com",
    @"bOb123bOb123bOb123bOb123bOb123ALEX"
};

static const NSUInteger INVALID_ASSET_IDENTIFIERS_COUNT = 4;
static NSString* const INVALID_ASSET_IDENTIFIERS[] = {
    @"",
    @"-",
    @"bOb@gmail.com",
    @"bOb123bOb123bOb123bOb123bOb123ALEX"
};

static NSString * const VALID_DOMAIN = @"gmail.com";

@interface IRAssetIdTests : XCTestCase

@end

@implementation IRAssetIdTests

- (void)testValidAssetNames {
    for (NSUInteger i = 0; i < VALID_ASSET_NAMES_COUNT; i++) {
        id<IRAssetId> assetId = [IRAssetIdFactory assetIdWithName:VALID_ASSET_NAMES[i]
                                                             domain:[IRDomainFactory domainWithIdentitifer:VALID_DOMAIN error:nil]
                                                              error:nil];
        XCTAssertNotNil(assetId);
        XCTAssertEqualObjects(assetId.name, VALID_ASSET_NAMES[i]);
        XCTAssertEqualObjects(assetId.domain.identifier, VALID_DOMAIN);
    }
}

- (void)testInvalidAssetNamesWithError {
    for (NSUInteger i = 0; i < INVALID_ASSET_NAMES_COUNT; i++) {
        NSError *error;
        id<IRAssetId> assetId = [IRAssetIdFactory assetIdWithName:INVALID_ASSET_NAMES[i]
                                                           domain:[IRDomainFactory domainWithIdentitifer:VALID_DOMAIN error:nil]
                                                            error:&error];
        XCTAssertNil(assetId);
        XCTAssertNotNil(error);
        XCTAssertEqual(error.code, IRInvalidAccountName);
    }
}

- (void)testInvalidAssetNamesWithoutError {
    for (NSUInteger i = 0; i < INVALID_ASSET_NAMES_COUNT; i++) {
        id<IRAssetId> assetId = [IRAssetIdFactory assetIdWithName:INVALID_ASSET_NAMES[i]
                                                           domain:[IRDomainFactory domainWithIdentitifer:VALID_DOMAIN error:nil]
                                                            error:nil];
        XCTAssertNil(assetId);
    }
}

- (void)testValidIdentifier {
    for (NSUInteger i = 0; i < VALID_ASSET_NAMES_COUNT; i++) {
        NSString *identifier = [NSString stringWithFormat:@"%@#%@", VALID_ASSET_NAMES[i], VALID_DOMAIN];
        id<IRAssetId> assetId = [IRAssetIdFactory assetWithIdentifier:identifier
                                                                error:nil];
        XCTAssertNotNil(assetId);
        XCTAssertEqualObjects(assetId.identifier, identifier);
    }
}

- (void)testInvalidAssetIdentifierWithError {
    for (NSUInteger i = 0; i < INVALID_ASSET_IDENTIFIERS_COUNT; i++) {
        NSError *error;
        id<IRAssetId> assetId = [IRAssetIdFactory assetWithIdentifier:INVALID_ASSET_IDENTIFIERS[i]
                                                                error:&error];
        XCTAssertNil(assetId);
        XCTAssertNotNil(error);
    }
}

- (void)testInvalidAssetIdentifierWithoutError {
    for (NSUInteger i = 0; i < INVALID_ASSET_IDENTIFIERS_COUNT; i++) {
        id<IRAssetId> assetId = [IRAssetIdFactory assetWithIdentifier:INVALID_ASSET_IDENTIFIERS[i]
                                                                error:nil];
        XCTAssertNil(assetId);
    }
}

@end

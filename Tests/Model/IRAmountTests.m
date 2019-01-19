@import XCTest;
@import IrohaCommunication;

static const NSUInteger VALID_STRING_AMOUNT_COUNT = 4;
static NSString * const VALID_STRING_AMOUNT[] = {
    @"0.001",
    @"10",
    @"123456.789",
    @"0.1234"
};

static const NSUInteger INVALID_STRING_AMOUNT_COUNT = 4;
static NSString * const INVALID_STRING_AMOUNT[] = {
    @"",
    @"-10.21",
    @"1,0789",
    @"89a789"
};

@interface IRAmountTests : XCTestCase

@end

@implementation IRAmountTests

- (void)testValidStringAmount {
    for (NSUInteger i = 0; i < VALID_STRING_AMOUNT_COUNT; i++) {
        id<IRAmount> amount = [IRAmountFactory amountFromString:VALID_STRING_AMOUNT[i]
                                                          error:nil];

        XCTAssertNotNil(amount);
        XCTAssertEqualObjects(amount.value, VALID_STRING_AMOUNT[i]);
    }
}

- (void)testInvalidStringAmountWithError {
    for (NSUInteger i = 0; i < INVALID_STRING_AMOUNT_COUNT; i++) {
        NSError *error;
        id<IRAmount> amount = [IRAmountFactory amountFromString:INVALID_STRING_AMOUNT[i]
                                                          error:&error];

        XCTAssertNil(amount);
        XCTAssertNotNil(error);
        XCTAssertEqual(error.code, IRInvalidAmountValue);
    }
}

- (void)testInvalidStringAmountWithoutError {
    for (NSUInteger i = 0; i < INVALID_STRING_AMOUNT_COUNT; i++) {
        id<IRAmount> amount = [IRAmountFactory amountFromString:INVALID_STRING_AMOUNT[i]
                                                          error:nil];

        XCTAssertNil(amount);
    }
}

- (void)testValidIntAmount {
    for (NSUInteger i = 1e3; i < 1e5; i += 1e4) {
        NSError *error = nil;
        id<IRAmount> amount = [IRAmountFactory amountFromUnsignedInteger:i
                                                                   error:&error];

        XCTAssertNotNil(amount);
        XCTAssertNil(error);
    }
}

@end

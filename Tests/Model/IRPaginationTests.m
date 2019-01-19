@import XCTest;
@import IrohaCommunication;

@interface IRPaginationTests : XCTestCase

@end

@implementation IRPaginationTests

- (void)testValidPagination {
    NSData *itemHash = [[@"Test Hash" dataUsingEncoding:NSUTF8StringEncoding] sha3:IRSha3Variant256];
    UInt32 pageSize = 10;

    NSError *error = nil;
    id<IRPagination> pagination = [IRPaginationFactory pagination:pageSize
                                                    firstItemHash:itemHash
                                                            error:&error];

    XCTAssertNil(error);
    XCTAssertEqual(pagination.pageSize, pageSize);
    XCTAssertEqualObjects(pagination.firstItemHash, itemHash);
}

- (void)testNilItemHashPagination {
    UInt32 pageSize = 10;

    NSError *error = nil;
    id<IRPagination> pagination = [IRPaginationFactory pagination:pageSize
                                                    firstItemHash:nil
                                                            error:&error];

    XCTAssertNil(error);
    XCTAssertEqual(pagination.pageSize, pageSize);
}

- (void)testInvalidPagination {
    NSData *itemHash = [@"Test Hash" dataUsingEncoding:NSUTF8StringEncoding];
    UInt32 pageSize = 10;

    NSError *error = nil;
    id<IRPagination> pagination = [IRPaginationFactory pagination:pageSize
                                                    firstItemHash:itemHash
                                                            error:&error];

    XCTAssertNil(pagination);
    XCTAssertTrue(error != nil && error.code == IRPaginationFactoryErrorInvalidHash);
}

@end

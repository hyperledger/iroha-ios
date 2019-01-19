@import XCTest;
@import IrohaCommunication;

static const NSUInteger VALID_ROLE_NAMES_COUNT = 6;
static NSString* const VALID_ROLE_NAMES[] = {
    @"test",
    @"admin",
    @"admin_test",
    @"1",
    @"t",
    @"abcdefghklmnopqrstuwxyz_1234589"
};

static const NSUInteger INVALID_ROLE_NAMES_COUNT = 6;
static NSString* const INVALID_ROLE_NAMES[] = {
    @"",
    @"a@dmin",
    @"admin-test",
    @"12321Asdsd",
    @"T",
    @"abcdefghklmnopqrstuwxyz_1234589asdsad"
};

@interface IRRoleNameTests : XCTestCase

@end

@implementation IRRoleNameTests

- (void)testValidRoleNames {
    for (NSUInteger i = 0; i < VALID_ROLE_NAMES_COUNT; i++) {
        id<IRRoleName> roleName = [IRRoleNameFactory roleWithName:VALID_ROLE_NAMES[i]
                                                            error:nil];
        XCTAssertNotNil(roleName);
        XCTAssertEqualObjects(roleName.value, VALID_ROLE_NAMES[i]);
    }
}

- (void)testInvalidRoleNamesWithError {
    for (NSUInteger i = 0; i < INVALID_ROLE_NAMES_COUNT; i++) {
        NSError *error;
        id<IRRoleName> roleName = [IRRoleNameFactory roleWithName:INVALID_ROLE_NAMES[i]
                                                            error:&error];
        XCTAssertNil(roleName);
        XCTAssertNotNil(error);
        XCTAssertEqual(error.code, IRInvalidRoleName);
    }
}

- (void)testInvalidRoleNamesWithoutError {
    for (NSUInteger i = 0; i < INVALID_ROLE_NAMES_COUNT; i++) {
        id<IRRoleName> roleName = [IRRoleNameFactory roleWithName:INVALID_ROLE_NAMES[i]
                                                            error:nil];
        XCTAssertNil(roleName);
    }
}

@end

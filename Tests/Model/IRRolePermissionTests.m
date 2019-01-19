@import XCTest;
@import IrohaCommunication;

@interface IRRolePermissionTests : XCTestCase

@end

@implementation IRRolePermissionTests

- (void)testValidRolePermission {
    for (int i = 1; i < 40; i++) {
        id<IRRolePermission> permission = [IRRolePermissionFactory permissionWithValue:i
                                                                                 error:nil];
        XCTAssertNotNil(permission);
        XCTAssertEqual(permission.value, i);
    }
}

- (void)testInvalidRolPermissionWithError {
    for (int i = 50; i < 60; i++) {
        NSError *error;
        id<IRRolePermission> permission = [IRRolePermissionFactory permissionWithValue:i
                                                                                 error:&error];
        XCTAssertNil(permission);
        XCTAssertNotNil(error);
        XCTAssertEqual(error.code, IRInvalidRolePermissionValue);
    }
}

- (void)testInvalidRolePermissionWithoutError {
    for (int i = 50; i < 60; i++) {
        id<IRRolePermission> permission = [IRRolePermissionFactory permissionWithValue:i
                                                                                 error:nil];
        XCTAssertNil(permission);
    }
}

@end

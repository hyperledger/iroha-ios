@import XCTest;
#import "IRBaseIrohaContainerTests.h"

@interface IRCreateRoleTest : IRBaseIrohaContainerTests

@end

@implementation IRCreateRoleTest

- (void)testCreateRole {
    NSError *error = nil;
    id<IRRoleName> role = [IRRoleNameFactory roleWithName:@"superadmintest" error:&error];

    if (error) {
        XCTFail();
        return;
    }

    NSArray<id<IRRolePermission>>* permissions = @[[IRRolePermissionFactory canAddSignatory],
                                                   [IRRolePermissionFactory canRemoveSignatory],
                                                   [IRRolePermissionFactory canSetQuorum]];

    IRTransactionBuilder *transactionBuilder = [IRTransactionBuilder builderWithCreatorAccountId:self.adminAccountId];
    transactionBuilder = [transactionBuilder createRole:role permissions:permissions];
    id<IRTransaction> transaction = [[transactionBuilder build:&error] signedWithSignatories:@[self.adminSigner]
                                                                         signatoryPublicKeys:@[self.adminPublicKey]
                                                                                       error:&error];

    if (error) {
        XCTFail();
        return;
    }

    XCTestExpectation *expectation = [[XCTestExpectation alloc] init];

    [self.iroha executeTransaction:transaction].onThen(^IRPromise* _Nullable (id result) {
        return [self.iroha onTransactionStatus:IRTransactionStatusCommitted withHash:result];
    }).onThen(^IRPromise* _Nullable (id result) {
        [expectation fulfill];

        IRQueryBuilder *builder = [IRQueryBuilder builderWithCreatorAccountId:self.adminAccountId];
        builder = [builder getRolePermissions:[IRRoleNameFactory roleWithName:@"admin" error:nil]];
        id<IRQueryRequest> request = [[builder build:nil] signedWithSignatory:self.adminSigner
                                                           signatoryPublicKey:self.adminPublicKey
                                                                        error:nil];

        return [self.iroha executeQueryRequest:request];
    }).onThen(^IRPromise* _Nullable (id result) {
        IRQueryBuilder *builder = [IRQueryBuilder builderWithCreatorAccountId:self.adminAccountId];
        builder = [builder getRolePermissions:role];

        NSError *error = nil;
        id<IRQueryRequest> request = [[builder build:&error] signedWithSignatory:self.adminSigner
                                                           signatoryPublicKey:self.adminPublicKey
                                                                        error:&error];

        if (error) {
            XCTFail();
            return [IRPromise promiseWithResult:error];
        }

        return [self.iroha executeQueryRequest:request];
    }).onThen(^IRPromise* _Nullable (id result) {

        XCTAssertNotNil(result);

        [expectation fulfill];

        return nil;
    }).onError(^IRPromise* _Nullable (NSError* error) {
        XCTFail();
        NSLog(@"%@",error);

        return nil;
    });

    [self waitForExpectations:@[expectation] timeout:60.0];
}

@end

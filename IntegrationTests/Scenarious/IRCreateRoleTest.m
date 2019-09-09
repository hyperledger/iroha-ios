/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

@import XCTest;
#import "IRBaseIrohaContainerTests.h"

@interface IRCreateRoleTest : IRBaseIrohaContainerTests

@end

@implementation IRCreateRoleTest

- (void)testCreateRoleRejected {
    NSError *error = nil;
    id<IRRoleName> role = [IRRoleNameFactory roleWithName:@"superadmcdddintest" error:&error];

    if (error) {
        XCTFail();
        return;
    }

    NSArray<id<IRRolePermission>>* permissions = @[
                                                   [IRRolePermissionFactory canAddSignatory],
                                                   [IRRolePermissionFactory canRemoveSignatory],
//                                                   [IRRolePermissionFactory canSetQuorum]
                                                   ];

    IRTransactionBuilder *transactionBuilder = [IRTransactionBuilder builderWithCreatorAccountId:self.adminAccountId];
    transactionBuilder = [transactionBuilder createRole:role permissions:permissions];
    id<IRTransaction> transaction = [[transactionBuilder build:&error] signedWithSignatories:@[self.adminSigner]
                                                                         signatoryPublicKeys:@[self.adminPublicKey]
                                                                                       error:&error];

    if (error) {
        XCTFail();
        return;
    }
    
    NSLog(@"%@", [[transaction transactionHashWithError:nil] toHexString]);

    XCTestExpectation *expectation = [[XCTestExpectation alloc] init];

    [self.iroha executeTransaction:transaction].onThen(^IRPromise* _Nullable (id result) {
        return [IRRepeatableStatusStream onTransactionStatus:IRTransactionStatusRejected
                                                    withHash:result
                                                        from:self.iroha];
    }).onThen(^IRPromise* _Nullable (id result) {
        [expectation fulfill];

        IRQueryBuilder *builder = [IRQueryBuilder builderWithCreatorAccountId:self.adminAccountId];
        builder = [builder getRolePermissions:[IRRoleNameFactory roleWithName:@"admin" error:nil]];
        id<IRQueryRequest> request = [[builder build:nil] signedWithSignatory:self.adminSigner
                                                           signatoryPublicKey:self.adminPublicKey
                                                                        error:nil];

        return [self.iroha executeQueryRequest:request];
    }).onThen(^IRPromise* _Nullable (id result) {

        XCTAssertNotNil(result);

        [expectation fulfill];

        return nil;
    }).onError(^IRPromise* _Nullable (NSError * error) {
        XCTFail();
        NSLog(@"%@",error);

        [expectation fulfill];

        return nil;
    });

    [self waitForExpectations:@[expectation] timeout:120.0];
}

@end

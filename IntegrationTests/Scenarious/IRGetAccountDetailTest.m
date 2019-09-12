/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <XCTest/XCTest.h>
#import "IRBaseIrohaContainerTests.h"


@interface IRGetAccountDetailTest : IRBaseIrohaContainerTests
@end


@implementation IRGetAccountDetailTest

- (void)testGetAccountDetailInSeveralPages {
    NSString *firstDetailKey = @"key";
    NSString *firstDetailValue = @"value";
    
    NSString *secondDetailKey = @"otherkey";
    NSString *secondDetailValue = @"othervalue";

    IRTransactionBuilder *transactionBuilder = [IRTransactionBuilder builderWithCreatorAccountId:self.adminAccountId];
    transactionBuilder = [transactionBuilder setAccountDetail:self.adminAccountId key:firstDetailKey
                                                        value:firstDetailValue];
    transactionBuilder = [transactionBuilder setAccountDetail:self.adminAccountId key:secondDetailKey
                                                        value:secondDetailValue];

    NSError *error = nil;
    id<IRTransaction> transaction = [[transactionBuilder build:&error] signedWithSignatories:@[self.adminSigner]
                                                                         signatoryPublicKeys:@[self.adminPublicKey]
                                                                                       error:&error];

    if (!transaction) {
        XCTFail();
        return;
    }
    
    XCTestExpectation *expectation = [[XCTestExpectation alloc] init];
    
    [self.iroha executeTransaction:transaction].onThen(^IRPromise * _Nullable(id result) {
        return [IRRepeatableStatusStream onTransactionStatus:IRTransactionStatusCommitted
                                                    withHash:result
                                                        from:self.iroha];
    }).onThen(^IRPromise * _Nullable(id result) {
        IRQueryBuilder *queryBuilder = [IRQueryBuilder builderWithCreatorAccountId:self.adminAccountId];
        queryBuilder = [queryBuilder getAccountDetail:self.adminAccountId
                                               writer:[self.adminAccountId identifier]
                                                  key:firstDetailKey];
        
        NSError *queryError = nil;
        id<IRQueryRequest> queryRequest = [[queryBuilder build:&queryError] signedWithSignatory:self.adminSigner
                                                                             signatoryPublicKey:self.adminPublicKey
                                                                                          error:&queryError];
        
        return [self.iroha executeQueryRequest:queryRequest];
    }).onThen(^IRPromise * _Nullable(id result) {
        NSLog(@"%@", result);
        if (![result conformsToProtocol:@protocol(IRAccountDetailResponse)]) {
            XCTFail();
        } else {
            id<IRAccountDetailResponse> detailResponse = result;
            
            XCTAssertEqual(detailResponse.totalCount, 2);
            XCTAssertNotNil(detailResponse.nextRecordId);
        }
        
        [expectation fulfill];
        
        return nil;
    }).onError(^IRPromise * _Nullable(NSError * error) {
        XCTFail();
        NSLog(@"%@",error);
        
        [expectation fulfill];
        
        return nil;
    });
    
    [self waitForExpectations:@[expectation] timeout:120.0];
}


@end

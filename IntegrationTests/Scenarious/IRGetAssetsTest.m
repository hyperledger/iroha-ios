/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <XCTest/XCTest.h>
#import "IRBaseIrohaContainerTests.h"


@interface IRGetAssetsTest : IRBaseIrohaContainerTests
@end


@implementation IRGetAssetsTest

- (void)testGetAssetsInSinglePage {
    NSError *error = nil;
    id<IRAssetId> assetId = [IRAssetIdFactory assetIdWithName:@"dummycoin"
                                                       domain:self.domain
                                                        error:&error];
    
    if (error) {
        XCTFail();
        return;
    }
    
    UInt32 assetPrecision = 2;
    IRTransactionBuilder *assetTransactionBuilder = [IRTransactionBuilder
                                                     builderWithCreatorAccountId:self.adminAccountId];
    assetTransactionBuilder = [assetTransactionBuilder createAsset:assetId precision:assetPrecision];
    
    id<IRTransaction> assetTransaction = [[assetTransactionBuilder build:&error]
                                          signedWithSignatories:@[self.adminSigner]
                                          signatoryPublicKeys:@[self.adminPublicKey]
                                          error:&error];
    
    id<IRAmount> addAmount = [IRAmountFactory amountFromUnsignedInteger:200 error:&error];
    
    if (error) {
        XCTFail();
        return;
    }
    
    XCTestExpectation *expectation = [XCTestExpectation new];
    
    [self.iroha executeTransaction:assetTransaction].onThen(^IRPromise * _Nullable (id result) {
        return [IRRepeatableStatusStream onTransactionStatus:IRTransactionStatusCommitted
                                                    withHash:result
                                                        from:self.iroha];
    }).onThen(^IRPromise * _Nullable (id result) {
        IRTransactionBuilder *transactionBuilder = [IRTransactionBuilder builderWithCreatorAccountId:self.adminAccountId];
        transactionBuilder = [transactionBuilder addAssetQuantity:assetId
                                                           amount:addAmount];
        
        NSError *error = nil;
        id<IRTransaction> transaction = [[transactionBuilder build:&error]
                                         signedWithSignatories:@[self.adminSigner]
                                         signatoryPublicKeys:@[self.adminPublicKey] error:&error];
        
        if (error) {
            return [IRPromise promiseWithResult:error];
        }
        
        return [self.iroha executeTransaction:transaction];
    }).onThen(^IRPromise * _Nullable (id result) {
        return [IRRepeatableStatusStream onTransactionStatus:IRTransactionStatusCommitted
                                                    withHash:result
                                                        from:self.iroha];
    }).onThen(^IRPromise * _Nullable (id result) {
        IRQueryBuilder *queryBuilder = [IRQueryBuilder builderWithCreatorAccountId:self.adminAccountId];
        id<IRAssetPagination> pagination = [IRAssetPaginationFactory assetPagination:1 startingAssetId:assetId];
        queryBuilder = [queryBuilder getAccountAssets:self.adminAccountId pagination:pagination];
        
        NSError *error = nil;
        id<IRQueryRequest> request = [[queryBuilder build:&error] signedWithSignatory:self.adminSigner
                                                                   signatoryPublicKey:self.adminPublicKey
                                                                                error:&error];
        
        if (error) {
            return [IRPromise promiseWithResult:error];
        }
        
        return [self.iroha executeQueryRequest:request];
    }).onThen(^IRPromise * _Nullable (id result) {
        NSLog(@"%@", result);
        if ([result conformsToProtocol:@protocol(IRAccountAssetsResponse)]) {
            id<IRAccountAssetsResponse> assetsResponse = result;
            
            id<IRAccountAsset> asset = [assetsResponse.accountAssets firstObject];
            
            XCTAssertEqual(assetsResponse.totalCount, 1);
            XCTAssertNil(assetsResponse.nextAssetId);
            XCTAssertEqualObjects(asset.assetId.identifier, assetId.identifier);
        
            return [IRPromise promiseWithResult:nil];
        } else {
            NSString *message = [NSString stringWithFormat:@"Invalid get assets response %@", NSStringFromClass([result class])];
            NSError *error = [NSError errorWithDomain:@"co.jp.getassetstest"
                                                 code:0
                                             userInfo:@{NSLocalizedDescriptionKey: message}];
            
            return [IRPromise promiseWithResult:error];
        }
    }).onThen(^IRPromise * _Nullable (id result) {
        NSLog(@"%@", result);
        
        [expectation fulfill];
        
        return nil;
    }).onError(^IRPromise * _Nullable (NSError *error) {
        XCTFail();
        NSLog(@"%@", error);
        
        [expectation fulfill];
        return nil;
    });
    
    [self waitForExpectations:@[expectation] timeout:120.0];
}

- (void)testGetAssetsInSeveralPages {
    NSError *error = nil;
    id<IRAssetId> firstAssetId = [IRAssetIdFactory assetIdWithName:@"dummycoin"
                                                       domain:self.domain
                                                        error:&error];
    
    if (error) {
        XCTFail();
        return;
    }
    
    id<IRAssetId> secondAssetId = [IRAssetIdFactory assetIdWithName:@"gummycoin"
                                                             domain:self.domain
                                                              error:&error];
    
    if (error) {
        XCTFail();
        return;
    }
    
    UInt32 assetPrecision = 2;
    IRTransactionBuilder *assetTransactionBuilder = [IRTransactionBuilder
                                                     builderWithCreatorAccountId:self.adminAccountId];
    assetTransactionBuilder = [assetTransactionBuilder createAsset:firstAssetId precision:assetPrecision];
    
    id<IRTransaction> assetTransaction = [[assetTransactionBuilder build:&error]
                                          signedWithSignatories:@[self.adminSigner]
                                          signatoryPublicKeys:@[self.adminPublicKey]
                                          error:&error];
    
    id<IRAmount> addAmount = [IRAmountFactory amountFromUnsignedInteger:200 error:&error];
    
    if (error) {
        XCTFail();
        return;
    }
    
    XCTestExpectation *expectation = [XCTestExpectation new];
    
    [self.iroha executeTransaction:assetTransaction].onThen(^IRPromise * _Nullable (id result) {
        return [IRRepeatableStatusStream onTransactionStatus:IRTransactionStatusCommitted
                                                    withHash:result
                                                        from:self.iroha];
    }).onThen(^IRPromise * _Nullable (id result) {
        IRTransactionBuilder *transactionBuilder = [IRTransactionBuilder builderWithCreatorAccountId:self.adminAccountId];
        transactionBuilder = [transactionBuilder addAssetQuantity:firstAssetId
                                                           amount:addAmount];
        
        NSError *error = nil;
        id<IRTransaction> transaction = [[transactionBuilder build:&error]
                                         signedWithSignatories:@[self.adminSigner]
                                         signatoryPublicKeys:@[self.adminPublicKey] error:&error];
        
        if (error) {
            return [IRPromise promiseWithResult:error];
        }
        
        return [self.iroha executeTransaction:transaction];
    }).onThen(^IRPromise * _Nullable (id result) {
        return [IRRepeatableStatusStream onTransactionStatus:IRTransactionStatusCommitted
                                                    withHash:result
                                                        from:self.iroha];
    }).onThen(^IRPromise * _Nullable (id result) {
        IRTransactionBuilder *transactionBuilder = [IRTransactionBuilder builderWithCreatorAccountId:self.adminAccountId];
        transactionBuilder = [transactionBuilder createAsset:secondAssetId precision:assetPrecision];
        
        NSError *error = nil;
        id<IRTransaction> transaction = [[transactionBuilder build:&error]
                                         signedWithSignatories:@[self.adminSigner]
                                         signatoryPublicKeys:@[self.adminPublicKey] error:&error];
        
        if (error) {
            return [IRPromise promiseWithResult:error];
        }
        
        return [self.iroha executeTransaction:transaction];
    }).onThen(^IRPromise * _Nullable (id result) {
        return [IRRepeatableStatusStream onTransactionStatus:IRTransactionStatusCommitted
                                                    withHash:result
                                                        from:self.iroha];
    }).onThen(^IRPromise * _Nullable (id result) {
        IRTransactionBuilder *transactionBuilder = [IRTransactionBuilder builderWithCreatorAccountId:self.adminAccountId];
        transactionBuilder = [transactionBuilder addAssetQuantity:secondAssetId
                                                           amount:addAmount];
        
        NSError *error = nil;
        id<IRTransaction> transaction = [[transactionBuilder build:&error]
                                         signedWithSignatories:@[self.adminSigner]
                                         signatoryPublicKeys:@[self.adminPublicKey] error:&error];
        
        if (error) {
            return [IRPromise promiseWithResult:error];
        }
        
        return [self.iroha executeTransaction:transaction];
    }).onThen(^IRPromise * _Nullable (id result) {
        return [IRRepeatableStatusStream onTransactionStatus:IRTransactionStatusCommitted
                                                    withHash:result
                                                        from:self.iroha];
    }).onThen(^IRPromise * _Nullable (id result) {
        IRQueryBuilder *queryBuilder = [IRQueryBuilder builderWithCreatorAccountId:self.adminAccountId];
        id<IRAssetPagination> pagination = [IRAssetPaginationFactory assetPagination:1 startingAssetId:firstAssetId];
        queryBuilder = [queryBuilder getAccountAssets:self.adminAccountId pagination:pagination];
        
        NSError *error = nil;
        id<IRQueryRequest> request = [[queryBuilder build:&error] signedWithSignatory:self.adminSigner
                                                                   signatoryPublicKey:self.adminPublicKey
                                                                                error:&error];
        
        if (error) {
            return [IRPromise promiseWithResult:error];
        }
        
        return [self.iroha executeQueryRequest:request];
    }).onThen(^IRPromise * _Nullable (id result) {
        NSLog(@"%@", result);
        if ([result conformsToProtocol:@protocol(IRAccountAssetsResponse)]) {
            id<IRAccountAssetsResponse> assetsResponse = result;
            
            id<IRAccountAsset> firstAsset = [assetsResponse.accountAssets firstObject];
            
            XCTAssertEqual(assetsResponse.totalCount, 2);
            XCTAssertEqualObjects(assetsResponse.nextAssetId.identifier, secondAssetId.identifier);
            XCTAssertEqualObjects(firstAsset.assetId.identifier, firstAssetId.identifier);
            
            return [IRPromise promiseWithResult:nil];
        } else {
            NSString *message = [NSString stringWithFormat:@"Invalid get assets response %@", NSStringFromClass([result class])];
            NSError *error = [NSError errorWithDomain:@"co.jp.getassetstest"
                                                 code:0
                                             userInfo:@{NSLocalizedDescriptionKey: message}];
            
            return [IRPromise promiseWithResult:error];
        }
    }).onThen(^IRPromise * _Nullable (id result) {
        NSLog(@"%@", result);
        
        [expectation fulfill];
        
        return nil;
    }).onError(^IRPromise * _Nullable (NSError *error) {
        XCTFail();
        NSLog(@"%@", error);
        
        [expectation fulfill];
        return nil;
    });
    
    [self waitForExpectations:@[expectation] timeout:120.0];
}

@end

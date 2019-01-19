@import XCTest;
#import "IRBaseIrohaContainerTests.h"

@interface IRCreateAssetTest : IRBaseIrohaContainerTests

@end

@implementation IRCreateAssetTest

- (void)testCreateAddSubtractQueryAsset {
    NSError *error = nil;
    id<IRAssetId> assetId = [IRAssetIdFactory assetIdWithName:@"dummycoin"
                                                       domain:self.domain
                                                        error:&error];

    if (error) {
        XCTFail();
        return;
    }

    UInt32 assetPrecision = 2;
    IRTransactionBuilder *assetTransactionBuilder = [IRTransactionBuilder builderWithCreatorAccountId:self.adminAccountId];
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

    XCTestExpectation *expectation = [[XCTestExpectation alloc] init];

    [self.iroha executeTransaction:assetTransaction].onThen(^IRPromise * _Nullable (id result) {
        return [self.iroha onTransactionStatus:IRTransactionStatusCommitted withHash:(NSData*)result];
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
        return [self.iroha onTransactionStatus:IRTransactionStatusCommitted withHash:(NSData*)result];
    }).onThen(^IRPromise * _Nullable (id result) {
        IRQueryBuilder *queryBuilder = [IRQueryBuilder builderWithCreatorAccountId:self.adminAccountId];
        queryBuilder = [queryBuilder getAccountAssets:self.adminAccountId];

        NSError *error = nil;
        id<IRQueryRequest> request = [[queryBuilder build:&error] signedWithSignatory:self.adminSigner
                                                                   signatoryPublicKey:self.adminPublicKey
                                                                                error:&error];

        if (error) {
            return [IRPromise promiseWithResult:error];
        }

        return [self.iroha executeQueryRequest:request];
    }).onThen(^IRPromise * _Nullable (id result) {
        if ([result conformsToProtocol:@protocol(IRAccountAssetsResponse)]) {
            id<IRAccountAssetsResponse> accountAssetsResult = result;

            BOOL containsValidAssetData = NO;

            for (id<IRAccountAsset> accountAsset in accountAssetsResult.accountAssets) {
                if ([accountAsset.assetId.identifier isEqualToString:assetId.identifier] &&
                    [accountAsset.balance.value intValue] == [addAmount.value intValue]) {
                    containsValidAssetData = YES;
                    break;
                }
            }

            if (!containsValidAssetData) {
                NSString *message = @"No asset found or balance invalid";
                NSError *error = [NSError errorWithDomain:@"co.jp.createassettest"
                                                     code:0
                                                 userInfo:@{NSLocalizedDescriptionKey: message}];

                return [IRPromise promiseWithResult:error];
            } else {
                return [IRPromise promiseWithResult:nil];
            }

        } else {
            NSString *message = [NSString stringWithFormat:@"Invalid account asset response %@", NSStringFromClass([result class])];
            NSError *error = [NSError errorWithDomain:@"co.jp.createassettest"
                                                 code:0
                                             userInfo:@{NSLocalizedDescriptionKey: message}];

            return [IRPromise promiseWithResult:error];
        }
    }).onThen(^IRPromise * _Nullable (id result) {
        IRQueryBuilder *queryBuilder = [IRQueryBuilder builderWithCreatorAccountId:self.adminAccountId];
        queryBuilder = [queryBuilder getAssetInfo:assetId];

        NSError *error = nil;
        id<IRQueryRequest> request = [[queryBuilder build:&error] signedWithSignatory:self.adminSigner
                                                                   signatoryPublicKey:self.adminPublicKey
                                                                                error:&error];

        if (error) {
            return [IRPromise promiseWithResult:error];
        }

        return [self.iroha executeQueryRequest:request];
    }).onThen(^IRPromise * _Nullable (id result) {
        if ([result conformsToProtocol:@protocol(IRAssetResponse)]) {
            id<IRAssetResponse> assetResponse = result;

            XCTAssertEqualObjects(assetResponse.assetId.identifier, assetId.identifier);
            XCTAssertEqual(assetResponse.precision, assetPrecision);

            return [IRPromise promiseWithResult:nil];
        } else {
            NSString *message = [NSString stringWithFormat:@"Invalid asset info response %@", NSStringFromClass([result class])];
            NSError *error = [NSError errorWithDomain:@"co.jp.createassettest"
                                                 code:0
                                             userInfo:@{NSLocalizedDescriptionKey: message}];

            return [IRPromise promiseWithResult:error];
        }
    }).onThen(^IRPromise * _Nullable (id result) {
        [expectation fulfill];
        return nil;
    }).onError(^IRPromise * _Nullable (NSError *error) {
        XCTFail();
        NSLog(@"%@", error);

        [expectation fulfill];
        return nil;
    });

    [self waitForExpectations:@[expectation] timeout:60.0];
}

@end

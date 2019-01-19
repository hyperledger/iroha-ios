@import XCTest;
@import IrohaCommunication;

static NSString * const VALID_ACCOUNT_IDENTIFIER = @"bob@gmail.com";
static NSString * const VALID_ASSET_IDENTIFIER = @"testcoin#gmail.com";
static NSString * const VALID_BALANCE = @"10.1";

@interface IRAccountAssetTests : XCTestCase

@end

@implementation IRAccountAssetTests

- (void)testSuccessfullCreation {
    id<IRAccountId> accountId = [IRAccountIdFactory accountWithIdentifier:VALID_ACCOUNT_IDENTIFIER
                                                                    error:nil];
    id<IRAssetId> assetId = [IRAssetIdFactory assetWithIdentifier:VALID_ASSET_IDENTIFIER
                                                            error:nil];
    id<IRAmount> balance = [IRAmountFactory amountFromString:VALID_BALANCE
                                                       error:nil];

    NSError *error = nil;
    id<IRAccountAsset> accountAsset = [IRAccountAssetFactory accountAssetWithAccountId:accountId
                                                                               assetId:assetId
                                                                               balance:balance
                                                                                 error:&error];

    XCTAssertNil(error);
    XCTAssertNotNil(accountAsset);
    XCTAssertEqualObjects([accountAsset.accountId identifier], [accountId identifier]);
    XCTAssertEqualObjects([accountAsset.assetId identifier], [assetId identifier]);
    XCTAssertEqualObjects([accountAsset.balance value], [balance value]);
}

@end

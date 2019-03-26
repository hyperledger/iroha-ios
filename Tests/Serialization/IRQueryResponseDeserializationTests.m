/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

@import XCTest;
@import IrohaCommunication;
@import IrohaCrypto;
#import "QryResponses.pbobjc.h"

static NSString * const VALID_ACCOUNT_IDENTIFIER = @"bob@gmail.com";
static NSString * const VALID_ASSET_IDENTIFIER = @"testcoin#gmail.com";
static NSString * const VALID_BALANCE = @"100";

@interface IRQueryResponseDeserializationTests : XCTestCase

@end

@implementation IRQueryResponseDeserializationTests

- (void)testAssetResponseDeserialization {
    // given
    AccountAsset *accountAsset = [[AccountAsset alloc] init];
    accountAsset.accountId = VALID_ACCOUNT_IDENTIFIER;
    accountAsset.assetId = VALID_ASSET_IDENTIFIER;
    accountAsset.balance = VALID_BALANCE;

    AccountAssetResponse *assetResponse = [[AccountAssetResponse alloc] init];
    [assetResponse setAccountAssetsArray:[NSMutableArray arrayWithObject:accountAsset]];

    NSString *queryHash = [assetResponse.data toHexString];

    QueryResponse *response = [[QueryResponse alloc] init];
    [response setQueryHash:queryHash];
    [response setAccountAssetsResponse:assetResponse];

    // when

    NSError *error = nil;
    id<IRQueryResponse> irQueryResponse = [IRSerializationFactory deserializeQueryResponseFromData:response.data error:&error];

    if (!irQueryResponse || ![irQueryResponse conformsToProtocol:@protocol(IRAccountAssetsResponse)]) {
        XCTFail("Unexpected empty response");
        return;
    }

    XCTAssertNil(error);
}

@end

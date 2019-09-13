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

- (void)testAssetResponseDeserializationWithoutNextPage {
    // given
    AccountAsset *accountAsset = [[AccountAsset alloc] init];
    accountAsset.accountId = VALID_ACCOUNT_IDENTIFIER;
    accountAsset.assetId = VALID_ASSET_IDENTIFIER;
    accountAsset.balance = VALID_BALANCE;

    AccountAssetResponse *assetResponse = [[AccountAssetResponse alloc] init];
    [assetResponse setAccountAssetsArray:[NSMutableArray arrayWithObject:accountAsset]];
    [assetResponse setTotalNumber:1];
    [assetResponse setNextAssetId:nil];

    NSString *queryHash = [assetResponse.data toHexString];

    QueryResponse *response = [[QueryResponse alloc] init];
    [response setQueryHash:queryHash];
    [response setAccountAssetsResponse:assetResponse];

    // when

    NSError *error = nil;
    id<IRQueryResponse> irQueryResponse = [IRSerializationFactory deserializeQueryResponseFromData:response.data error:&error];

    // then

    if (!irQueryResponse || ![irQueryResponse conformsToProtocol:@protocol(IRAccountAssetsResponse)]) {
        XCTFail("Unexpected empty response");
        return;
    }

    XCTAssertEqualObjects(irQueryResponse.queryHash, assetResponse.data);

    XCTAssertNil(error);
}

- (void)testAssetResponseDeserializationWithNextPage {
    // given
    AccountAsset *accountAsset = [[AccountAsset alloc] init];
    accountAsset.accountId = VALID_ACCOUNT_IDENTIFIER;
    accountAsset.assetId = VALID_ASSET_IDENTIFIER;
    accountAsset.balance = VALID_BALANCE;

    AccountAssetResponse *assetResponse = [[AccountAssetResponse alloc] init];
    [assetResponse setAccountAssetsArray:[NSMutableArray arrayWithObject:accountAsset]];
    [assetResponse setTotalNumber:1];
    [assetResponse setNextAssetId:VALID_ASSET_IDENTIFIER];

    NSString *queryHash = [assetResponse.data toHexString];

    QueryResponse *response = [[QueryResponse alloc] init];
    [response setQueryHash:queryHash];
    [response setAccountAssetsResponse:assetResponse];

    // when

    NSError *error = nil;
    id<IRQueryResponse> irQueryResponse = [IRSerializationFactory deserializeQueryResponseFromData:response.data error:&error];

    // then

    if (!irQueryResponse || ![irQueryResponse conformsToProtocol:@protocol(IRAccountAssetsResponse)]) {
        XCTFail("Unexpected empty response");
        return;
    }

    XCTAssertEqualObjects(irQueryResponse.queryHash, assetResponse.data);

    XCTAssertNil(error);
}

@end

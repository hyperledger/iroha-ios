/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

@import XCTest;
@import IrohaCommunication;

static NSString * const ASSET_ID = @"test#test";

@interface IRAssetPaginationTests : XCTestCase

@end

@implementation IRAssetPaginationTests

- (void)testNonnilStartingAssetId {
    id<IRAssetId> assetId = [IRAssetIdFactory assetWithIdentifier:ASSET_ID
                                                            error:nil];

    UInt32 pageSize = 10;

    id<IRAssetPagination> pagination = [IRAssetPaginationFactory assetPagination:pageSize startingAssetId:assetId];

    XCTAssertNotNil(pagination);
    XCTAssertEqual(pagination.pageSize, pageSize);
    XCTAssertEqualObjects(pagination.startingAssetId.identifier, assetId.identifier);
}

- (void)testNilStartingAssetId {
    UInt32 pageSize = 10;

    id<IRAssetPagination> pagination = [IRAssetPaginationFactory assetPagination:pageSize startingAssetId:nil];

    XCTAssertNotNil(pagination);
    XCTAssertEqual(pagination.pageSize, pageSize);
    XCTAssertNil(pagination.startingAssetId);
}

@end

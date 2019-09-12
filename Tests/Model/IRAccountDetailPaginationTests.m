/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <XCTest/XCTest.h>
@import IrohaCommunication;


@interface IRAccountDetailPaginationTests : XCTestCase

@end


@implementation IRAccountDetailPaginationTests

- (void)testNonnilStartingRecordId {
    UInt32 pageSize = 10;
    
    NSString *writer = @"writer";
    NSString *key = @"key";
    
    id<IRAccountDetailRecordId> nextRecordId = [IRAccountDetailRecordIdFactory accountDetailRecordIdWithWriter:writer
                                                                                                           key:key];
    
    id<IRAccountDetailPagination> pagination = [IRAccountDetailPaginationFactory accountDetailPagination:pageSize
                                                                                            nextRecordId:nextRecordId];
    
    XCTAssertNotNil(pagination);
    XCTAssertEqual(pagination.pageSize, pageSize);
    XCTAssertEqualObjects(pagination.nextRecordId.writer, writer);
    XCTAssertEqualObjects(pagination.nextRecordId.key, key);
}

- (void)testNilStartingRecordId {
    UInt32 pageSize = 10;

    id<IRAccountDetailRecordId> recordId = nil;

    id<IRAccountDetailPagination> pagination = [IRAccountDetailPaginationFactory accountDetailPagination:pageSize
                                                                                            nextRecordId:recordId];
    XCTAssertNil(pagination);
}


@end

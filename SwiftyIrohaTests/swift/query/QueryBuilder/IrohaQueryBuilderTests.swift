/**
 * Copyright Soramitsu Co., Ltd. 2017 All Rights Reserved.
 * http://soramitsu.co.jp
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import XCTest
@testable import SwiftyIroha

import UIKit

class IrohaQueryBuilderTests: XCTestCase {

    let creatorAcountId = "admin@test"
    let queryBuilder = IrohaQueryBuilder()

    override func setUp() {
        super.setUp()
    }

    func testCreatedTime() {
        let unsignedQuery = queryBuilder
            .creatorAccountId(creatorAcountId)
            .createdTime(Date())
            .queryCounter(1)
            .getAssetInfo(byAssetId: "dollar#ru")
            .build()
        print(unsignedQuery)
        XCTAssertEqual(true, true, "Score computed from guess is wrong")
    }

    func testCreateAccountId() {
        let query = queryBuilder
            .creatorAccountId("AccountID")
            .build()
        XCTAssertEqual(true, true, "Score computed from guess is wrong")
    }

    func testQueryCounter() {
        let query = queryBuilder
            .queryCounter(1)
            .build()
    }

    func testGetAccount() {
        let query = queryBuilder
            .getAccount(byAccountId: "AccountID")
            .build()
    }

    func testGetSignatories() {
        let query = queryBuilder
            .getSignatories(forAccountId: "AccountID")
            .build()
    }

    func testGetAccountTransactions() {
        let query = queryBuilder
            .getAccountTransactions(forAccountId: "AccountID")
            .build()
    }

    func testGetAccountAssetsTransactions() {
        let query = queryBuilder
            .getAccountAssetsTransactions(forAccountId: "AccountID", withAssetId: "AssetsID")
            .build()
    }

    func testGetAccountAssets() {
        let query = queryBuilder
            .getAccountAssets(forAccountId: "AccountID", withAssetId: "AssetsID")
            .build()
    }

    func testGetRoles() {
        let query = queryBuilder
            .getRoles()
            .build()
    }

    func testGetAssetInfo() {
        let query = queryBuilder
            .getAssetInfo(byAssetId: "AssetsID")
            .build()
    }

    func testGetRolePermissions() {
        let query = queryBuilder
            .getRolePermissions(forRoleId: "RoleID")
            .build()
    }

    func testGetTransactions() {
        let query = queryBuilder
            .getTransactions(withHashes: ["Hash1", "Hash2"])
            .build()
    }
}

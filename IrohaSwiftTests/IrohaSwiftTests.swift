/*
Copyright Soramitsu Co., Ltd. 2016 All Rights Reserved.
http://soramitsu.co.jp

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

         http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/


import XCTest
import IrohaSwift
@testable import IrohaSwift

class IrohaSwiftTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testSignature() {
        let keyPair = IrohaSwift.createKeyPair()
        let signature = IrohaSwift.sign(publicKey: keyPair.publicKey, privateKey: keyPair.privateKey, message: "test")
        let isValid = IrohaSwift.verify(publicKey: keyPair.publicKey, signature: signature, message: "test")

        XCTAssert(isValid, "veryfy?")
    }
    
    func testSha3_256(){
        let hash1 = "a7ffc6f8bf1ed76651c14756a061d662f580ff4de43b49fa82d80a4b80f8434a"
        let hash2 = sha3_256(message: "")
        XCTAssertEqual(hash1, hash2)
        let hash3 = "36f028580bb02cc8272a9a020f4200e346e276ae664e45ee80745574e2f5ab80"
        let hash4 = sha3_256(message: "test")
        XCTAssertEqual(hash3, hash4)
    }
    
    func testSha3_384(){
        let hash1 = "0c63a75b845e4f7d01107d852e4c2485c51a50aaaa94fc61995e71bbee983a2ac3713831264adb47fb6bd1e058d5f004"
        let hash2 = sha3_384(message: "")
        XCTAssertEqual(hash1, hash2)
        let hash3 = "e516dabb23b6e30026863543282780a3ae0dccf05551cf0295178d7ff0f1b41eecb9db3ff219007c4e097260d58621bd"
        let hash4 = sha3_384(message: "test")
        XCTAssertEqual(hash3, hash4)
    }
    
    func testSha3_512(){
        let hash1 = "a69f73cca23a9ac5c8b567dc185a756e97c982164fe25859e0d1dcc1475c80a615b2123af1f5f94c11e3e9402c3ac558f500199d95b6d3e301758586281dcd26"
        let hash2 = sha3_512(message: "")
        XCTAssertEqual(hash1, hash2)
        let hash3 = "9ece086e9bac491fac5c1d1046ca11d737b92a2b2ebd93f005d7b710110c0a678288166e7fbe796883a4f2e9b3ca9f484f521d0ce464345cc1aec96779149c14"
        let hash4 = sha3_512(message: "test")
        XCTAssertEqual(hash3, hash4)
    }
    
}

//Copyright 2016 Soramitsu Co., Ltd.
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.

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
        var isValid = false
        let keyPair = IrohaSwift.createKeyPair()
        let signature = IrohaSwift.sign(publicKey: keyPair.publicKey, privateKey: keyPair.privateKey, message: "test")
        let verify = IrohaSwift.verify(publicKey: keyPair.publicKey, signature: signature, message: "test")
        if verify == 1 {
            isValid = true
        }
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
    
}

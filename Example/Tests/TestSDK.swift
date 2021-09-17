import CryptoKit
import IrohaSwiftScale
import IrohaSwiftSDK
import XCTest

extension String {
    func toBytes() -> [UInt8]? {
        let length = count
        if length & 1 != 0 {
            return nil
        }
        var bytes = [UInt8]()
        bytes.reserveCapacity(length/2)
        var index = startIndex
        for _ in 0..<length/2 {
            let nextIndex = self.index(index, offsetBy: 2)
            if let b = UInt8(self[index..<nextIndex], radix: 16) {
                bytes.append(b)
            } else {
                return nil
            }
            index = nextIndex
        }
        return bytes
    }
}

class TestSDK: XCTestCase {
    
    // MARK: - Setup
    
    private let urlString = "http://127.0.0.1:8080"
    private let publicKeyString = "e555d194e8822da35ac541ce9eec8b45058f4d294d9426ef97ba92698766f7d3"
    private let privateKeyString = "de757bcb79f4c63e8fa0795edc26f86dfdba189b846e903d0b732bb644607720"
    
    private var account: IrohaAccount? {
        guard let publicKey = publicKeyString.toBytes() else { return nil }
        guard let privateKey = privateKeyString.toBytes() else { return nil }
        let accountId = IrohaDataModelAccount.Id(name: "alice", domainName: "wonderland")
        return IrohaAccount(keyPair: IrohaKeyPair(publicKey: publicKey, privateKey: privateKey), id: accountId)
    }
    
    // MARK: - Instructions
    
    func testInstructions() {
        guard let account = account else {
            XCTFail()
            return
        }
        let client = IrohaClient(serverUrlString: urlString, account: account)
        client.debug = true
        
        let exp = XCTestExpectation()
        client.submitInstructions([]) {
            XCTAssertNil($0)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5)
    }
    
    // MARK: - Query
    
    func testQuery() {
        guard let account = account else {
            XCTFail()
            return
        }
        let client = IrohaClient(serverUrlString: urlString, account: account)
        client.debug = true
        
        let queryBox = IrohaDataModelQuery.QueryBox.findAllDomains(IrohaDataModelQueryDomain.FindAllDomains())
        
        let exp = XCTestExpectation()
        client.submitQuery(queryBox, from: Date().addingTimeInterval(-86400)) { _, error in
            XCTAssertNil(error)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5)
    }
    
    // MARK: - Events
    
    func testSingleEvent() {
        guard let account = account else {
            XCTFail()
            return
        }
        let client = IrohaClient(serverUrlString: urlString, account: account)
        client.debug = true
        
        let exp = XCTestExpectation()
        client.receiveDataEvents { event in
            // do nothing
        } subscriptionAcceptedHandler: {
            exp.fulfill()
        } errorHandler: { error in
            XCTFail(error.localizedDescription)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5)
    }
    
    func testMultipleEvents() {
        guard let account = account else {
            XCTFail()
            return
        }
        
        let client = IrohaClient(serverUrlString: urlString, account: account)
        client.debug = true
        
        let numberOfConnections = 20
        var exps: [XCTestExpectation] = []
        
        for _ in 0..<numberOfConnections {
            let exp = XCTestExpectation()
            exps.append(exp)
            
            client.receiveDataEvents { event in
                // do nothing
            } subscriptionAcceptedHandler: {
                exp.fulfill()
            } errorHandler: { error in
                XCTFail(error.localizedDescription)
                exp.fulfill()
            }
        }
        
        wait(for: exps, timeout: 5)
    }
    
    func testReceivingEvents() {
        guard let account = account else {
            XCTFail()
            return
        }
        let client = IrohaClient(serverUrlString: urlString, account: account)
        client.debug = true
        
        var exps: [XCTestExpectation] = []
        
        let subscriptionAcceptExp = XCTestExpectation()
        exps.append(subscriptionAcceptExp)
        
        let eventReceivedExp = XCTestExpectation()
        exps.append(eventReceivedExp)
        
        client.receivePipelineEvents { event in
            eventReceivedExp.fulfill()
        } subscriptionAcceptedHandler: {
            subscriptionAcceptExp.fulfill()
        } errorHandler: { error in
            XCTFail(error.localizedDescription)
            exps.forEach { $0.fulfill() }
        }
        
        let submitInstructionExp = XCTestExpectation()
        exps.append(submitInstructionExp)
        
        let instructions: [IrohaDataModelIsi.Instruction] = [
            .register(
                .init(
                    object: .init(
                        expression: .raw(
                            .identifiable(
                                .assetDefinition(
                                    .init(
                                        valueType: .quantity,
                                        id: .init(name: "hydrangea", domainName: "wonderland"),
                                        metadata: .init(map: [:])
                                    )
                                )
                            )
                        )
                    )
                )
            ),
            .mint(
                .init(
                    object: .init(expression: .raw(.u32(13))),
                    destinationId: .init(
                        expression: .raw(
                            .id(
                                .assetId(
                                    .init(
                                        definitionId: .init(
                                            name: "hydrangea",
                                            domainName: "wonderland"
                                        ),
                                        accountId: .init(
                                            name: "alice",
                                            domainName: "wonderland")
                                    )
                                )
                            )
                        )
                    )
                )
            )
        ]
        
        client.submitInstructions(instructions) {
            XCTAssertNil($0)
            submitInstructionExp.fulfill()
        }
        
        wait(for: exps, timeout: 5)
    }
    
    // MARK: - Health
    
    func testHealth() {
        guard let account = account else {
            XCTFail()
            return
        }
        
        let client = IrohaClient(serverUrlString: urlString, account: account)
        client.debug = true
        
        let exp = XCTestExpectation()
        
        client.health { _, error in
            XCTAssertNil(error)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5)
    }
}

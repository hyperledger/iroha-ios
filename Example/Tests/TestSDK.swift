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
            XCTAssertNotNil($0)
            XCTAssertNil($1)
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
        
        // Test pre-requisites
        let eventsCount = 20
        let assetName = "hydrangea"
        let accountName = "alice"
        let accountDomainName = "wonderland"
        
        // Expectations
        
        var exps: [XCTestExpectation] = []
        
        let subscriptionAcceptExp = XCTestExpectation()
        exps.append(subscriptionAcceptExp)
        
        var transactionSubmittedExps: [XCTestExpectation] = []
        var eventsReceivedExps: [XCTestExpectation] = []
        
        for _ in 0..<eventsCount {
            // Submit
            do {
                let exp = XCTestExpectation()
                transactionSubmittedExps.append(exp)
            }
            // Receive
            do {
                let validatingExp = XCTestExpectation()
                eventsReceivedExps.append(validatingExp)
                let commitedOrRejectedExp = XCTestExpectation()
                eventsReceivedExps.append(commitedOrRejectedExp)
            }
        }
        
        exps.append(contentsOf: transactionSubmittedExps)
        exps.append(contentsOf: eventsReceivedExps)
        
        func failTest(_ message: String? = nil) {
            if let message = message {
                XCTFail(message)
            } else {
                XCTFail()
            }
            
            exps.forEach { $0.fulfill() }
        }
        
        // Submitting instructions
        
        // - Register
        let registerInstruction = IrohaDataModelIsi.Instruction.register(
            .init(
                object: .init(
                    expression: .raw(
                        .identifiable(
                            .assetDefinition(
                                .init(
                                    valueType: .quantity,
                                    id: .init(name: assetName, domainName: accountDomainName),
                                    metadata: .init(map: [:])
                                )
                            )
                        )
                    )
                )
            )
        )
        
        let registerTransactionExp = XCTestExpectation()
        exps.append(registerTransactionExp)
        
        do {
            let validatingExp = XCTestExpectation()
            eventsReceivedExps.append(validatingExp)
            let commitedOrRejectedExp = XCTestExpectation()
            eventsReceivedExps.append(commitedOrRejectedExp)
        }
        
        func submitRegisterAssetInstruction() {
            client.submitInstruction(registerInstruction) {
                guard $1 == nil else {
                    failTest()
                    return
                }
                
                guard let transaction = $0 else {
                    failTest()
                    return
                }
                
                transactions.append(transaction)
                registerTransactionExp.fulfill()
            }
        }
        
        // - Mint
        
        func makeMintInstruction(amount: UInt32) -> IrohaDataModelIsi.Instruction {
            .mint(
                .init(
                    object: .init(expression: .raw(.numeric(.u32(amount)))),
                    destinationId: .init(
                        expression: .raw(
                            .id(
                                .assetId(
                                    .init(
                                        definitionId: .init(
                                            name: assetName,
                                            domainName: accountDomainName
                                        ),
                                        accountId: .init(
                                            name: accountName,
                                            domainName: accountDomainName)
                                    )
                                )
                            )
                        )
                    )
                )
            )
        }
        
        func submitMintInstructions() {
            for _ in 0..<eventsCount {
                client.submitInstruction(makeMintInstruction(amount: UInt32.random(in: 1...100))) {
                    guard $1 == nil else {
                        failTest()
                        return
                    }
                    guard let transaction = $0 else {
                        failTest()
                        return
                    }
                    
                    transactions.append(transaction)
                    guard let exp = transactionSubmittedExps.popLast() else {
                        failTest()
                        return
                    }
                    
                    exp.fulfill()
                }
            }
        }
        
        // Receiving pipeline events
        
        var transactions: [IrohaDataModelTransaction.Transaction] = []
        
        client.receivePipelineEvents { event in
            guard event.entityType == .transaction else { return } // Ignore non-transaction events
            guard let transaction = transactions.first(where: { $0.hash == event.hash }) else { return } // Ignore non-test case transactions
            
            guard
                let exp = eventsReceivedExps.popLast(),
                case .instructions(let instructions) = transaction.payload.executable
            else {
                failTest()
                return
            }

            switch instructions[0] {

            case .register:
                exp.fulfill() // pass any way, during repeating tests it might be rejected as already existing asset
                
                switch event.status {
                case .committed, .rejected: submitMintInstructions()
                default: break // Do nothing
                }
                
            case .mint:
                switch event.status {
                case .validating: exp.fulfill()
                case .committed: exp.fulfill()
                case .rejected: failTest()
                }
                
            default:
                failTest()
                
            }
        } subscriptionAcceptedHandler: {
            subscriptionAcceptExp.fulfill()
            submitRegisterAssetInstruction()
        } errorHandler: { error in
            failTest(error.localizedDescription)
        }
        
        wait(for: exps, timeout: TimeInterval(eventsCount * 5))
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

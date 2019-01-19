import UIKit
import IrohaCommunication;
import IrohaCrypto;

class ViewController: UIViewController {
    private struct Constants {
        static let newAccountId = "benjamin@test"
        static let adminAccountId = "admin@test"
        static let assetId = "bencoin#test"
        static let domainId = "test"
        static let assetMintVolume: UInt = 10000
        static let irohaIp = "127.0.0.1"
        static let irohaPort = "50051"
        static let adminPublicKey = "313a07e6384776ed95447710d15e59148473ccfc052a681317a72a69f2a49910"
        static let adminPrivateKey = "f101537e319568c765b2cc89698325604991dca57b9716b58016b253506cab70"
        static let newAccountPublicKey = "69bc8575066fce6f3f2b05fd1e5c0f4c33ecf625733cb89c9ee724473efde4df"
        static let newAccountPrivateKey = "e76ad4f491c0f4b40d85b24addf61c30400a84cc45cc0532efa2d788ad11fcbc"
    }

    let domain: IRDomain = {
        return try! IRDomainFactory.domain(withIdentitifer: Constants.domainId)
    }()

    let adminAccountId: IRAccountId = {
        return try! IRAccountIdFactory.account(withIdentifier: Constants.adminAccountId)
    }()

    let adminPublicKey: IRPublicKeyProtocol = {
        let adminPublicKeyData = NSData(hexString: Constants.adminPublicKey)! as Data
        return IREd25519PublicKey(rawData: adminPublicKeyData)!
    }()

    let adminSigner: IRSignatureCreatorProtocol = {
        let adminPrivateKeyData = NSData(hexString: Constants.adminPrivateKey)! as Data
        let adminPrivateKey = IREd25519PrivateKey(rawData: adminPrivateKeyData)!
        return IREd25519Sha512Signer(privateKey: adminPrivateKey)!
    }()

    let assetId: IRAssetId = {
        return try! IRAssetIdFactory.asset(withIdentifier: Constants.assetId)
    }()

    let userAccountId: IRAccountId = {
        return try! IRAccountIdFactory.account(withIdentifier: Constants.newAccountId)
    }()

    let userPublicKey: IRPublicKeyProtocol = {
        let userPublicKeyData = NSData(hexString: Constants.newAccountPublicKey)! as Data
        return IREd25519PublicKey(rawData: userPublicKeyData)!
    }()

    let networkService: IRNetworkService = {
        let irohaAddress = try! IRAddressFactory.address(withIp: Constants.irohaIp, port: Constants.irohaPort)
        return IRNetworkService(address: irohaAddress)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            try startCommitStream()
            _ = createAccount()
                .onThen({ (result) -> IRPromise? in
                    return self.mintAsset()
                }).onThen({ (result) -> IRPromise? in
                    if result != nil {
                        return self.transfer(to: self.userAccountId,
                                             amount: 10,
                                             description: "Welcome!")
                    } else {
                        return IRPromise(result: result)
                    }
                }).onThen({ (result) -> IRPromise? in
                    print("Scenario completed!")
                    return nil
                }).onError({ (error) -> IRPromise? in
                    print("Scenario failed: \(error)")
                    return nil
                })
        } catch {
            print("Error: \(error)")
        }
    }

    // MARK: Private

    private func createAccount() -> IRPromise {
        do {
            let queryRequest = try IRQueryBuilder(creatorAccountId: adminAccountId)
                .getAccount(userAccountId)
                .build()
                .signed(withSignatory: adminSigner, signatoryPublicKey: adminPublicKey)

            print("Requesting account \(userAccountId.identifier())")

            return networkService.execute(queryRequest)
                .onThen({ (response) -> IRPromise? in
                    return self.decideOnAccountQuery(response: response)
                }).onThen({ (result) -> IRPromise? in
                    if let sentTransactionHash = result as? Data {
                        print("Transaction has been sent \((sentTransactionHash as NSData).toHexString())")
                        return self.networkService.onTransactionStatus(.committed, withHash: sentTransactionHash)
                    } else {
                        return IRPromise(result: result)
                    }
                })
        } catch {
            return IRPromise(result: error as NSError)
        }
    }

    private func decideOnAccountQuery(response: Any?) -> IRPromise {
        if let errorResponse = response as? IRErrorResponse {
            if errorResponse.reason == .noAccount {
                print("No account \(self.userAccountId.identifier()) found. Creating new one...")

                do {
                    let transaction = try IRTransactionBuilder(creatorAccountId: self.adminAccountId)
                        .createAccount(self.userAccountId, publicKey: self.userPublicKey)
                        .build()
                        .signed(withSignatories: [self.adminSigner], signatoryPublicKeys: [self.adminPublicKey])

                    return self.networkService.execute(transaction)
                } catch {
                    return IRPromise(result: error as NSError)
                }

            } else {
                let error = NSError.error(message: "Error reason code: \(errorResponse.reason), \(errorResponse.message)")
                return IRPromise(result: error as NSError)
            }
        } else if let _ = response as? IRAccountResponse {
            print("Account \(self.userAccountId.identifier()) already exists")
            return IRPromise(result: nil)
        } else {
            let error = NSError.error(message: "Unexpected response \(String(describing: response))")
            return IRPromise(result: error as NSError)
        }
    }

    private func mintAsset() -> IRPromise {
        do {
            let queryRequest = try IRQueryBuilder(creatorAccountId: adminAccountId)
                .getAssetInfo(assetId)
                .build()
                .signed(withSignatory: adminSigner, signatoryPublicKey: adminPublicKey)

            print("Requesting asset \(assetId.identifier())")

            return networkService.execute(queryRequest)
                .onThen({ (response) -> IRPromise? in
                    return self.decideOnMintQuery(response: response)
                }).onThen({ (result) -> IRPromise? in
                    if let sentTransactionHash = result as? Data {
                        print("Transaction has been sent \((sentTransactionHash as NSData).toHexString())")
                        return self.networkService.onTransactionStatus(.committed, withHash: sentTransactionHash)
                    } else {
                        return IRPromise(result: result)
                    }
                })
        } catch {
            return IRPromise(result: error as NSError)
        }
    }

    private func decideOnMintQuery(response: Any?) -> IRPromise {
        if let errorResponse = response as? IRErrorResponse {
            if errorResponse.reason == .noAsset {
                print("No asset \(self.assetId.identifier()) found.")
                print("Creating new one and minting \(Constants.assetMintVolume)")

                do {
                    let mintAmount = try IRAmountFactory.amount(fromUnsignedInteger: Constants.assetMintVolume)
                    let transaction = try IRTransactionBuilder(creatorAccountId: self.adminAccountId)
                        .createAsset(self.assetId, precision: 1)
                        .addAssetQuantity(self.assetId, amount: mintAmount)
                        .build()
                        .signed(withSignatories: [self.adminSigner], signatoryPublicKeys: [self.adminPublicKey])

                    return self.networkService.execute(transaction)
                } catch {
                    return IRPromise(result: error as NSError)
                }

            } else {
                let error = NSError.error(message: "Error reason code: \(errorResponse.reason), \(errorResponse.message)")
                return IRPromise(result: error as NSError)
            }
        } else if let _ = response as? IRAssetResponse {
            print("Asset \(self.assetId.identifier()) already exists")
            return IRPromise(result: nil)
        } else {
            let error = NSError.error(message: "Unexpected response \(String(describing: response))")
            return IRPromise(result: error as NSError)
        }
    }

    private func transfer(to newAccountId: IRAccountId, amount: UInt, description: String) -> IRPromise {
        do {
            let amountObject = try IRAmountFactory.amount(fromUnsignedInteger: amount)
            let transaction = try IRTransactionBuilder(creatorAccountId: adminAccountId)
                .transferAsset(adminAccountId,
                               destinationAccount: newAccountId,
                               assetId: assetId,
                               description: description,
                               amount: amountObject)
                .build()
                .signed(withSignatories: [adminSigner], signatoryPublicKeys: [adminPublicKey])

            return networkService.execute(transaction)
                .onThen({ (result) -> IRPromise? in
                    if let sentTransactionHash = result as? Data {
                        print("Transaction has been sent \((sentTransactionHash as NSData).toHexString())")
                        return self.networkService.onTransactionStatus(.committed, withHash: sentTransactionHash)
                    } else {
                        return IRPromise(result: result)
                    }
                })
        } catch {
            return IRPromise(result: error as NSError)
        }
    }

    private func startCommitStream() throws {
        let commitsRequest = try IRBlockQueryBuilder(creatorAccountId: adminAccountId)
            .build()
            .signed(withSignatory: adminSigner, signatoryPublicKey: adminPublicKey)

        networkService.streamCommits(commitsRequest) { (optionalResponse, done, optionalError) in
            if let response = optionalResponse {
                guard let block = response.block else {
                    print("Did receive error response: \(String(describing: response.error))")
                    return
                }

                print("Did receive commit at height=\(block.height), numOfTransactions=\(block.transactions.count)")
            } else if let error = optionalError {
                print("Did receive error: \(String(describing: error))")
            }

            if done {
                print("Did complete streaming")
            }
        }
    }
}


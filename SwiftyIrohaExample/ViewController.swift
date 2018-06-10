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

import UIKit
import SwiftProtobuf
import SwiftyIroha

class ViewController: UIViewController {

    // ================================[Settings]===========================================
    // Remember to change ACCOUNT_NAME_TO_CREATE after you launch an app once
    // Code below creates a new account in Iroha
    // If you do not change ACCOUNT_NAME_TO_CREATE after first succesfull excecution then you will get an error
    // Iroha won't let you to create two account with a same name, so please change it after success
    // =====================================================================================
    private final let ACCOUNT_NAME_TO_CREATE = "alex"
    private final let ADMIN_ACCOUNT_ID = "admin"
    private final let TEST_DOMAIN_ID = "test"
    private final let IROHA_ADDRESS = "127.0.0.1:50051"


    // Example of how to create a new account in Iroha
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setting keypair
        let publicKey = IrohaPublicKey(value: "889f6b881e331be21487db77dcf32c5f8d3d5e8066e78d2feac4239fe91d416f")
        let privateKey = IrohaPrivateKey(value: "0f0ce16d2afbb8eca23c7d8c2724f0c257a800ee2bbd54688cec6b898e3f7e33")

        // Initializing keypair object
        let existingKeypair = IrohaKeypair(publicKey: publicKey,
                                           privateKey: privateKey)

        let modelCrypto = IrohaModelCrypto()

        // Generating keypair object from excisting keypair object
        let newKeypair = modelCrypto.generateNewKeypair(from: existingKeypair)

        print("\(newKeypair)\n")

        do {
            try sendTransaction(signingWith: newKeypair)
        } catch {
            if let error = error as? IrohaTransactionBuilderError {
                print(error.errorDescription)
            }
        }

        // Waiting 5 seconds to be sure that transaction is processed
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
            do {
                 try self.sendQuery(signingWith: newKeypair)
            } catch {
                if let error = error as? IrohaQueryBuilderError {
                    print(error.errorDescription)
                }
            }
        })
    }

    func sendTransaction(signingWith keypair: IrohaKeypair) throws {
        // Data for testing
        let creatorAcountId = ADMIN_ACCOUNT_ID + "@" + TEST_DOMAIN_ID

        let irohaTransactionBuilder = IrohaTransactionBuilder()

        let modelCrypto = IrohaModelCrypto()

        // Initializing new user keypair object
        let newUserKeypair = modelCrypto.generateKeypair()

        // Creating transaction for Iroha to create new user
        let unsignedTransaction =
            try irohaTransactionBuilder
                .creatorAccountId(creatorAcountId)
                .createdTime(Date())
                .createAccount(withAccountName: ACCOUNT_NAME_TO_CREATE,
                               withDomainId: TEST_DOMAIN_ID,
                               withPublicKey: newUserKeypair.getPublicKey())
                .build()

        // Creating helper class for signing unsigned transaction
        let irohaTransactionPreparation = IrohaTransactionPreparation()

        // Signing transaction and getting object which is ready for converting to GRPC object
        let irohaSignedTransactionReadyForConvertingToGRPC =
            irohaTransactionPreparation.sign(unsignedTransaction,
                                             with: keypair)

        // Creating GRPC transaction object from signed transaction
        var irohaGRPCTransaction = Iroha_Protocol_Transaction()

        do {
            try irohaGRPCTransaction.merge(serializedData: irohaSignedTransactionReadyForConvertingToGRPC)

            // Checking that transaction is excactly transaction that was created
            print("Transaction to Iroha: \n")
            print("\(try irohaGRPCTransaction.payload.jsonString()) \n")
        }
        catch {
            let nsError = error as NSError
            print("\(nsError.localizedDescription) \n")
        }

        let serviceForSendingTransaction = Iroha_Protocol_CommandServiceServiceClient(address: IROHA_ADDRESS)

        do {
            let result = try serviceForSendingTransaction.torii(irohaGRPCTransaction)
            print(try result.jsonString())
        } catch {
            let nsError = error as NSError
            print("\(nsError.localizedDescription) \n")
        }
    }

    func sendQuery(signingWith keypair: IrohaKeypair) throws {
        // Data for testing
        let creatorAcountId = ADMIN_ACCOUNT_ID + "@" + TEST_DOMAIN_ID

        let queryBuilder = IrohaQueryBuilder()
        let unsignedQuery =
            try queryBuilder
                .creatorAccountId(creatorAcountId)
                .createdTime(Date())
                .queryCounter(1)
                .getAccount(byAccountId: ACCOUNT_NAME_TO_CREATE + "@" + TEST_DOMAIN_ID)
                .build()

        // Creating helper class for signing unsigned query
        let irohaQueryPreparation = IrohaQueryPreparation()

        let irohaSignedQueryReadyForConvertingToGRPC =
            irohaQueryPreparation.sign(unsignedQuery,
                                       with: keypair)

        var irohaGRPCQuery = Iroha_Protocol_Query()

        do {
            try irohaGRPCQuery.merge(serializedData: irohaSignedQueryReadyForConvertingToGRPC)

            // Checking that query is excactly query that was created
            print("Query to Iroha: \n")
            print("\(try irohaGRPCQuery.payload.jsonString()) \n")
        }
        catch {
            let nsError = error as NSError
            print("\(nsError.localizedDescription) \n")
        }

        let serviceForSendingQuery = Iroha_Protocol_QueryServiceServiceClient(address: IROHA_ADDRESS)

        do {
            let result = try serviceForSendingQuery.find(irohaGRPCQuery)
            print(result)
        } catch {
            let nsError = error as NSError
            print("\(nsError.localizedDescription) \n")
        }
    }
}

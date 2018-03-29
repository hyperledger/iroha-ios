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
import gRPC
import SwiftProtobuf
import SwiftyIroha

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting keypair
        let publicKey = IrohaPublicKey(value: "407e57f50ca48969b08ba948171bb2435e035d82cec417e18e4a38f5fb113f83")
        let privateKey = IrohaPrivateKey(value: "1d7e0a32ee0affeb4d22acd73c2c6fb6bd58e266c8c2ce4fa0ffe3dd6a253ffb")
        
        // Initializing keypair object
        let existingKeypair = IrohaKeypair(publicKey: publicKey,
                                           privateKey: privateKey)
        
        let modelCrypto = IrohaModelCrypto()
        
        // Generating keypair object from excisting keypair object
        let newKeypair = modelCrypto.generateNewKeypair(from: existingKeypair)
        
        print("\(newKeypair)\n")
        
        sendTransaction(signingWith: newKeypair)
        
        // Waiting 5 seconds to be sure that transaction is processed
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
            self.sendQuery(signingWith: newKeypair)
        })
    }
    
    func sendTransaction(signingWith keypair: IrohaKeypair) {
        // Data for testing
        let creatorAcountId = "admin@test"
        
        let irohaTransactionBuilder = IrohaTransactionBuilder()

        // Creating transaction for iroha
        let unsignedTransaction =
            irohaTransactionBuilder
                .add(creatorAccountId: creatorAcountId)
                .add(creationTime: Date())
                .add(transactionCounter: 1)
                .add(domainId: "ru", withDefaultRole: "user")
                .add(assetName: "dollar", domainId: "ru", percision: 0.1)
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

        let serviceForSendingTransaction = Iroha_Protocol_CommandServiceService(address: "127.0.0.1:50051")
        
        do {
            // try serviceForSendingTransaction.torii(irohaGRPCTransaction)
        } catch {
            let nsError = error as NSError
            print("\(nsError.localizedDescription) \n")
        }
    }
    
    func sendQuery(signingWith keypair: IrohaKeypair) {
        // Data for testing
        let creatorAcountId = "admin@test"

        let queryBuilder = IrohaQueryBuilder()
        let unsignedQuery =
            queryBuilder
                .creatorAccountId(creatorAccountId: creatorAcountId)
                .queryCounter(creationTime: Date())
                .queryCounter(queryCounter: 1)
                .getAccount(byAccountId: creatorAcountId)
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

        let serviceForSendingQuery = Iroha_Protocol_QueryServiceService(address: "127.0.0.1:50051")

        do {
            let result = try serviceForSendingQuery.find(irohaGRPCQuery)
            print(result)
        } catch {
            let nsError = error as NSError
            print("\(nsError.localizedDescription) \n")
        }
    }
}

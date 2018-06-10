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

private typealias KeypairObjC = IRKeypair

private typealias PublicKeySwift = IrohaPublicKey
private typealias PrivateKeySwift = IrohaPrivateKey
private typealias KeypairSwift = IrohaKeypair

public class IrohaModelCrypto {

    private let modelCrypto: IRModelCrypto

    public init() {
        modelCrypto = IRModelCrypto()
    }

    public func generateKeypair() -> IrohaKeypair {
        let keypairObjC: KeypairObjC = modelCrypto.generateKeypair()
        let keypairSwift = convertKeypairSwift(from: keypairObjC)
        return keypairSwift
    }

    public func generateKeypair(fromPrivateKey privateKey: IrohaPrivateKey) -> IrohaKeypair {
        let keypairObjC: KeypairObjC = modelCrypto.generateKeypair(fromPrivateKey: privateKey.getValue())
        let keypairSwift = convertKeypairSwift(from: keypairObjC)
        return keypairSwift
    }

    public func generateNewKeypair(from existingKeypair: IrohaKeypair) -> IrohaKeypair {
        // Getting string value from existing keypair
        let publicKey = existingKeypair.getPublicKey().getValue()
        let privateKey = existingKeypair.getPrivateKey().getValue()

        // Creating obj-c keypair
        let existingKeypairObjC: KeypairObjC = KeypairObjC(publicKey: publicKey,
                                                           withPrivateKey: privateKey)
        let newKeypairObjC: KeypairObjC = modelCrypto.generate(fromExisting: existingKeypairObjC)

        let newKeypairSwift = convertKeypairSwift(from: newKeypairObjC)
        return newKeypairSwift
    }

    private func convertKeypairSwift(from keypairObjC: KeypairObjC) -> KeypairSwift {
        let keypairSwift = KeypairSwift(keypairObjC: keypairObjC)
        return keypairSwift
    }
}

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

public class IrohaKeypair {

    fileprivate var keypairObjC: IRKeypair

    fileprivate var publicKey: IrohaPublicKey
    fileprivate var privateKey: IrohaPrivateKey

    public init(publicKey: IrohaPublicKey,
                privateKey: IrohaPrivateKey) {
        self.keypairObjC = IRKeypair(publicKey: publicKey.getValue(),
                                     withPrivateKey: privateKey.getValue())
        self.publicKey = publicKey
        self.privateKey = privateKey
    }

    public init(keypairObjC: IRKeypair) {
        self.keypairObjC = keypairObjC
        self.publicKey = IrohaPublicKey(value: keypairObjC.publicKey)
        self.privateKey = IrohaPrivateKey(value: keypairObjC.privateKey)
    }

    public func getPublicKey() -> IrohaPublicKey {
        return publicKey
    }

    public func getPrivateKey() -> IrohaPrivateKey {
        return privateKey
    }

    public func getKeypairObjC() -> IRKeypair {
        return keypairObjC
    }
}

extension IrohaKeypair: CustomStringConvertible {
    public var description: String {
        return " ==================================== Keypair ===================================="
            +  "\n| \(publicKey.description)  |"
            +  "\n| \(privateKey.description) |"
            +  "\n ================================================================================="
    }
}

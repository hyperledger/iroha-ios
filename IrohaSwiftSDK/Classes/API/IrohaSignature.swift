//
// Copyright 2021 Soramitsu Co., Ltd.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import CryptoKit
import Foundation
import IrohaSwiftScale
import Sodium

extension IrohaCrypto.Signature {
    
    enum Error: Swift.Error {
        case hashingFailed
        case signingFailed(Swift.Error)
    }
    
    public init(signing data: Data, with keyPair: IrohaKeyPair) throws {
        guard let hash = Sodium().genericHash.hash(message: data.map { $0 }, outputLength: 32) else {
            throw Error.hashingFailed
        }
        
        publicKey = IrohaCrypto.PublicKey(digestFunction: "ed25519", payload: keyPair.publicKey)
        
        do {
            let privateKey = try Curve25519.Signing.PrivateKey(rawRepresentation: keyPair.privateKey)
            signature = try privateKey.signature(for: hash).map { $0 }
        } catch let error {
            throw Error.signingFailed(error)
        }
    }
    
    public init<T: Encodable>(signing value: T, with keyPair: IrohaKeyPair) throws {
        try self.init(signing: try ScaleEncoder().encode(value), with: keyPair)
    }
}

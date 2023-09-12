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

import Blake2
import CryptoKit
import Foundation
import IrohaSwiftScale
import Sodium

import ScaleCodec

extension IrohaCrypto.Signature {
    
    public typealias Hash = IrohaCrypto.Hash
    
    enum Error: Swift.Error {
        case hashingFailed
        case signingFailed(Swift.Error)
    }
    
    public static func hash(_ data: Data) throws -> Hash? {
        guard let hashBytes = Sodium().genericHash.hash(message: data.map { $0 }, outputLength: Hash.fixedSize) else { return nil }
        return try Hash(hashBytes)
    }
    
    public static func hash<T: ScaleCodec.Encodable>(_ value: T) throws -> Hash? {
        let data = try ScaleCodec.encode(value)
        return try hash(data)
    }
    
    public init(signing data: Data, with keyPair: IrohaKeyPair) throws {
        //guard let test = try Self.hash(data) else { throw Error.hashingFailed }

        //debugPrint(Array(test).toSigned())

        let sourceArray: [Int8] = [73, 52, 94, -64, -1, 9, 120, -9, 11, -94, -106, 95, 51, 55, -64, -11, -63, 91, 88, -39, -74, 77, 12, 82, 77, -49, 35, -63, -71, 99, 50, 91, -42, 47, 55, 39, -104, -37, -2, -8, -70, -80, 74, 28, 122, 30, -81, 2, -126, -2, -73, 41, 88, -124, 115, -37, -16, -89, 49, 42, 111, -37, 74, -115]
        let source = Data(bytes: sourceArray, count: sourceArray.count)

        let validArray: [Int8] = [3, -105, 122, -80, 84, 70, 2, 126, -83, 19, -96, -83, 43, -10, 72, 83, -28, 26, 73, 53, -10, -44, -8, 94, -124, -119, 43, 29, -56, -29, -91, -118, 20, -26, 39, 47, 111, -38, 28, 110, -73, -8, 98, 79, 97, -38, -12, -16, -66, 5, 76, 47, -97, -92, 117, 34, 13, 83, -120, -22, -126, -41, 51, 14]
        let valid = Data(bytes: validArray, count: validArray.count)

        debugPrint(Array(source).toSigned())

        publicKey = IrohaCrypto.PublicKey(digestFunction: .ed25519, payload: keyPair.publicKey)

        do {
            let hash = try Blake2.hash(.b2b, size: 32, data: source)
            debugPrint("Blake2: \(Array(hash).toSigned())")

            let privateKey = try Curve25519.Signing.PrivateKey(rawRepresentation: keyPair.privateKey)
            signature = try privateKey.signature(for: hash.map { $0 }).map { $0 }

            debugPrint("source: \(Array(hash).toSigned())")
            debugPrint("private key: \(Array(privateKey.rawRepresentation).toSigned())")
            debugPrint("public key: \(Array(privateKey.publicKey.rawRepresentation).toSigned())")
            debugPrint("signature: \(Array(signature).toSigned())")
            debugPrint(privateKey.publicKey.isValidSignature(valid, for: Data(hash)))
        } catch let error {
            throw Error.signingFailed(error)
        }
    }
    
    public init<T: ScaleCodec.Encodable>(signing value: T, with keyPair: IrohaKeyPair) throws {
        try self.init(signing: try ScaleCodec.encode(value), with: keyPair)
    }
}

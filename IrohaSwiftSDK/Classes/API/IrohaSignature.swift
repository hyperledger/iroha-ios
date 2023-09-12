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
        let sourceArray: [Int8] = [73, 52, 94, -64, -1, 9, 120, -9, 11, -94, -106, 95, 51, 55, -64, -11, -63, 91, 88, -39, -74, 77, 12, 82, 77, -49, 35, -63, -71, 99, 50, 91, -42, 47, 55, 39, -104, -37, -2, -8, -70, -80, 74, 28, 122, 30, -81, 2, -126, -2, -73, 41, 88, -124, 115, -37, -16, -89, 49, 42, 111, -37, 74, -115]
        let source = Data(bytes: sourceArray, count: sourceArray.count)

        let validArray: [Int8] = [-93, -50, -59, -31, 108, -28, -69, -92, 120, 31, 63, -120, 44, 18, -123, 102, 97, -93, -20, 56, 10, -40, 122, -53, -121, 72, 27, -86, -24, 37, -117, -21, 8, 126, -86, 46, 49, -12, -121, 53, -59, 77, 119, 100, 67, -8, 120, 111, -121, -122, -91, 17, 16, 60, 81, 18, 99, 114, 88, 30, 56, 109, 92, 3]
        let valid = Data(bytes: validArray, count: validArray.count)

        let privArray: [Int8] = [-78, -38, 41, -110, 30, 1, 52, -66, 30, 0, 124, -20, 93, -50, 4, 126, 97, 55, -83, 11, 75, 102, -106, -82, 105, 37, -29, -31, 39, 36, -47, -17]
        let privKey = Data(bytes: privArray, count: privArray.count)

        let publArray: [Int8] = [-73, -110, 58, 22, 99, -63, -43, -20, 92, -49, -31, -93, 73, 43, -114, -47, 125, -82, -2, -113, -22, 102, -102, -72, -72, 63, 34, 102, 37, -34, 123, 7]
        let pubKey = Data(bytes: publArray, count: publArray.count)

        debugPrint(Array(source).toSigned())

        publicKey = IrohaCrypto.PublicKey(digestFunction: .ed25519, payload: keyPair.publicKey)

        do {
            let hash = try Blake2.hash(.b2b, size: 32, data: source)
            debugPrint("Blake2: \(Array(hash).toSigned())")

            let privateKey = try Curve25519.Signing.PrivateKey(rawRepresentation: privKey)
            signature = try privateKey.signature(for: hash.map { $0 }).map { $0 }

            debugPrint("source: \(Array(source).toSigned())")
            debugPrint("private key: \(Array(privKey).toSigned())")
            debugPrint("public key: \(Array(pubKey).toSigned())")
            debugPrint("signature: \(Array(signature).toSigned())")
            debugPrint(privateKey.publicKey.isValidSignature(valid, for: Data(hash)))
            debugPrint(privateKey.publicKey.isValidSignature(signature, for: Data(hash)))

            let p = try Curve25519.Signing.PublicKey(rawRepresentation: pubKey)
            debugPrint(p.isValidSignature(valid, for: Data(hash)))
            debugPrint(p.isValidSignature(signature, for: Data(hash)))
        } catch let error {
            throw Error.signingFailed(error)
        }
    }
    
    public init<T: ScaleCodec.Encodable>(signing value: T, with keyPair: IrohaKeyPair) throws {
        try self.init(signing: try ScaleCodec.encode(value), with: keyPair)
    }
}

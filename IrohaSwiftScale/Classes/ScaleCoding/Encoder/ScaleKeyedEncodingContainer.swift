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

import Foundation

/// Actually ignores keys and encode incrementally according to SCALE spec (https://substrate.dev/docs/en/knowledgebase/advanced/codec)
final class ScaleKeyedEncodingContainer<K: CodingKey>: KeyedEncodingContainerProtocol, ScaleEncodingContainer {
    
    // MARK: - KeyedEncodingContainerProtocol
    
    typealias Key = K
    
    let codingPath: [CodingKey]
    let userInfo: [CodingUserInfoKey: Any]
    
    // MARK: - ScaleEncodingContainer
    
    private var keys: [K] = []
    private var containers: [ScaleEncodingContainer] = []

    var data: Data {
        containers.reduce(Data()) { $0 + $1.data }
    }
    
    // MARK: - Init
    
    private let encoderProvider: ScaleEncoderProvider
    
    init(encoderProvider: ScaleEncoderProvider, codingPath: [CodingKey] = [], userInfo: [CodingUserInfoKey: Any] = [:]) {
        self.encoderProvider = encoderProvider
        self.codingPath = codingPath
        self.userInfo = userInfo
    }
    
    // MARK: - Encoding
    
    private func encodeIfPresent<T>(_ value: T?, forKey key: K, encoder: (T) throws -> Void) throws {
        if let value = value {
            try nestedSingleValueEncodingContainer(forKey: key).encodeNotNil()
            try encoder(value)
        } else {
            try nestedSingleValueEncodingContainer(forKey: key).encodeNil()
        }
    }
    
    func encodeNil(forKey key: K) throws {
        try nestedSingleValueEncodingContainer(forKey: key).encodeNil()
    }
    
    func encode(_ value: Bool, forKey key: K) throws {
        try nestedSingleValueEncodingContainer(forKey: key).encode(value)
    }
    
    func encodeIfPresent(_ value: Bool?, forKey key: K) throws {
        try nestedSingleValueEncodingContainer(forKey: key).encode(value)
    }
    
    func encode(_ value: String, forKey key: K) throws {
        try nestedSingleValueEncodingContainer(forKey: key).encode(value)
    }
    
    func encodeIfPresent(_ value: String?, forKey key: K) throws {
        try encodeIfPresent(value, forKey: key) {
            try encode($0, forKey: key)
        }
    }
    
    func encode(_ value: Int, forKey key: K) throws {
        try nestedSingleValueEncodingContainer(forKey: key).encode(value)
    }
    
    func encodeIfPresent(_ value: Int?, forKey key: K) throws {
        try encodeIfPresent(value, forKey: key) {
            try encode($0, forKey: key)
        }
    }
    
    func encode(_ value: Int8, forKey key: K) throws {
        try nestedSingleValueEncodingContainer(forKey: key).encode(value)
    }
    
    func encodeIfPresent(_ value: Int8?, forKey key: K) throws {
        try encodeIfPresent(value, forKey: key) {
            try encode($0, forKey: key)
        }
    }
    
    func encode(_ value: Int16, forKey key: K) throws {
        try nestedSingleValueEncodingContainer(forKey: key).encode(value)
    }
    
    func encodeIfPresent(_ value: Int16?, forKey key: K) throws {
        try encodeIfPresent(value, forKey: key) {
            try encode($0, forKey: key)
        }
    }
    
    func encode(_ value: Int32, forKey key: K) throws {
        try nestedSingleValueEncodingContainer(forKey: key).encode(value)
    }
    
    func encodeIfPresent(_ value: Int32?, forKey key: K) throws {
        try encodeIfPresent(value, forKey: key) {
            try encode($0, forKey: key)
        }
    }
    
    func encode(_ value: Int64, forKey key: K) throws {
        try nestedSingleValueEncodingContainer(forKey: key).encode(value)
    }
    
    func encodeIfPresent(_ value: Int64?, forKey key: K) throws {
        try encodeIfPresent(value, forKey: key) {
            try encode($0, forKey: key)
        }
    }
    
    func encode(_ value: UInt, forKey key: K) throws {
        try nestedSingleValueEncodingContainer(forKey: key).encode(value)
    }
    
    func encodeIfPresent(_ value: UInt?, forKey key: K) throws {
        try encodeIfPresent(value, forKey: key) {
            try encode($0, forKey: key)
        }
    }
    
    func encode(_ value: UInt8, forKey key: K) throws {
        try nestedSingleValueEncodingContainer(forKey: key).encode(value)
    }
    
    func encodeIfPresent(_ value: UInt8?, forKey key: K) throws {
        try encodeIfPresent(value, forKey: key) {
            try encode($0, forKey: key)
        }
    }
    
    func encode(_ value: UInt16, forKey key: K) throws {
        try nestedSingleValueEncodingContainer(forKey: key).encode(value)
    }
    
    func encodeIfPresent(_ value: UInt16?, forKey key: K) throws {
        try encodeIfPresent(value, forKey: key) {
            try encode($0, forKey: key)
        }
    }
    
    func encode(_ value: UInt32, forKey key: K) throws {
        try nestedSingleValueEncodingContainer(forKey: key).encode(value)
    }
    
    func encodeIfPresent(_ value: UInt32?, forKey key: K) throws {
        try encodeIfPresent(value, forKey: key) {
            try encode($0, forKey: key)
        }
    }
    
    func encode(_ value: UInt64, forKey key: K) throws {
        try nestedSingleValueEncodingContainer(forKey: key).encode(value)
    }
    
    func encodeIfPresent(_ value: UInt64?, forKey key: K) throws {
        try encodeIfPresent(value, forKey: key) {
            try encode($0, forKey: key)
        }
    }
    
    func encode<T>(_ value: T, forKey key: K) throws where T : Encodable {
        try nestedSingleValueEncodingContainer(forKey: key).encode(value)
    }
    
    func encodeIfPresent<T>(_ value: T?, forKey key: K) throws where T : Encodable {
        try encodeIfPresent(value, forKey: key) {
            try encode($0, forKey: key)
        }
    }
    
    private func nestedCodingPath(forKey key: CodingKey) -> [CodingKey] {
        codingPath + [key]
    }
    
    private func nestedSingleValueEncodingContainer(forKey key: K, append: Bool = true) -> ScaleSingleValueEncodingContainer {
        let container = ScaleSingleValueEncodingContainer(encoderProvider: encoderProvider, codingPath: nestedCodingPath(forKey: key), userInfo: userInfo)
        if append {
            containers.append(container)
        }
        return container
    }
    
    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: K) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        let container = ScaleKeyedEncodingContainer<NestedKey>(encoderProvider: encoderProvider, codingPath: codingPath, userInfo: userInfo)
        containers.append(container)
        return KeyedEncodingContainer(container)
    }
    
    func nestedUnkeyedContainer(forKey key: K) -> UnkeyedEncodingContainer {
        let container = ScaleUnkeyedEncodingContainer(encoderProvider: encoderProvider, codingPath: codingPath, userInfo: userInfo)
        containers.append(container)
        return container
    }
    
    func superEncoder() -> Encoder {
        encoderProvider.encoder(codingPath: codingPath, userInfo: userInfo)
    }
    
    func superEncoder(forKey key: K) -> Encoder {
        encoderProvider.encoder(codingPath: nestedCodingPath(forKey: key), userInfo: userInfo)
    }
}

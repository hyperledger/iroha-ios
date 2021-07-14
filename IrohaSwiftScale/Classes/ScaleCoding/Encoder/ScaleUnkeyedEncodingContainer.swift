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

final class ScaleUnkeyedEncodingContainer: UnkeyedEncodingContainer, ScaleEncodingContainer {
    
    // MARK: - UnkeyedEncodingContainer
    
    let codingPath: [CodingKey]
    let userInfo: [CodingUserInfoKey: Any]
    
    var count: Int { containers.count}
    
    // MARK: - ScaleEncodingContainer
    
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
    
    func encodeNil() throws {
        try nestedSingleValueEncodingContainer().encodeNil()
    }
    
    func encode(_ value: Bool) throws {
        try nestedSingleValueEncodingContainer().encode(value)
    }
    
    func encode(_ value: String) throws {
        try nestedSingleValueEncodingContainer().encode(value)
    }
    
    func encode(_ value: Int) throws {
        try nestedSingleValueEncodingContainer().encode(value)
    }
    
    func encode(_ value: Int8) throws {
        try nestedSingleValueEncodingContainer().encode(value)
    }
    
    func encode(_ value: Int16) throws {
        try nestedSingleValueEncodingContainer().encode(value)
    }
    
    func encode(_ value: Int32) throws {
        try nestedSingleValueEncodingContainer().encode(value)
    }
    
    func encode(_ value: Int64) throws {
        try nestedSingleValueEncodingContainer().encode(value)
    }
    
    func encode(_ value: UInt) throws {
        try nestedSingleValueEncodingContainer().encode(value)
    }
    
    func encode(_ value: UInt8) throws {
        try nestedSingleValueEncodingContainer().encode(value)
    }
    
    func encode(_ value: UInt16) throws {
        try nestedSingleValueEncodingContainer().encode(value)
    }
    
    func encode(_ value: UInt32) throws {
        try nestedSingleValueEncodingContainer().encode(value)
    }
    
    func encode(_ value: UInt64) throws {
        try nestedSingleValueEncodingContainer().encode(value)
    }
    
    func encode<T>(_ value: T) throws where T : Encodable {
        try nestedSingleValueEncodingContainer().encode(value)
    }
    
    private func nestedSingleValueEncodingContainer() throws  -> ScaleSingleValueEncodingContainer {
        let container = ScaleSingleValueEncodingContainer(encoderProvider: encoderProvider, codingPath: codingPath, userInfo: userInfo)
        containers.append(container)
        return container
    }
    
    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        KeyedEncodingContainer(ScaleKeyedEncodingContainer(encoderProvider: encoderProvider, codingPath: codingPath, userInfo: userInfo))
    }
    
    func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        ScaleUnkeyedEncodingContainer(encoderProvider: encoderProvider, codingPath: codingPath, userInfo: userInfo)
    }
    
    func superEncoder() -> Encoder {
        encoderProvider.encoder(codingPath: codingPath, userInfo: userInfo)
    }
}

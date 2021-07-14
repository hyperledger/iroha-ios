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

// MARK: - ScaleEncodingContainer

protocol ScaleEncodingContainer {
    var data: Data { get }
}

// MARK: - ScaleEncoderProvider

protocol ScaleEncoderProvider {
    func encoder(codingPath: [CodingKey], userInfo: [CodingUserInfoKey: Any]) -> Encoder & ScaleEncodingContainer
}

extension ScaleEncoderProvider {
    func encoder(codingPath: [CodingKey]) -> Encoder & ScaleEncodingContainer{
        encoder(codingPath: codingPath, userInfo: [:])
    }
    
    func encoder(userInfo: [CodingUserInfoKey: Any]) -> Encoder & ScaleEncodingContainer {
        encoder(codingPath: [], userInfo: userInfo)
    }
    
    func encoder() -> Encoder & ScaleEncodingContainer {
        encoder(codingPath: [], userInfo: [:])
    }
}

// MARK: - ScaleEncoder

public final class ScaleEncoder: ScaleEncoderProvider {
    
    private let codingPath: [CodingKey]
    private let userInfo: [CodingUserInfoKey: Any]
    
    public init(codingPath: [CodingKey] = [], userInfo: [CodingUserInfoKey: Any] = [:]) {
        self.codingPath = codingPath
        self.userInfo = userInfo
    }
    
    func encoder(codingPath: [CodingKey], userInfo: [CodingUserInfoKey: Any]) -> Encoder & ScaleEncodingContainer {
        _ScaleEncoder(provider: self, codingPath: codingPath, userInfo: userInfo)
    }

    public func encode<T>(_ value: T) throws -> Data where T : Encodable {
        let encoder = encoder()
        if let value = value as? EncodableScaleConvertible {
            try value.encodeAsScale(to: encoder)
            return encoder.data
        }
        
        try value.encode(to: encoder)
        return encoder.data
    }
}

// MARK: - Internal encoder

private final class _ScaleEncoder: Encoder, ScaleEncodingContainer {
    
    var codingPath: [CodingKey]
    var userInfo: [CodingUserInfoKey: Any]
    
    private let provider: ScaleEncoderProvider
    private var container: ScaleEncodingContainer?
    
    fileprivate var data: Data {
        container?.data ?? Data()
    }
    
    fileprivate init(provider: ScaleEncoderProvider, codingPath: [CodingKey] = [], userInfo: [CodingUserInfoKey: Any] = [:]) {
        self.provider = provider
        self.codingPath = codingPath
        self.userInfo = userInfo
    }
    
    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
        let container = ScaleKeyedEncodingContainer<Key>(encoderProvider: provider, codingPath: codingPath, userInfo: userInfo)
        self.container = container
        return KeyedEncodingContainer(container)
    }
    
    func unkeyedContainer() -> UnkeyedEncodingContainer {
        let container = ScaleUnkeyedEncodingContainer(encoderProvider: provider, codingPath: codingPath, userInfo: userInfo)
        self.container = container
        return container
    }
    
    func singleValueContainer() -> SingleValueEncodingContainer {
        let container = ScaleSingleValueEncodingContainer(encoderProvider: provider, codingPath: codingPath, userInfo: userInfo)
        self.container = container
        return container
    }
}

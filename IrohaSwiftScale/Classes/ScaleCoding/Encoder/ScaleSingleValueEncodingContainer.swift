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

final class ScaleSingleValueEncodingContainer: SingleValueEncodingContainer, ScaleEncodingContainer {
    
    // MARK: - SingleValueEncodingContainer
    
    let codingPath: [CodingKey]
    let userInfo: [CodingUserInfoKey: Any]
    
    // MARK: - ScaleEncodingContainer
    
    private var _data: Data?
    var data: Data { _data ?? Data() }
    
    // MARK: - Init
    
    private let encoderProvider: ScaleEncoderProvider
    
    init(encoderProvider: ScaleEncoderProvider, codingPath: [CodingKey] = [], userInfo: [CodingUserInfoKey: Any] = [:]) {
        self.encoderProvider = encoderProvider
        self.codingPath = codingPath
        self.userInfo = userInfo
    }
    
    // MARK: - Encoding
    
    private func checkCanEncode(value: Any?) throws {
        guard _data == nil else {
            let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Single value container already contains encoded value")
            throw EncodingError.invalidValue(value as Any, context)
        }
    }
    
    func encodeNil() throws {
        try checkCanEncode(value: nil)
        _data = Data([0])
    }
    
    func encodeNotNil() throws {
        try checkCanEncode(value: nil)
        _data = Data([1])
    }
    
    func encode(_ value: Bool) throws {
        try checkCanEncode(value: value)
        _data = Data([value ? 1 : 0])
    }
    
    func encode(_ value: Bool?) throws {
        try checkCanEncode(value: value)
        _data = try ScaleEncoder(codingPath: codingPath, userInfo: userInfo).encode(value)
    }
    
    func encode(_ value: String) throws {
        try checkCanEncode(value: value)
        
        guard let bytes = value.data(using: .utf8) else {
            let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Failed to get string bytes")
            throw EncodingError.invalidValue(value, context)
        }
        
        try encode(Compact(bytes.count))
        guard let data = _data else {
            let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Failed to write string bytes length")
            throw EncodingError.invalidValue(value, context)
        }
        
        _data = data + bytes
    }
    
    func encode(_ value: Int) throws {
        try checkCanEncode(value: value)
        var value = value
        _data = withUnsafeBytes(of: &value, { Data($0) })
    }
    
    func encode(_ value: Int8) throws {
        try checkCanEncode(value: value)
        var value = value
        _data = withUnsafeBytes(of: &value, { Data($0) })
    }
    
    func encode(_ value: Int16) throws {
        try checkCanEncode(value: value)
        var value = value
        _data = withUnsafeBytes(of: &value, { Data($0) })
    }
    
    func encode(_ value: Int32) throws {
        try checkCanEncode(value: value)
        var value = value
        _data = withUnsafeBytes(of: &value, { Data($0) })
    }
    
    func encode(_ value: Int64) throws {
        try checkCanEncode(value: value)
        var value = value
        _data = withUnsafeBytes(of: &value, { Data($0) })
    }
    
    func encode(_ value: UInt) throws {
        try checkCanEncode(value: value)
        var value = value
        _data = withUnsafeBytes(of: &value, { Data($0) })
    }
    
    func encode(_ value: UInt8) throws {
        try checkCanEncode(value: value)
        var value = value
        _data = withUnsafeBytes(of: &value, { Data($0) })
    }
    
    func encode(_ value: UInt16) throws {
        try checkCanEncode(value: value)
        var value = value
        _data = withUnsafeBytes(of: &value, { Data($0) })
    }
    
    func encode(_ value: UInt32) throws {
        try checkCanEncode(value: value)
        var value = value
        _data = withUnsafeBytes(of: &value, { Data($0) })
    }
    
    func encode(_ value: UInt64) throws {
        try checkCanEncode(value: value)
        var value = value
        _data = withUnsafeBytes(of: &value, { Data($0) })
    }
    
    func encode<T>(_ value: T) throws where T : Encodable {
        try checkCanEncode(value: value)
        _data = try ScaleEncoder(codingPath: codingPath, userInfo: userInfo).encode(value)
    }
}

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

// MARK: - DataReader

final class DataReader {
    
    private let _data: Data
    private lazy var index = _data.startIndex
    var data: Data { _data.subdata(in: index..<_data.count) }
    
    var isAtEnd: Bool { index == _data.count }
    
    var size: Int { _data.count }
    
    init(data: Data) {
        _data = data
    }
    
    func read(_ length: Int, at codingPath: [CodingKey], movePointer: Bool = true) throws -> Data {
        let nextIndex = index.advanced(by: length)
        guard nextIndex <= _data.endIndex else {
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Unexpected end of data")
            throw DecodingError.dataCorrupted(context)
        }
        
        let index = self.index
        if movePointer {
            self.index = nextIndex
        }
        
        return _data.subdata(in: index..<nextIndex)
    }
    
    func read<T>(_ type: T.Type, at codingPath: [CodingKey] = [], movePointer: Bool = true) throws -> T where T : FixedWidthInteger {
        let stride = MemoryLayout<T>.stride
        let bytes = [UInt8](try read(stride, at: codingPath, movePointer: movePointer))
        return T(littleEndian: bytes.withUnsafeBytes { $0.load(as: T.self) })
    }
}

// MARK: - ScaleDecoderProvider

protocol ScaleDecoderProvider {
    func decoder(dataReader: DataReader, codingPath: [CodingKey], userInfo: [CodingUserInfoKey: Any]) -> Decoder
}

// MARK: - ScaleDecoder

public final class ScaleDecoder: ScaleDecoderProvider {
    
    private let codingPath: [CodingKey]
    private let userInfo: [CodingUserInfoKey: Any]

    func decoder(dataReader: DataReader, codingPath: [CodingKey], userInfo: [CodingUserInfoKey: Any]) -> Decoder {
        _ScaleDecoder(decoderProvider: self, dataReader: dataReader, codingPath: codingPath, userInfo: userInfo)
    }

    public init(codingPath: [CodingKey] = [], userInfo: [CodingUserInfoKey: Any] = [:]) {
        self.codingPath = codingPath
        self.userInfo = userInfo
    }

    public func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        try decode(type, from: DataReader(data: data))
    }
    
    func decode<T>(_ type: T.Type, from dataReader: DataReader) throws -> T where T : Decodable {
        let decoder = decoder(dataReader: dataReader, codingPath: codingPath, userInfo: userInfo)
        if let customType = type as? DecodableScaleConvertible.Type {
            return try customType.init(asScaleFrom: decoder) as! T
        }
        return try T(from: decoder)
    }
}

// MARK: - Internal decoder

private final class _ScaleDecoder: Decoder {

    var codingPath: [CodingKey]
    var userInfo: [CodingUserInfoKey : Any]

    private let decoderProvider: ScaleDecoderProvider
    private let dataReader: DataReader

    fileprivate init(decoderProvider: ScaleDecoderProvider, dataReader: DataReader, codingPath: [CodingKey] = [], userInfo: [CodingUserInfoKey: Any] = [:]) {
        self.decoderProvider = decoderProvider
        self.dataReader = dataReader
        self.codingPath = codingPath
        self.userInfo = userInfo
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        ScaleSingleValueDecodingContainer(
            decoderProvider: decoderProvider,
            dataReader: dataReader,
            codingPath: codingPath,
            userInfo: userInfo
        )
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        try ScaleUnkeyedDecodingContainer(
            decoderProvider: decoderProvider,
            dataReader: dataReader,
            codingPath: codingPath,
            userInfo: userInfo
        )
    }

    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        let container = ScaleKeyedDecodingContainer<Key>(
            decoderProvider: decoderProvider,
            dataReader: dataReader,
            codingPath: codingPath,
            userInfo: userInfo
        )
        return KeyedDecodingContainer(container)
    }
}

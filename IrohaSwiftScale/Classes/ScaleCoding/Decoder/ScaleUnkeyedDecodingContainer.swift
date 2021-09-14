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

final class ScaleUnkeyedDecodingContainer: UnkeyedDecodingContainer {

    // MARK: - UnkeyedDecodingContainer

    var codingPath: [CodingKey]
    let userInfo: [CodingUserInfoKey: Any]
    
    var count: Int? = nil
    var isAtEnd: Bool {
        count.map { $0 == currentIndex } ?? true
    }
    var currentIndex = 0
        
    // MARK: - Init
    
    private let decoderProvider: ScaleDecoderProvider
    private let dataReader: DataReader
    
    init(decoderProvider: ScaleDecoderProvider, dataReader: DataReader, codingPath: [CodingKey], userInfo: [CodingUserInfoKey: Any]) throws {
        self.decoderProvider = decoderProvider
        self.dataReader = dataReader
        self.codingPath = codingPath
        self.userInfo = userInfo
        
        currentIndex = 0 // drop index after reading count
    }
    
    // MARK: - Decoding
    
    private func decodeIfPresent<T>(_ type: T.Type, decoder: () throws -> T) throws -> T? {
        let isPresent = try nestedSingleValueDecodingContainer().decode(Bool.self)
        return isPresent ? try decoder() : nil
    }

    func decodeNil() throws -> Bool {
        nestedSingleValueDecodingContainer().decodeNil()
    }

    func decode(_ type: Bool.Type) throws -> Bool {
        try nestedSingleValueDecodingContainer().decode(type)
    }
    
    func decodeIfPresent(_ type: Bool.Type) throws -> Bool? {
        try nestedSingleValueDecodingContainer().decodeOptional(type)
    }

    func decode(_ type: String.Type) throws -> String {
        try nestedSingleValueDecodingContainer().decode(type)
    }
    
    func decodeIfPresent(_ type: String.Type) throws -> String? {
        try decodeIfPresent(type) {
            try decode(type)
        }
    }

    func decode(_ type: Int.Type) throws -> Int {
        try nestedSingleValueDecodingContainer().decode(type)
    }
    
    func decodeIfPresent(_ type: Int.Type) throws -> Int? {
        try decodeIfPresent(type) {
            try decode(type)
        }
    }

    func decode(_ type: Int8.Type) throws -> Int8 {
        try nestedSingleValueDecodingContainer().decode(type)
    }
    
    func decodeIfPresent(_ type: Int8.Type) throws -> Int8? {
        try decodeIfPresent(type) {
            try decode(type)
        }
    }

    func decode(_ type: Int16.Type) throws -> Int16 {
        try nestedSingleValueDecodingContainer().decode(type)
    }
    
    func decodeIfPresent(_ type: Int16.Type) throws -> Int16? {
        try decodeIfPresent(type) {
            try decode(type)
        }
    }

    func decode(_ type: Int32.Type) throws -> Int32 {
        try nestedSingleValueDecodingContainer().decode(type)
    }
    
    func decodeIfPresent(_ type: Int32.Type) throws -> Int32? {
        try decodeIfPresent(type) {
            try decode(type)
        }
    }

    func decode(_ type: Int64.Type) throws -> Int64 {
        try nestedSingleValueDecodingContainer().decode(type)
    }
    
    func decodeIfPresent(_ type: Int64.Type) throws -> Int64? {
        try decodeIfPresent(type) {
            try decode(type)
        }
    }

    func decode(_ type: UInt.Type) throws -> UInt {
        try nestedSingleValueDecodingContainer().decode(type)
    }
    
    func decodeIfPresent(_ type: UInt.Type) throws -> UInt? {
        try decodeIfPresent(type) {
            try decode(type)
        }
    }

    func decode(_ type: UInt8.Type) throws -> UInt8 {
        try nestedSingleValueDecodingContainer().decode(type)
    }
    
    func decodeIfPresent(_ type: UInt8.Type) throws -> UInt8? {
        try decodeIfPresent(type) {
            try decode(type)
        }
    }

    func decode(_ type: UInt16.Type) throws -> UInt16 {
        try nestedSingleValueDecodingContainer().decode(type)
    }
    
    func decodeIfPresent(_ type: UInt16.Type) throws -> UInt16? {
        try decodeIfPresent(type) {
            try decode(type)
        }
    }

    func decode(_ type: UInt32.Type) throws -> UInt32 {
        try nestedSingleValueDecodingContainer().decode(type)
    }
    
    func decodeIfPresent(_ type: UInt32.Type) throws -> UInt32? {
        try decodeIfPresent(type) {
            try decode(type)
        }
    }

    func decode(_ type: UInt64.Type) throws -> UInt64 {
        try nestedSingleValueDecodingContainer().decode(type)
    }
    
    func decodeIfPresent(_ type: UInt64.Type) throws -> UInt64? {
        try decodeIfPresent(type) {
            try decode(type)
        }
    }

    func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        try nestedSingleValueDecodingContainer().decode(type)
    }
    
    func decodeIfPresent<T>(_ type: T.Type) throws -> T? where T : Decodable {
        try decodeIfPresent(type) {
            try decode(type)
        }
    }
    
    private func nestedSingleValueDecodingContainer() -> ScaleSingleValueDecodingContainer {
        currentIndex += 1
        return ScaleSingleValueDecodingContainer(
            decoderProvider: decoderProvider,
            dataReader: dataReader,
            codingPath: codingPath,
            userInfo: userInfo
        )
    }

    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        let container = ScaleKeyedDecodingContainer<NestedKey>(
            decoderProvider: decoderProvider,
            dataReader: dataReader,
            codingPath: codingPath,
            userInfo: userInfo
        )
        return KeyedDecodingContainer(container)
    }

    func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        try ScaleUnkeyedDecodingContainer(
            decoderProvider: decoderProvider,
            dataReader: dataReader,
            codingPath: codingPath,
            userInfo: userInfo
        )
    }

    func superDecoder() throws -> Decoder {
        decoderProvider.decoder(dataReader: dataReader, codingPath: codingPath, userInfo: userInfo)
    }
}

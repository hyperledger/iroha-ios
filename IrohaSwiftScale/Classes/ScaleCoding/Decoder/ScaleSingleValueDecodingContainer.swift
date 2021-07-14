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

final class ScaleSingleValueDecodingContainer: SingleValueDecodingContainer {

    // MARK: - SingleValueDecodingContainer
    
    var codingPath: [CodingKey]
    let userInfo: [CodingUserInfoKey: Any]
        
    // MARK: - Init
    
    private let decoderProvider: ScaleDecoderProvider
    private let dataReader: DataReader
    
    init(decoderProvider: ScaleDecoderProvider, dataReader: DataReader, codingPath: [CodingKey], userInfo: [CodingUserInfoKey: Any]) {
        self.decoderProvider = decoderProvider
        self.dataReader = dataReader
        self.codingPath = codingPath
        self.userInfo = userInfo
    }
    
    // MARK: - Decoding

    func decodeNil() -> Bool {
        (((try? dataReader.read(1, at: codingPath).first.map { $0 == 0b0 }) as Bool??)) == true
    }

    func decode(_ type: Bool.Type) throws -> Bool {
        guard let byte = try dataReader.read(1, at: codingPath).first else {
            throw DecodingError.dataCorruptedError(in: self, debugDescription: "No bytes for boolean")
        }
        
        switch byte {
        case 0: return false
        case 1: return true
        default:
            let context = DecodingError.Context.init(codingPath: codingPath, debugDescription: "Invalid boolean value")
            throw DecodingError.typeMismatch(Bool.self, context)
        }
    }
    
    func decodeOptional(_ type: Bool.Type) throws -> Bool? {
        try ScaleDecoder(codingPath: codingPath, userInfo: userInfo).decode(Bool?.self, from: dataReader)
    }

    func decode(_ type: String.Type) throws -> String {
        let length = try decode(Compact<UInt128>.self)
        guard let string = String(data: try dataReader.read(Int(length.value), at: codingPath), encoding: .utf8) else {
            throw DecodingError.dataCorruptedError(in: self, debugDescription: "Couldn't read string of length \(length)")
        }
        
        return string
    }

    func decode(_ type: Int.Type) throws -> Int {
        try dataReader.read(type, at: codingPath)
    }

    func decode(_ type: Int8.Type) throws -> Int8 {
        try dataReader.read(type, at: codingPath)
    }

    func decode(_ type: Int16.Type) throws -> Int16 {
        try dataReader.read(type, at: codingPath)
    }

    func decode(_ type: Int32.Type) throws -> Int32 {
        try dataReader.read(type, at: codingPath)
    }

    func decode(_ type: Int64.Type) throws -> Int64 {
        try dataReader.read(type, at: codingPath)
    }

    func decode(_ type: UInt.Type) throws -> UInt {
        try dataReader.read(type, at: codingPath)
    }

    func decode(_ type: UInt8.Type) throws -> UInt8 {
        try dataReader.read(type, at: codingPath)
    }

    func decode(_ type: UInt16.Type) throws -> UInt16 {
        try dataReader.read(type, at: codingPath)
    }

    func decode(_ type: UInt32.Type) throws -> UInt32 {
        try dataReader.read(type, at: codingPath)
    }

    func decode(_ type: UInt64.Type) throws -> UInt64 {
        try dataReader.read(type, at: codingPath)
    }

    func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        try ScaleDecoder(codingPath: codingPath, userInfo: userInfo).decode(type, from: dataReader)
    }
}

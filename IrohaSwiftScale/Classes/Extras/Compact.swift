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

private extension Data {
    var removingZeroesAtEnd: Data {
        guard let offset = lastIndex(where: { $0 > 0 }) else {
            return Data([0])
        }
    
        return self[0...offset]
    }
    
    func fillingZeroesAtEnd(byteWidth: Int) -> Data {
        guard count != byteWidth else { return self }
        
        var data = self
        for _ in 0..<(byteWidth - count) {
            data.append(0)
        }
        
        return data
    }
}

private extension FixedWidthInteger {
    static var byteWidth: Int { bitWidth / 8 }
}

private extension UInt128 {
    init(clampedData: Data) throws {
        switch clampedData.count {
        case (0...UInt8.byteWidth): self = UInt128(UInt8(littleEndian: clampedData.fillingZeroesAtEnd(byteWidth: UInt8.byteWidth).withUnsafeBytes { $0.load(as: UInt8.self) }))
        case (0...UInt16.byteWidth): self = UInt128(UInt16(littleEndian: clampedData.fillingZeroesAtEnd(byteWidth: UInt16.byteWidth).withUnsafeBytes { $0.load(as: UInt16.self) }))
        case (0...UInt32.byteWidth): self = UInt128(UInt32(littleEndian: clampedData.fillingZeroesAtEnd(byteWidth: UInt32.byteWidth).withUnsafeBytes { $0.load(as: UInt32.self) }))
        case (0...UInt64.byteWidth): self = UInt128(UInt64(littleEndian: clampedData.fillingZeroesAtEnd(byteWidth: UInt64.byteWidth).withUnsafeBytes { $0.load(as: UInt64.self) }))
        default:
            let dataReader = DataReader(data: clampedData.fillingZeroesAtEnd(byteWidth: UInt128.byteWidth))
            let upperBits = try dataReader.read(UInt64.self)
            let lowerBits = try dataReader.read(UInt64.self)
            self = UInt128(upperBits: upperBits, lowerBits: lowerBits)
        }
    }
    
    var clampedData: Data {
        var data: Data
        
        switch self {
        case (0..<1 << UInt8.bitWidth): data = withUnsafeBytes(of: UInt8(self), { Data($0) })
        case (0..<1 << UInt16.bitWidth): data = withUnsafeBytes(of: UInt16(self), { Data($0) })
        case (0..<1 << UInt32.bitWidth): data = withUnsafeBytes(of: UInt32(self), { Data($0) })
        case (0..<1 << UInt64.bitWidth): data = withUnsafeBytes(of: UInt64(self), { Data($0) })
        default: data = withUnsafeBytes(of: value.upperBits) { Data($0) } + withUnsafeBytes(of: value.lowerBits) { Data($0) }
        }
        
        return data.removingZeroesAtEnd
    }
}

public struct Compact<I: FixedWidthInteger>: Codable, Equatable {
    
    public var value: UInt128
    
    public init(_ value: I) {
        self.value = UInt128(value)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        switch value {
        case (0..<1 << (UInt8.bitWidth - 2)): try (UInt8(value) << 2).encode(to: encoder)
        case (0..<1 << (UInt16.bitWidth - 2)): try (UInt16(value) << 2 | 0b01).encode(to: encoder)
        case (0..<1 << (UInt32.bitWidth - 2)): try (UInt32(value) << 2 | 0b10).encode(to: encoder)
        default:
            let data = value.clampedData
            let count = UInt8(data.count - 4) << 2 | 0b11
            try container.encode(count)
            try data.forEach { try container.encode($0) }
        }
    }
    
    public init(from decoder: Decoder) throws {
        let first = try UInt8(from: decoder)
        let mode = first & 0b11
        let value = first | 0b11
        
        func readRest<T: FixedWidthInteger>(of type: T.Type) throws -> UInt128 {
            let bytesLeft = UInt8(type.bitWidth / UInt8.bitWidth) - 1
            let data = Data([value] + (try (0..<bytesLeft).map { _ in try UInt8(from: decoder) }))
            return UInt128(try DataReader(data: data).read(type)) >> 2
        }
        
        switch mode {
        case 0b00:
            self.value = UInt128(UInt8(value) >> 2)
        case 0b01:
            self.value = UInt128(try readRest(of: UInt16.self))
        case 0b10:
            self.value = UInt128(try readRest(of: UInt32.self))
        default:
            let count = value >> 2 + 4
            let data = Data(try (0..<count).map { _ in try UInt8(from: decoder) })
            self.value = try UInt128(clampedData: data)
        }
    }
}

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

private struct ScaleDictionaryPair<Key: Encodable, Value: Encodable>: Encodable {
    var key: Key
    var value: Value
}

protocol EncodableScaleConvertible {
    func encodeAsScale(to encoder: Encoder) throws
}

extension Dictionary: EncodableScaleConvertible where Key: Encodable, Value: Encodable {
    func encodeAsScale(to encoder: Encoder) throws {
        let pairs = map { ScaleDictionaryPair(key: $0, value: $1) }
        try pairs.encodeAsScale(to: encoder)
    }
}

// MARK: - Optional

private enum ScaleBool: Int, Encodable {
    case none = 0
    case `true`
    case `false`
    
    init(_ value: Bool?) {
        self = value.map { $0 ? .true : .false } ?? .none
    }
}

extension Optional: EncodableScaleConvertible where Wrapped: Encodable {
    func encodeAsScale(to encoder: Encoder) throws {
        if Wrapped.self == Bool.self {
            try ScaleBool(self as? Bool).encode(to: encoder)
        } else if let value = self {
            var container = encoder.unkeyedContainer()
            try container.encode(UInt8(1))
            try container.encode(value)
        } else {
            var container = encoder.unkeyedContainer()
            try container.encode(UInt8(0))
        }
    }
}

// MARK: - Array

extension Array: EncodableScaleConvertible where Element: Encodable {
    func encodeAsScale(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(Compact(count))
        for element in self {
            try container.encode(element)
        }
    }
}

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

protocol DecodableScaleConvertible {
    init(asScaleFrom decoder: Decoder) throws
}

// MARK: - Dictionary

private struct ScaleDictionaryPair<Key: Decodable, Value: Decodable>: Decodable {
    var key: Key
    var value: Value
}

extension Dictionary: DecodableScaleConvertible where Key: Decodable, Value: Decodable {
    init(asScaleFrom decoder: Decoder) throws {
        let pairs = try [ScaleDictionaryPair<Key, Value>](asScaleFrom: decoder)
        self = .init(uniqueKeysWithValues: pairs.map { ($0.key, $0.value) })
    }
}

// MARK: - Optional

private enum ScaleBool: Int, Decodable {
    case none = 0
    case `true`
    case `false`
    
    var boolValue: Optional<Bool> {
        switch self {
        case .none: return nil
        case .true: return true
        case .false: return false
        }
    }
}

extension Optional: DecodableScaleConvertible where Wrapped: Decodable {
    init(asScaleFrom decoder: Decoder) throws {
        if Wrapped.self == Bool.self {
            self = try ScaleBool(from: decoder).boolValue as! Optional<Wrapped>
            return
        }
        
        var container = try decoder.unkeyedContainer()
        let isNil = try container.decode(UInt8.self) == 0
        if isNil {
            self = .none
            return
        }
        
        self = .some(try container.decode(Wrapped.self))
    }
}

// MARK: - Array

extension Array: DecodableScaleConvertible where Element: Decodable {
    init(asScaleFrom decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let count = try container.decode(Compact<UInt128>.self)
        self = try (0..<count.value).map { _ in try container.decode(Element.self) }
    }
}

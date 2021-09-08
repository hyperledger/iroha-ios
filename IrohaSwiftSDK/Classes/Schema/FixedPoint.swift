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
import IrohaSwiftScale

// MARK: - Extensions
    
private extension Float {
    init(base: Int64, decimalPlaces: Float) {
        self = Float(base) / powf(10, decimalPlaces)
    }
    
    func toInt64(decimalPlaces: Float) -> Int64 {
        Int64(self * powf(10, decimalPlaces))
    }
}
// MARK: - FixedPoint
    
public struct FixedPoint {
    
    public let decimalPlaces: Float = 9
    
    public private(set) var base: Int64
    
    public var value: Float {
        get { Float(base: base, decimalPlaces: decimalPlaces) }
        set { base = newValue.toInt64(decimalPlaces: decimalPlaces) }
    }
    
    public init(base: Int64) {
        self.base = base
    }
    
    public init(value: Float) {
        self.base = value.toInt64(decimalPlaces: decimalPlaces)
    }
}
    
// MARK: - Codable
    
extension FixedPoint: Codable {
    public init(from decoder: Decoder) throws {
        self.base = try decoder.singleValueContainer().decode(Int64.self)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(base)
    }
}
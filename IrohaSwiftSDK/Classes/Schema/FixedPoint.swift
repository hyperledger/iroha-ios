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
    
private extension NSDecimalNumber {
    static func roundingBehavior(scale: Int16) -> NSDecimalNumberBehaviors {
        NSDecimalNumberHandler(
            roundingMode: .plain,
            scale: scale,
            raiseOnExactness: false,
            raiseOnOverflow: false,
            raiseOnUnderflow: false,
            raiseOnDivideByZero: false
        )
    }
}
    
private extension Decimal {
    init(base: UInt64, decimalPlaces: Int16) {
        self = NSDecimalNumber(value: base).multiplying(byPowerOf10: -decimalPlaces) as Decimal
    }
    
    func toUInt64(decimalPlaces: Int16) throws -> UInt64 {
        let multiplied = (self as NSDecimalNumber)
            .multiplying(byPowerOf10: decimalPlaces, withBehavior: NSDecimalNumber.roundingBehavior(scale: decimalPlaces))
    
        guard (multiplied as Decimal) <= Decimal(UInt64.max) else {
            throw FixedPoint.Error.decimalValueTooHigh
        }
    
        return multiplied.uint64Value
    }
}
// MARK: - FixedPoint
    
public struct FixedPoint {
    
    enum Error: Swift.Error {
        case decimalValueTooHigh
    }
    
    public static let decimalPlaces: Int16 = 9
    
    public private(set) var base: UInt64
    
    public var value: Decimal {
        get { Decimal(base: base, decimalPlaces: Self.decimalPlaces) }
    }
    
    public init(base: UInt64) {
        self.base = base
    }
    
    public init(value: Decimal) throws {
        self.base = try value.toUInt64(decimalPlaces: Self.decimalPlaces)
    }
}
    
// MARK: - Codable
    
extension FixedPoint: Swift.Codable {
    public init(from decoder: Swift.Decoder) throws {
        self.base = try decoder.singleValueContainer().decode(UInt64.self)
    }
    
    public func encode(to encoder: Swift.Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(base)
    }
}
    
// MARK: - Comparable
    
extension FixedPoint: Comparable {
    public static func == (lhs: FixedPoint, rhs: FixedPoint) -> Bool {
        lhs.base == rhs.base
    }
    
    public static func < (lhs: FixedPoint, rhs: FixedPoint) -> Bool {
        lhs.base < rhs.base
    }
}
    
// MARK: - AdditiveArithmetic
    
extension FixedPoint: AdditiveArithmetic {
    public static var zero: FixedPoint {
        .init(base: 0)
    }
    
    public static func - (lhs: FixedPoint, rhs: FixedPoint) -> FixedPoint {
        .init(base: lhs.base - rhs.base)
    }
    
    public static func + (lhs: FixedPoint, rhs: FixedPoint) -> FixedPoint {
        .init(base: lhs.base + rhs.base)
    }
}
    
// MARK: - SignedNumeric
    
extension FixedPoint: SignedNumeric {
    public var magnitude: Decimal {
        value.magnitude
    }
    
    public init?<T>(exactly source: T) where T : BinaryInteger {
        guard let base = try? Decimal(exactly: source)?.toUInt64(decimalPlaces: Self.decimalPlaces) else {
            return nil
        }
    
        self.base = base
    }
    
    public init(integerLiteral value: Int) {
        // Int value won't exceed UInt64.max limit, so we can force unwrap
        self.base = try! Decimal(value).toUInt64(decimalPlaces: Self.decimalPlaces)
    }
    
    public static func * (lhs: FixedPoint, rhs: FixedPoint) -> FixedPoint {
        .init(base: lhs.base * rhs.base)
    }
    
    public static func *= (lhs: inout FixedPoint, rhs: FixedPoint) {
        lhs.base *= rhs.base
    }
    
    public static func / (lhs: FixedPoint, rhs: FixedPoint) -> FixedPoint {
        // Both values are correct fixed points, can be forced
        .init(base: try! (lhs.value / rhs.value).toUInt64(decimalPlaces: Self.decimalPlaces))
    }
    
    public static func /= (lhs: inout FixedPoint, rhs: FixedPoint) {
        // Both values are correct fixed points, can be forced
        lhs.base = try! (lhs.value / rhs.value).toUInt64(decimalPlaces: Self.decimalPlaces)
    }
    
    public static func += (lhs: inout FixedPoint, rhs: FixedPoint) {
        lhs.base += rhs.base
    }
    
    public static func -= (lhs: inout FixedPoint, rhs: FixedPoint) {
        lhs.base -= rhs.base
    }
}
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

extension IrohaDataModelExpression {
public indirect enum Expression: Codable {
    
    case add(IrohaDataModelExpression.Add)
    case subtract(IrohaDataModelExpression.Subtract)
    case multiply(IrohaDataModelExpression.Multiply)
    case divide(IrohaDataModelExpression.Divide)
    case mod(IrohaDataModelExpression.Mod)
    case raiseTo(IrohaDataModelExpression.RaiseTo)
    case greater(IrohaDataModelExpression.Greater)
    case less(IrohaDataModelExpression.Less)
    case equal(IrohaDataModelExpression.Equal)
    case not(IrohaDataModelExpression.Not)
    case and(IrohaDataModelExpression.And)
    case or(IrohaDataModelExpression.Or)
    case `if`(IrohaDataModelExpression.If)
    case raw(IrohaDataModel.Value)
    case query(IrohaDataModelQuery.QueryBox)
    case contains(IrohaDataModelExpression.Contains)
    case containsAll(IrohaDataModelExpression.ContainsAll)
    case containsAny(IrohaDataModelExpression.ContainsAny)
    case `where`(IrohaDataModelExpression.Where)
    case contextValue(IrohaDataModelExpression.ContextValue)
    
    // MARK: - For Codable purpose
    
    static func index(of case: Self) -> Int {
        switch `case` {
            case .add:
                return 0
            case .subtract:
                return 1
            case .multiply:
                return 2
            case .divide:
                return 3
            case .mod:
                return 4
            case .raiseTo:
                return 5
            case .greater:
                return 6
            case .less:
                return 7
            case .equal:
                return 8
            case .not:
                return 9
            case .and:
                return 10
            case .or:
                return 11
            case .`if`:
                return 12
            case .raw:
                return 13
            case .query:
                return 14
            case .contains:
                return 15
            case .containsAll:
                return 16
            case .containsAny:
                return 17
            case .`where`:
                return 18
            case .contextValue:
                return 19
        }
    }
    
    // MARK: - Decodable
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let index = try container.decode(Int.self)
        switch index {
        case 0:
            let val0 = try container.decode(IrohaDataModelExpression.Add.self)
            self = .add(val0)
            break
        case 1:
            let val0 = try container.decode(IrohaDataModelExpression.Subtract.self)
            self = .subtract(val0)
            break
        case 2:
            let val0 = try container.decode(IrohaDataModelExpression.Multiply.self)
            self = .multiply(val0)
            break
        case 3:
            let val0 = try container.decode(IrohaDataModelExpression.Divide.self)
            self = .divide(val0)
            break
        case 4:
            let val0 = try container.decode(IrohaDataModelExpression.Mod.self)
            self = .mod(val0)
            break
        case 5:
            let val0 = try container.decode(IrohaDataModelExpression.RaiseTo.self)
            self = .raiseTo(val0)
            break
        case 6:
            let val0 = try container.decode(IrohaDataModelExpression.Greater.self)
            self = .greater(val0)
            break
        case 7:
            let val0 = try container.decode(IrohaDataModelExpression.Less.self)
            self = .less(val0)
            break
        case 8:
            let val0 = try container.decode(IrohaDataModelExpression.Equal.self)
            self = .equal(val0)
            break
        case 9:
            let val0 = try container.decode(IrohaDataModelExpression.Not.self)
            self = .not(val0)
            break
        case 10:
            let val0 = try container.decode(IrohaDataModelExpression.And.self)
            self = .and(val0)
            break
        case 11:
            let val0 = try container.decode(IrohaDataModelExpression.Or.self)
            self = .or(val0)
            break
        case 12:
            let val0 = try container.decode(IrohaDataModelExpression.If.self)
            self = .`if`(val0)
            break
        case 13:
            let val0 = try container.decode(IrohaDataModel.Value.self)
            self = .raw(val0)
            break
        case 14:
            let val0 = try container.decode(IrohaDataModelQuery.QueryBox.self)
            self = .query(val0)
            break
        case 15:
            let val0 = try container.decode(IrohaDataModelExpression.Contains.self)
            self = .contains(val0)
            break
        case 16:
            let val0 = try container.decode(IrohaDataModelExpression.ContainsAll.self)
            self = .containsAll(val0)
            break
        case 17:
            let val0 = try container.decode(IrohaDataModelExpression.ContainsAny.self)
            self = .containsAny(val0)
            break
        case 18:
            let val0 = try container.decode(IrohaDataModelExpression.Where.self)
            self = .`where`(val0)
            break
        case 19:
            let val0 = try container.decode(IrohaDataModelExpression.ContextValue.self)
            self = .contextValue(val0)
            break
        default:
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown index \(index)")
        }
    }
    
    // MARK: - Encodable
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(Expression.index(of: self))
        switch self {
        case let .add(val0):
            try container.encode(val0)
            break
        case let .subtract(val0):
            try container.encode(val0)
            break
        case let .multiply(val0):
            try container.encode(val0)
            break
        case let .divide(val0):
            try container.encode(val0)
            break
        case let .mod(val0):
            try container.encode(val0)
            break
        case let .raiseTo(val0):
            try container.encode(val0)
            break
        case let .greater(val0):
            try container.encode(val0)
            break
        case let .less(val0):
            try container.encode(val0)
            break
        case let .equal(val0):
            try container.encode(val0)
            break
        case let .not(val0):
            try container.encode(val0)
            break
        case let .and(val0):
            try container.encode(val0)
            break
        case let .or(val0):
            try container.encode(val0)
            break
        case let .`if`(val0):
            try container.encode(val0)
            break
        case let .raw(val0):
            try container.encode(val0)
            break
        case let .query(val0):
            try container.encode(val0)
            break
        case let .contains(val0):
            try container.encode(val0)
            break
        case let .containsAll(val0):
            try container.encode(val0)
            break
        case let .containsAny(val0):
            try container.encode(val0)
            break
        case let .`where`(val0):
            try container.encode(val0)
            break
        case let .contextValue(val0):
            try container.encode(val0)
            break
        }
    }
}
}
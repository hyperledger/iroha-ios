import Foundation
import IrohaSwiftScale

enum TestEnum: Codable, Equatable {
    case nothing
    case bool(Bool)
    case boolOptional(Bool?)
    case int(Int)
    case intOptional(Int?)
    case int8(Int8)
    case int8Optional(Int8?)
    case int16(Int16)
    case int16Optional(Int16?)
    case int32(Int32)
    case int32Optional(Int32?)
    case int64(Int64)
    case int64Optional(Int64?)
    case uint(UInt)
    case uintOptional(UInt?)
    case uint8(UInt8)
    case uint8Optional(UInt8?)
    case uint16(UInt16)
    case uint16Optional(UInt16?)
    case uint32(UInt32)
    case uint32Optional(UInt32?)
    case uint64(UInt64)
    case uint64Optional(UInt64?)
    case uint128(UInt128)
    case uint128Optional(UInt128?)
    case string(String)
    case stringOptional(String?)
    case array([String])
    case arrayOptional([String]?)
    case dictionary([String: String])
    case dictionaryOptional([String: String]?)
    
    static func index(of case: Self) -> Int {
        switch `case` {
        case .nothing:
            return 0
        case .bool:
            return 1
        case .boolOptional:
            return 2
        case .int:
            return 3
        case .intOptional:
            return 4
        case .int8:
            return 5
        case .int8Optional:
            return 6
        case .int16:
            return 7
        case .int16Optional:
            return 8
        case .int32:
            return 9
        case .int32Optional:
            return 10
        case .int64:
            return 11
        case .int64Optional:
            return 12
        case .uint:
            return 13
        case .uintOptional:
            return 14
        case .uint8:
            return 15
        case .uint8Optional:
            return 16
        case .uint16:
            return 17
        case .uint16Optional:
            return 18
        case .uint32:
            return 19
        case .uint32Optional:
            return 20
        case .uint64:
            return 21
        case .uint64Optional:
            return 22
        case .uint128:
            return 23
        case .uint128Optional:
            return 24
        case .string:
            return 25
        case .stringOptional:
            return 26
        case .array:
            return 27
        case .arrayOptional:
            return 28
        case .dictionary:
            return 29
        case .dictionaryOptional:
            return 30
        }
    }
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let index = try container.decode(Int.self)
        switch index {
        case 0:
            self = .nothing
            break
        case 1:
            let val0 = try container.decode(Bool.self)
            self = .bool(val0)
            break
        case 2:
            let val0 = try container.decode(Bool?.self)
            self = .boolOptional(val0)
            break
        case 3:
            let val0 = try container.decode(Int.self)
            self = .int(val0)
            break
        case 4:
            let val0 = try container.decode(Int?.self)
            self = .intOptional(val0)
            break
        case 5:
            let val0 = try container.decode(Int8.self)
            self = .int8(val0)
            break
        case 6:
            let val0 = try container.decode(Int8?.self)
            self = .int8Optional(val0)
            break
        case 7:
            let val0 = try container.decode(Int16.self)
            self = .int16(val0)
            break
        case 8:
            let val0 = try container.decode(Int16?.self)
            self = .int16Optional(val0)
            break
        case 9:
            let val0 = try container.decode(Int32.self)
            self = .int32(val0)
            break
        case 10:
            let val0 = try container.decode(Int32?.self)
            self = .int32Optional(val0)
            break
        case 11:
            let val0 = try container.decode(Int64.self)
            self = .int64(val0)
            break
        case 12:
            let val0 = try container.decode(Int64?.self)
            self = .int64Optional(val0)
            break
        case 13:
            let val0 = try container.decode(UInt.self)
            self = .uint(val0)
            break
        case 14:
            let val0 = try container.decode(UInt?.self)
            self = .uintOptional(val0)
            break
        case 15:
            let val0 = try container.decode(UInt8.self)
            self = .uint8(val0)
            break
        case 16:
            let val0 = try container.decode(UInt8?.self)
            self = .uint8Optional(val0)
            break
        case 17:
            let val0 = try container.decode(UInt16.self)
            self = .uint16(val0)
            break
        case 18:
            let val0 = try container.decode(UInt16?.self)
            self = .uint16Optional(val0)
            break
        case 19:
            let val0 = try container.decode(UInt32.self)
            self = .uint32(val0)
            break
        case 20:
            let val0 = try container.decode(UInt32?.self)
            self = .uint32Optional(val0)
            break
        case 21:
            let val0 = try container.decode(UInt64.self)
            self = .uint64(val0)
            break
        case 22:
            let val0 = try container.decode(UInt64?.self)
            self = .uint64Optional(val0)
            break
        case 23:
            let val0 = try container.decode(UInt128.self)
            self = .uint128(val0)
            break
        case 24:
            let val0 = try container.decode(UInt128?.self)
            self = .uint128Optional(val0)
            break
        case 25:
            let val0 = try container.decode(String.self)
            self = .string(val0)
            break
        case 26:
            let val0 = try container.decode(String?.self)
            self = .stringOptional(val0)
            break
        case 27:
            let val0 = try container.decode([String].self)
            self = .array(val0)
            break
        case 28:
            let val0 = try container.decode([String]?.self)
            self = .arrayOptional(val0)
            break
        case 29:
            let val0 = try container.decode([String: String].self)
            self = .dictionary(val0)
            break
        case 30:
            let val0 = try container.decode([String: String]?.self)
            self = .dictionaryOptional(val0)
            break
        default:
            fatalError()
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(Self.index(of: self))
        switch self {
        case .nothing:
            break
        case let .bool(val0):
            try container.encode(val0)
            break
        case let .boolOptional(val0):
            try container.encode(val0)
            break
        case let .int(val0):
            try container.encode(val0)
            break
        case let .intOptional(val0):
            try container.encode(val0)
            break
        case let .int8(val0):
            try container.encode(val0)
            break
        case let .int8Optional(val0):
            try container.encode(val0)
            break
        case let .int16(val0):
            try container.encode(val0)
            break
        case let .int16Optional(val0):
            try container.encode(val0)
            break
        case let .int32(val0):
            try container.encode(val0)
            break
        case let .int32Optional(val0):
            try container.encode(val0)
            break
        case let .int64(val0):
            try container.encode(val0)
            break
        case let .int64Optional(val0):
            try container.encode(val0)
            break
        case let .uint(val0):
            try container.encode(val0)
            break
        case let .uintOptional(val0):
            try container.encode(val0)
            break
        case let .uint8(val0):
            try container.encode(val0)
            break
        case let .uint8Optional(val0):
            try container.encode(val0)
            break
        case let .uint16(val0):
            try container.encode(val0)
            break
        case let .uint16Optional(val0):
            try container.encode(val0)
            break
        case let .uint32(val0):
            try container.encode(val0)
            break
        case let .uint32Optional(val0):
            try container.encode(val0)
            break
        case let .uint64(val0):
            try container.encode(val0)
            break
        case let .uint64Optional(val0):
            try container.encode(val0)
            break
        case let .uint128(val0):
            try container.encode(val0)
            break
        case let .uint128Optional(val0):
            try container.encode(val0)
            break
        case let .string(val0):
            try container.encode(val0)
            break
        case let .stringOptional(val0):
            try container.encode(val0)
            break
        case let .array(val0):
            try container.encode(val0)
            break
        case let .arrayOptional(val0):
            try container.encode(val0)
            break
        case let .dictionary(val0):
            try container.encode(val0)
            break
        case let .dictionaryOptional(val0):
            try container.encode(val0)
            break
        }
    }
}

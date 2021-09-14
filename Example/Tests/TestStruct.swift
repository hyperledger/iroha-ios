import Foundation
import IrohaSwiftScale

struct TestStruct: Codable, Equatable, Hashable {
    var boolFalse: Bool
    var boolTrue: Bool
    var boolTrueOptional: Bool?
    var boolFalseOptional: Bool?
    var boolNil: Bool? = nil
    var int: Int
    var intOptional: Int?
    var intNil: Int? = nil
    var int8: Int8
    var int8Optional: Int8?
    var int8Nil: Int8? = nil
    var int16: Int16
    var int16Optional: Int16?
    var int16Nil: Int16? = nil
    var int32: Int32
    var int32Optional: Int32?
    var int32Nil: Int32? = nil
    var int64: Int64
    var int64Optional: Int64?
    var int64Nil: Int64? = nil
    var uint: UInt
    var uintOptional: UInt?
    var uintNil: UInt? = nil
    var uint8: UInt8
    var uint8Optional: UInt8?
    var uint8Nil: UInt8? = nil
    var uint16: UInt16
    var uint16Optional: UInt16?
    var uint16Nil: UInt16? = nil
    var uint32: UInt32
    var uint32Optional: UInt32?
    var uint32Nil: UInt32? = nil
    var uint64: UInt64
    var uint64Optional: UInt64?
    var uint64Nil: UInt64? = nil
    var uint128: UInt128
    var uint128Optional: UInt128?
    var uint128Nil: UInt128? = nil
    var string: String
    var stringOptional: String?
    var stringNil: String? = nil
    var array: [String]
    var arrayOptional: [String]?
    var arrayNil: [String]? = nil
    var dictionary: [String: String]
    var dictionaryOptional: [String: String]?
    var dictionaryNil: [String: String]? = nil
}

import XCTest
import IrohaSwiftScale

class TestSCALE: XCTestCase {
    
    private let encoder = ScaleEncoder()
    private let decoder = ScaleDecoder()
    
    func testOptional() throws {
        do {
            let value: String? = nil
            let data = try encoder.encode(value)
            let decoded = try decoder.decode(type(of: value), from: data)
            XCTAssertEqual(value, decoded)
        }
        do {
            let value: String? = "Non nil"
            let data = try encoder.encode(value)
            let decoded = try decoder.decode(type(of: value), from: data)
            XCTAssertEqual(value, decoded)
        }
    }
    
    func testBool() throws {
        do {
            let value = true
            let data = try encoder.encode(value)
            let decoded = try decoder.decode(type(of: value), from: data)
            XCTAssertEqual(value, decoded)
        }
        do {
            let value = false
            let data = try encoder.encode(value)
            let decoded = try decoder.decode(type(of: value), from: data)
            XCTAssertEqual(value, decoded)
        }
        do {
            let value: Bool? = true
            let data = try encoder.encode(value)
            let decoded = try decoder.decode(type(of: value), from: data)
            XCTAssertEqual(value, decoded)
        }
        do {
            let value: Bool? = false
            let data = try encoder.encode(value)
            let decoded = try decoder.decode(type(of: value), from: data)
            XCTAssertEqual(value, decoded)
        }
        do {
            let value: Bool? = nil
            let data = try encoder.encode(value)
            let decoded = try decoder.decode(type(of: value), from: data)
            XCTAssertEqual(value, decoded)
        }
    }
    
    func testCompact() throws {
        func range<T: FixedWidthInteger>(for type: T.Type) -> Range<UInt128> {
            let divider = type == UInt128.self ? 4 : 2
            let begin = type == UInt8.self ? 0 : 1 << (type.bitWidth/divider - 2)
            let end = UInt128(1) << (type.bitWidth - 2)
            return UInt128(begin)..<end
        }
        
        let iterations = 1000
        
        // 8bit
        for _ in 0..<iterations {
            let value = Compact(UInt128.random(in: range(for: UInt8.self)))
            let data = try encoder.encode(value)
            let decoded = try decoder.decode(type(of: value), from: data)
            XCTAssertEqual(value, decoded)
        }
        
        // 16bit
        for _ in 0..<iterations {
            let value = Compact(UInt128.random(in: range(for: UInt16.self)))
            let data = try encoder.encode(value)
            let decoded = try decoder.decode(type(of: value), from: data)
            XCTAssertEqual(value, decoded)
        }
        
        // 32bit
        for _ in 0..<iterations {
            let value = Compact(UInt128.random(in: range(for: UInt32.self)))
            let data = try encoder.encode(value)
            let decoded = try decoder.decode(type(of: value), from: data)
            XCTAssertEqual(value, decoded)
        }
        
        // 64bit
        for _ in 0..<iterations {
            let value = Compact(UInt128.random(in: range(for: UInt64.self)))
            let data = try encoder.encode(value)
            let decoded = try decoder.decode(type(of: value), from: data)
            XCTAssertEqual(value, decoded)
        }
        
        // 128bit
        for _ in 0..<iterations {
            let value = Compact(UInt128.random(in: range(for: UInt128.self)))
            let data = try encoder.encode(value)
            let decoded = try decoder.decode(type(of: value), from: data)
            XCTAssertEqual(value, decoded)
        }
    }
    
    func testIntegers() throws {
        func integerTestValues<T: FixedWidthInteger>(of type: T.Type, count: UInt = 1000) -> [T] {
            var array = [T.min, T.max]
            for _ in 0..<count {
                array.append(T.random(in: T.min...T.max))
            }
            
            return array
        }
        
        // Int
        do {
            let values = integerTestValues(of: Int.self)
            for value in values {
                let data = try encoder.encode(value)
                let decoded = try decoder.decode(type(of: value), from: data)
                XCTAssertEqual(value, decoded)
            }
        }
        
        // Int8
        do {
            let values = integerTestValues(of: Int8.self)
            for value in values {
                let data = try encoder.encode(value)
                let decoded = try decoder.decode(type(of: value), from: data)
                XCTAssertEqual(value, decoded)
            }
        }
        
        // Int16
        do {
            let values = integerTestValues(of: Int16.self)
            for value in values {
                let data = try encoder.encode(value)
                let decoded = try decoder.decode(type(of: value), from: data)
                XCTAssertEqual(value, decoded)
            }
        }
        
        // Int32
        do {
            let values = integerTestValues(of: Int32.self)
            for value in values {
                let data = try encoder.encode(value)
                let decoded = try decoder.decode(type(of: value), from: data)
                XCTAssertEqual(value, decoded)
            }
        }
        
        // Int64
        do {
            let values = integerTestValues(of: Int64.self)
            for value in values {
                let data = try encoder.encode(value)
                let decoded = try decoder.decode(type(of: value), from: data)
                XCTAssertEqual(value, decoded)
            }
        }
        
        // UInt
        do {
            let values = integerTestValues(of: UInt.self)
            for value in values {
                let data = try encoder.encode(value)
                let decoded = try decoder.decode(type(of: value), from: data)
                XCTAssertEqual(value, decoded)
            }
        }
        
        // UInt8
        do {
            let values = integerTestValues(of: UInt8.self)
            for value in values {
                let data = try encoder.encode(value)
                let decoded = try decoder.decode(type(of: value), from: data)
                XCTAssertEqual(value, decoded)
            }
        }
        
        // UInt16
        do {
            let values = integerTestValues(of: UInt16.self)
            for value in values {
                let data = try encoder.encode(value)
                let decoded = try decoder.decode(type(of: value), from: data)
                XCTAssertEqual(value, decoded)
            }
        }
        
        // UInt32
        do {
            let values = integerTestValues(of: UInt32.self)
            for value in values {
                let data = try encoder.encode(value)
                let decoded = try decoder.decode(type(of: value), from: data)
                XCTAssertEqual(value, decoded)
            }
        }
        
        // UInt64
        do {
            let values = integerTestValues(of: UInt64.self)
            for value in values {
                let data = try encoder.encode(value)
                let decoded = try decoder.decode(type(of: value), from: data)
                XCTAssertEqual(value, decoded)
            }
        }
        
        // UInt128
        do {
            let values = integerTestValues(of: UInt128.self)
            for value in values {
                let data = try encoder.encode(value)
                let decoded = try decoder.decode(type(of: value), from: data)
                XCTAssertEqual(value, decoded)
            }
        }
    }
    
    func testStrings() throws {
        let scalars = (UInt8.min...UInt8.max).map { UnicodeScalar($0) }
        let amountOfStrings = 1000
        let amountOfCharactersPerString = 1000
        for _ in 0..<amountOfStrings {
            var value = ""
            for _ in 0..<amountOfCharactersPerString {
                guard let scalar = scalars.randomElement() else {
                    XCTFail()
                    return
                }
                
                value.append(Character(scalar))
            }
            
            let data = try encoder.encode(value)
            let decoded = try decoder.decode(type(of: value), from: data)
            XCTAssertEqual(value, decoded)
        }
    }
    
    func testArrays() throws {
        do {
            let value: [String?] = ["First", "Second", "Third", nil, "Fifth"]
            let data = try encoder.encode(value)
            let decoded = try decoder.decode(type(of: value), from: data)
            XCTAssertEqual(value, decoded)
        }
        do {
            let value = ["First", "Second", "Third", "Fourth", "Fifth"]
            let data = try encoder.encode(value)
            let decoded = try decoder.decode(type(of: value), from: data)
            XCTAssertEqual(value, decoded)
        }
        do {
            let value: [String]? = ["First", "Second", "Third", "Fourth", "Fifth"]
            let data = try encoder.encode(value)
            let decoded = try decoder.decode(type(of: value), from: data)
            XCTAssertEqual(value, decoded)
        }
        do {
            let value: [String?]? = ["First", "Second", "Third", nil, "Fifth"]
            let data = try encoder.encode(value)
            let decoded = try decoder.decode(type(of: value), from: data)
            XCTAssertEqual(value, decoded)
        }
    }
    
    func testDictionaries() throws {
        do {
            let value: [String: String?] = ["123": nil, "qwe": "DictionaryValue2"]
            let data = try encoder.encode(value)
            let decoded = try decoder.decode(type(of: value), from: data)
            XCTAssertEqual(value, decoded)
        }
        do {
            let value = ["123": "DictionaryValue1", "qwe": "DictionaryValue2"]
            let data = try encoder.encode(value)
            let decoded = try decoder.decode(type(of: value), from: data)
            XCTAssertEqual(value, decoded)
        }
        do {
            let value: [String: String]? = ["123": "DictionaryValue1", "qwe": "DictionaryValue2"]
            let data = try encoder.encode(value)
            let decoded = try decoder.decode(type(of: value), from: data)
            XCTAssertEqual(value, decoded)
        }
        do {
            let value: [String: String?]? = ["123": nil, "qwe": "DictionaryValue2"]
            let data = try encoder.encode(value)
            let decoded = try decoder.decode(type(of: value), from: data)
            XCTAssertEqual(value, decoded)
        }
    }
    
    func testStructs() throws {
        let value = TestStruct(
            boolFalse: false,
            boolTrue: true,
            boolTrueOptional: true,
            boolFalseOptional: false,
            int: Int.random(in: 0...100),
            intOptional: Int.random(in: 0...100),
            int8: Int8.random(in: 0...100),
            int8Optional: Int8.random(in: 0...100),
            int16: Int16.random(in: 0...100),
            int16Optional: Int16.random(in: 0...100),
            int32: Int32.random(in: 0...100),
            int32Optional: Int32.random(in: 0...100),
            int64: Int64.random(in: 0...100),
            int64Optional: Int64.random(in: 0...100),
            uint: UInt.random(in: 0...100),
            uintOptional: UInt.random(in: 0...100),
            uint8: UInt8.random(in: 0...100),
            uint8Optional: UInt8.random(in: 0...100),
            uint16: UInt16.random(in: 0...100),
            uint16Optional: UInt16.random(in: 0...100),
            uint32: UInt32.random(in: 0...100),
            uint32Optional: UInt32.random(in: 0...100),
            uint64: UInt64.random(in: 0...100),
            uint64Optional: UInt64.random(in: 0...100),
            uint128: UInt128.random(in: 0...100),
            uint128Optional: UInt128.random(in: 0...100),
            string: "String",
            stringOptional: "String",
            array: ["First", "Second"],
            arrayOptional: ["First", "Second"],
            dictionary: ["Key": "Value"],
            dictionaryOptional: ["Key": "Value"]
        )
        let data = try encoder.encode(value)
        let decoded = try decoder.decode(type(of: value), from: data)
        XCTAssertEqual(value, decoded)
    }
    
    func testEnums() throws {
        let values: [TestEnum] = [
            .nothing,

            .bool(true),
            .bool(false),
            .boolOptional(nil),
            .boolOptional(true),
            .boolOptional(false),

            .int(Int.random(in: 0...100)),
            .intOptional(nil),
            .intOptional(Int.random(in: 0...100)),

            .int8(Int8.random(in: 0...100)),
            .int8Optional(nil),
            .int8Optional(Int8.random(in: 0...100)),

            .int16(Int16.random(in: 0...100)),
            .int16Optional(nil),
            .int16Optional(Int16.random(in: 0...100)),

            .int32(Int32.random(in: 0...100)),
            .int32Optional(nil),
            .int32Optional(Int32.random(in: 0...100)),

            .int64(Int64.random(in: 0...100)),
            .int64Optional(nil),
            .int64Optional(Int64.random(in: 0...100)),

            .uint(UInt.random(in: 0...100)),
            .uintOptional(nil),
            .uintOptional(UInt.random(in: 0...100)),

            .uint8(UInt8.random(in: 0...100)),
            .uint8Optional(nil),
            .uint8Optional(UInt8.random(in: 0...100)),

            .uint16(UInt16.random(in: 0...100)),
            .uint16Optional(nil),
            .uint16Optional(UInt16.random(in: 0...100)),

            .uint32(UInt32.random(in: 0...100)),
            .uint32Optional(nil),
            .uint32Optional(UInt32.random(in: 0...100)),

            .uint64(UInt64.random(in: 0...100)),
            .uint64Optional(nil),
            .uint64Optional(UInt64.random(in: 0...100)),

            .uint128(UInt128.random(in: 0...100)),
            .uint128Optional(nil),
            .uint128Optional(UInt128.random(in: 0...100)),

            .string("String"),
            .stringOptional(nil),
            .stringOptional("String"),

            .array(["First", "Second"]),
            .arrayOptional(nil),
            .arrayOptional(["First", "Second"]),

            .dictionary(["Key": "Value"]),
            .dictionaryOptional(nil),
            .dictionaryOptional(["Key": "Value"]),
        ]
        
        for value in values {
            let data = try encoder.encode(value)
            let decoded = try decoder.decode(TestEnum.self, from: data)
            XCTAssertEqual(value, decoded)
        }
    }
    
    func testTupleStructs() throws {
        let value = TestTupleStruct(16, "Foo", UInt128("273846587234658723"), true)
        let data = try encoder.encode(value)
        let decoded = try decoder.decode(TestTupleStruct.self, from: data)
        XCTAssertEqual(value._0, decoded._0)
        XCTAssertEqual(value._1, decoded._1)
        XCTAssertEqual(value._2, decoded._2)
        XCTAssertEqual(value._3, decoded._3)
    }
}

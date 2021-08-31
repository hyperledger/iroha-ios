import IrohaSwiftScale
import IrohaSwiftSDK
import XCTest

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
    
    func testConcreteBool() throws {
        let testCases: [(Bool?, Data)] = [
            (nil, Data([0])),
            (true, Data([1])),
            (false, Data([2]))
        ]

        for testCase in testCases {
            let actualData = try ScaleEncoder().encode(testCase.0)
            XCTAssertEqual(actualData, testCase.1)
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
    
    func testConcreteCompact() throws {
        let testCases: [(Compact<UInt128>, Data)] = [
            (Compact(0), Data([0])),
            (Compact(1), Data([4])),
            (Compact(63), Data([252])),
            (Compact(64), Data([1, 1])),
            (Compact(255), Data([253, 3])),
            (Compact(511), Data([253, 7])),
            (Compact(16383), Data([253, 255])),
            (Compact(16384), Data([2, 0, 1, 0])),
            (Compact(65535), Data([254, 255, 3, 0])),
            (Compact(1073741823), Data([254, 255, 255, 255])),
            (Compact(1073741824), Data([3, 0, 0, 0, 64])),
            (Compact(4592230960395125066), Data([19, 74, 1, 231, 80, 186, 225, 186, 63])),
        ]

        for testCase in testCases {
            let actualData = try encoder.encode(testCase.0)
            XCTAssertEqual(actualData, testCase.1)
            let decoded = try decoder.decode(Compact<UInt128>.self, from: actualData)
            XCTAssertEqual(decoded.value, testCase.0.value)
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
    
    func testSubmitQueryResponse() throws {
        let responseBytes: [UInt8] = [3, 8, 5, 4, 28, 103, 101, 110, 101, 115, 105, 115, 4, 28, 103, 101, 110, 101, 115, 105, 115, 28, 103, 101, 110, 101, 115, 105, 115, 28, 103, 101, 110, 101, 115, 105, 115, 28, 103, 101, 110, 101, 115, 105, 115, 0, 4, 28, 101, 100, 50, 53, 53, 49, 57, 128, 114, 51, 191, 200, 157, 203, 214, 140, 25, 253, 230, 206, 97, 88, 34, 82, 152, 236, 17, 49, 182, 161, 48, 209, 174, 180, 84, 193, 171, 81, 131, 192, 0, 17, 19, 92, 116, 114, 97, 110, 115, 97, 99, 116, 105, 111, 110, 95, 115, 105, 103, 110, 97, 116, 111, 114, 105, 101, 115, 19, 76, 97, 99, 99, 111, 117, 110, 116, 95, 115, 105, 103, 110, 97, 116, 111, 114, 105, 101, 115, 0, 0, 5, 4, 40, 119, 111, 110, 100, 101, 114, 108, 97, 110, 100, 4, 20, 97, 108, 105, 99, 101, 40, 119, 111, 110, 100, 101, 114, 108, 97, 110, 100, 20, 97, 108, 105, 99, 101, 40, 119, 111, 110, 100, 101, 114, 108, 97, 110, 100, 4, 16, 114, 111, 115, 101, 40, 119, 111, 110, 100, 101, 114, 108, 97, 110, 100, 20, 97, 108, 105, 99, 101, 40, 119, 111, 110, 100, 101, 114, 108, 97, 110, 100, 16, 114, 111, 115, 101, 40, 119, 111, 110, 100, 101, 114, 108, 97, 110, 100, 20, 97, 108, 105, 99, 101, 40, 119, 111, 110, 100, 101, 114, 108, 97, 110, 100, 0, 13, 0, 0, 0, 4, 28, 101, 100, 50, 53, 53, 49, 57, 128, 229, 85, 209, 148, 232, 130, 45, 163, 90, 197, 65, 206, 158, 236, 139, 69, 5, 143, 77, 41, 77, 148, 38, 239, 151, 186, 146, 105, 135, 102, 247, 211, 0, 17, 19, 92, 116, 114, 97, 110, 115, 97, 99, 116, 105, 111, 110, 95, 115, 105, 103, 110, 97, 116, 111, 114, 105, 101, 115, 19, 76, 97, 99, 99, 111, 117, 110, 116, 95, 115, 105, 103, 110, 97, 116, 111, 114, 105, 101, 115, 0, 4, 16, 114, 111, 115, 101, 40, 119, 111, 110, 100, 101, 114, 108, 97, 110, 100, 0, 16, 114, 111, 115, 101, 40, 119, 111, 110, 100, 101, 114, 108, 97, 110, 100, 28, 103, 101, 110, 101, 115, 105, 115, 28, 103, 101, 110, 101, 115, 105, 115]
        let responseData = Data(responseBytes)
        
        _ = try decoder.decode(IrohaDataModelQuery.QueryResult.self, from: responseData)
    }
}

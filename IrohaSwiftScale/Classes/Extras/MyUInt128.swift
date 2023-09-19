//
//  MyUInt128.swift
//  IrohaSwiftScale
//
//  Created by Nikolai Zhukov on 9/18/23.
//

import Foundation

public struct MyUint128: Codable {
    enum CodingKeys: CodingKey {
        case uint64
        case stub
    }

    private enum Constants {
        static let stub: UInt64 = 0
    }

    private let uint64: UInt64
    private let stub: UInt64

    public init(uint64: UInt64) {
        self.uint64 = uint64
        self.stub = 0
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.uint64 = try container.decode(UInt64.self, forKey: .uint64)
        self.stub = try container.decode(UInt64.self, forKey: .stub)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(uint64)
        try container.encode(stub)
    }

}

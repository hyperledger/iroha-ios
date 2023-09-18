//
//  Hash.swift
//  IrohaSwiftScale
//
//  Created by Nikolai Zhukov on 9/18/23.
//

import Blake2
import Foundation

public extension Data {
    func blakeHash() throws -> Data {
        var hash = try Blake2.hash(.b2b, size: 32, data: self)
        var hashArray: [UInt8] = Array(hash)
        hashArray[hashArray.count - 1] = hashArray[hashArray.count - 1] | 1
        hash = Data(hashArray)

        return hash
    }
}

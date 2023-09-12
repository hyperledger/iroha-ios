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

private let arraySize = 32
    
// MARK: Array32
    
public struct Array32<Element: Codable> {
    
    enum Error: LocalizedError {
        case invalidInputSequenceLength(Int, Int)
    
        var errorDescription: String? {
            switch self {
            case let .invalidInputSequenceLength(providedSize, requiredSize):
                return "Invalid input sequence length: \(providedSize), length should be: \(requiredSize)"
        }
        }
    }
    
    public static var fixedSize: Int { arraySize }

    public var data: Data {
        Data(bytes: array, count: array.count)
    }
    
    private var array: Array<Element>
    
    public init<S: Sequence>(_ sequence: S) throws where S.Iterator.Element == Element {
        let array = sequence.map { $0 }
        guard array.count == arraySize else { throw Error.invalidInputSequenceLength(arraySize, array.count) }
        self.array = array
    }
}
    
// MARK: - Equatable
    
extension Array32: Equatable where Element: Equatable {
    public static func ==(lhs: Array32, rhs: Array32) -> Bool {
        lhs.array == rhs.array
    }
}
    
// MARK: - CustomStringConvertible
    
extension Array32: CustomStringConvertible {
    public var description: String { array.description }
}
    
// MARK: - Sequence
    
extension Array32: Sequence {
    public typealias Iterator = IndexingIterator<Array<Element>>
    
    public func makeIterator() -> Iterator {
        array.makeIterator()
    }
}
    
// MARK: - Collection
    
extension Array32: Collection {
    public typealias Index = Array<Element>.Index
    
    public var startIndex: Index { array.startIndex }
    public var endIndex: Index { array.endIndex }
    
    public subscript(position: Index) -> Element {
        get { array[position] }
        set { array[position] = newValue }
    }
    
    public func index(after i: Index) -> Index {
        array.index(after: i)
    }
}
    
// MARK: - Codable
    
extension Array32: Codable {
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let array = try (0..<arraySize).map { _ in try container.decode(Element.self) }
        try self.init(array)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        for element in array {
            try container.encode(element)
        }
    }
}

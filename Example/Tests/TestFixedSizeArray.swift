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

private let arraySize = 4

struct Array4<Element: Codable> {
    
    enum Error: LocalizedError {
        case invalidInputSequenceLength(Int, Int)
        
        var errorDescription: String? {
            switch self {
            case let .invalidInputSequenceLength(providedSize, requiredSize):
                return "Invalid input sequence length: \(providedSize), length should be: \(requiredSize)"
            }
        }
    }
    
    static var fixedSize: Int { arraySize }
    
    private var array: Array<Element>

    init<S: Sequence>(_ sequence: S) throws where S.Iterator.Element == Element {
        let array = sequence.map { $0 }
        guard array.count == arraySize else { throw Error.invalidInputSequenceLength(arraySize, array.count) }
        self.array = array
    }
}

extension Array4: CustomStringConvertible {
    var description: String { array.description }
}

extension Array4: Sequence {
    typealias Iterator = IndexingIterator<Array<Element>>
    
    func makeIterator() -> Iterator {
        array.makeIterator()
    }
}

extension Array4: Collection {
    typealias Index = Array<Element>.Index
    
    var startIndex: Index { array.startIndex }
    var endIndex: Index { array.endIndex }
    
    subscript(position: Index) -> Element {
        get { array[position] }
        set { array[position] = newValue }
    }
    
    func index(after i: Index) -> Index {
        array.index(after: i)
    }
}

extension Array4: Codable {
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let array = try (0..<arraySize).map { _ in try container.decode(Element.self) }
        try self.init(array)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        for element in array {
            try container.encode(element)
        }
    }
}

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

extension IrohaDataModelIsi {
public indirect enum Instruction: Codable {
    
    case register(IrohaDataModelIsi.RegisterBox)
    case unregister(IrohaDataModelIsi.UnregisterBox)
    case mint(IrohaDataModelIsi.MintBox)
    case burn(IrohaDataModelIsi.BurnBox)
    case transfer(IrohaDataModelIsi.TransferBox)
    case `if`(IrohaDataModelIsi.If)
    case pair(IrohaDataModelIsi.Pair)
    case sequence(IrohaDataModelIsi.SequenceBox)
    case fail(IrohaDataModelIsi.FailBox)
    case setKeyValue(IrohaDataModelIsi.SetKeyValueBox)
    case removeKeyValue(IrohaDataModelIsi.RemoveKeyValueBox)
    case grant(IrohaDataModelIsi.GrantBox)
    
    // MARK: - For Codable purpose
    
    static func index(of case: Self) -> Int {
        switch `case` {
            case .register:
                return 0
            case .unregister:
                return 1
            case .mint:
                return 2
            case .burn:
                return 3
            case .transfer:
                return 4
            case .`if`:
                return 5
            case .pair:
                return 6
            case .sequence:
                return 7
            case .fail:
                return 8
            case .setKeyValue:
                return 9
            case .removeKeyValue:
                return 10
            case .grant:
                return 11
        }
    }
    
    // MARK: - Decodable
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let index = try container.decode(Int.self)
        switch index {
        case 0:
            let val0 = try container.decode(IrohaDataModelIsi.RegisterBox.self)
            self = .register(val0)
            break
        case 1:
            let val0 = try container.decode(IrohaDataModelIsi.UnregisterBox.self)
            self = .unregister(val0)
            break
        case 2:
            let val0 = try container.decode(IrohaDataModelIsi.MintBox.self)
            self = .mint(val0)
            break
        case 3:
            let val0 = try container.decode(IrohaDataModelIsi.BurnBox.self)
            self = .burn(val0)
            break
        case 4:
            let val0 = try container.decode(IrohaDataModelIsi.TransferBox.self)
            self = .transfer(val0)
            break
        case 5:
            let val0 = try container.decode(IrohaDataModelIsi.If.self)
            self = .`if`(val0)
            break
        case 6:
            let val0 = try container.decode(IrohaDataModelIsi.Pair.self)
            self = .pair(val0)
            break
        case 7:
            let val0 = try container.decode(IrohaDataModelIsi.SequenceBox.self)
            self = .sequence(val0)
            break
        case 8:
            let val0 = try container.decode(IrohaDataModelIsi.FailBox.self)
            self = .fail(val0)
            break
        case 9:
            let val0 = try container.decode(IrohaDataModelIsi.SetKeyValueBox.self)
            self = .setKeyValue(val0)
            break
        case 10:
            let val0 = try container.decode(IrohaDataModelIsi.RemoveKeyValueBox.self)
            self = .removeKeyValue(val0)
            break
        case 11:
            let val0 = try container.decode(IrohaDataModelIsi.GrantBox.self)
            self = .grant(val0)
            break
        default:
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown index \(index)")
        }
    }
    
    // MARK: - Encodable
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(Instruction.index(of: self))
        switch self {
        case let .register(val0):
            try container.encode(val0)
            break
        case let .unregister(val0):
            try container.encode(val0)
            break
        case let .mint(val0):
            try container.encode(val0)
            break
        case let .burn(val0):
            try container.encode(val0)
            break
        case let .transfer(val0):
            try container.encode(val0)
            break
        case let .`if`(val0):
            try container.encode(val0)
            break
        case let .pair(val0):
            try container.encode(val0)
            break
        case let .sequence(val0):
            try container.encode(val0)
            break
        case let .fail(val0):
            try container.encode(val0)
            break
        case let .setKeyValue(val0):
            try container.encode(val0)
            break
        case let .removeKeyValue(val0):
            try container.encode(val0)
            break
        case let .grant(val0):
            try container.encode(val0)
            break
        }
    }
}
}
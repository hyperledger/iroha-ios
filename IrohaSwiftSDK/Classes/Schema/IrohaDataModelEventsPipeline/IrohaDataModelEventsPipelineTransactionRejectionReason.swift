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

extension IrohaDataModelEventsPipeline {
public indirect enum TransactionRejectionReason: Codable {
    
    case notPermitted(IrohaDataModelEventsPipeline.NotPermittedFail)
    case unsatisfiedSignatureCondition(IrohaDataModelEventsPipeline.UnsatisfiedSignatureConditionFail)
    case instructionExecution(IrohaDataModelEventsPipeline.InstructionExecutionFail)
    case signatureVerification(IrohaDataModelEventsPipeline.SignatureVerificationFail)
    case unexpectedGenesisAccountSignature
    
    // MARK: - For Codable purpose
    
    static func index(of case: Self) -> Int {
        switch `case` {
            case .notPermitted:
                return 0
            case .unsatisfiedSignatureCondition:
                return 1
            case .instructionExecution:
                return 2
            case .signatureVerification:
                return 3
            case .unexpectedGenesisAccountSignature:
                return 4
        }
    }
    
    // MARK: - Decodable
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let index = try container.decode(Int.self)
        switch index {
        case 0:
            let val0 = try container.decode(IrohaDataModelEventsPipeline.NotPermittedFail.self)
            self = .notPermitted(val0)
            break
        case 1:
            let val0 = try container.decode(IrohaDataModelEventsPipeline.UnsatisfiedSignatureConditionFail.self)
            self = .unsatisfiedSignatureCondition(val0)
            break
        case 2:
            let val0 = try container.decode(IrohaDataModelEventsPipeline.InstructionExecutionFail.self)
            self = .instructionExecution(val0)
            break
        case 3:
            let val0 = try container.decode(IrohaDataModelEventsPipeline.SignatureVerificationFail.self)
            self = .signatureVerification(val0)
            break
        case 4:
            
            self = .unexpectedGenesisAccountSignature
            break
        default:
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown index \(index)")
        }
    }
    
    // MARK: - Encodable
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(TransactionRejectionReason.index(of: self))
        switch self {
        case let .notPermitted(val0):
            try container.encode(val0)
            break
        case let .unsatisfiedSignatureCondition(val0):
            try container.encode(val0)
            break
        case let .instructionExecution(val0):
            try container.encode(val0)
            break
        case let .signatureVerification(val0):
            try container.encode(val0)
            break
        case .unexpectedGenesisAccountSignature:
            
            break
        }
    }
}
}
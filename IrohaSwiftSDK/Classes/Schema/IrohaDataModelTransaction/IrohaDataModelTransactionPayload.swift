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

extension IrohaDataModelTransaction {
public struct Payload: Codable {
    
    public var accountId: IrohaDataModelAccount.Id
    public var instructions: [IrohaDataModelIsi.Instruction]
    public var creationTime: UInt64
    public var timeToLiveMs: UInt64
    public var metadata: [String: IrohaDataModel.Value]
    
    public init(accountId: IrohaDataModelAccount.Id, instructions: [IrohaDataModelIsi.Instruction], creationTime: UInt64, timeToLiveMs: UInt64, metadata: [String: IrohaDataModel.Value]) {
    self.accountId = accountId
        self.instructions = instructions
        self.creationTime = creationTime
        self.timeToLiveMs = timeToLiveMs
        self.metadata = metadata
    }
}
}
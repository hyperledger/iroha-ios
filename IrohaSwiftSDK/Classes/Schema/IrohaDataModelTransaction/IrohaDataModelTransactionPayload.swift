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
        public var executable: IrohaDataModelIsi.Executable
        public var creationTime: UInt64
        public var timeToLiveMs: UInt64
        public var nonce: UInt32?
        public var metadata: [IrohaDataModelName]
        
        public init(
            accountId: IrohaDataModelAccount.Id, 
            executable: IrohaDataModelIsi.Executable,
            creationTime: UInt64, 
            timeToLiveMs: UInt64, 
            nonce: UInt32?, 
            metadata: [IrohaDataModelName] = []
        ) {
            self.accountId = accountId
            self.executable = executable
            self.creationTime = creationTime
            self.timeToLiveMs = timeToLiveMs
            self.nonce = nonce
            self.metadata = metadata
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: IrohaDataModelTransaction.Payload.CodingKeys.self)
            try container.encode(self.accountId, forKey: IrohaDataModelTransaction.Payload.CodingKeys.accountId)
            try container.encode(self.executable, forKey: IrohaDataModelTransaction.Payload.CodingKeys.executable)
            try container.encode(self.creationTime, forKey: IrohaDataModelTransaction.Payload.CodingKeys.creationTime)
            try container.encode(self.timeToLiveMs, forKey: IrohaDataModelTransaction.Payload.CodingKeys.timeToLiveMs)
            try container.encodeIfPresent(self.nonce, forKey: IrohaDataModelTransaction.Payload.CodingKeys.nonce)
            try container.encode(self.metadata, forKey: IrohaDataModelTransaction.Payload.CodingKeys.metadata)

            debugPrint(#function)
        }
    }
}

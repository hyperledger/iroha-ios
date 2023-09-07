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
import ScaleCodec

extension IrohaDataModelTransaction {
    public struct Payload: Swift.Codable {
        
        public var accountId: IrohaDataModelAccount.Id
        public var executable: IrohaDataModelIsi.Executable
        public var creationTime: UInt64
        public var timeToLiveMs: UInt64
        public var nonce: Int64?
        public var metadata: [String: IrohaDataModel.Value]
        
        public init(
            accountId: IrohaDataModelAccount.Id, 
            executable: IrohaDataModelIsi.Executable,
            creationTime: UInt64, 
            timeToLiveMs: UInt64, 
            nonce: Int64?, 
            metadata: [String: IrohaDataModel.Value]
        ) {
            self.accountId = accountId
            self.executable = executable
            self.creationTime = creationTime
            self.timeToLiveMs = timeToLiveMs
            self.nonce = nonce
            self.metadata = metadata
        }
    }
}

extension IrohaDataModelTransaction.Payload: ScaleCodec.Encodable {
    public func encode<E>(in encoder: inout E) throws where E : ScaleCodec.Encoder {
        try encoder.encode(accountId)
        try encoder.encode(executable)

        // todo: доделать остальные
    }
}

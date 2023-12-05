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
    public struct Payload: Swift.Codable {
        
        public var creationTimeMs: UInt64
        public var authority: IrohaDataModelAccount.Id
        public var executable: IrohaDataModelIsi.Executable
        public var timeToLiveMs: UInt64?
        public var nonce: UInt32?
        public var metadata: [IrohaMetadataItem]
        
        public init(
            creationTimeMs: UInt64,
            authority: IrohaDataModelAccount.Id,
            executable: IrohaDataModelIsi.Executable,
            timeToLiveMs: UInt64?,
            nonce: UInt32?,
            metadata: [IrohaMetadataItem]
        ) {
            self.creationTimeMs = creationTimeMs
            self.authority = authority
            self.executable = executable
            self.timeToLiveMs = timeToLiveMs
            self.nonce = nonce
            self.metadata = metadata
        }
    }
}
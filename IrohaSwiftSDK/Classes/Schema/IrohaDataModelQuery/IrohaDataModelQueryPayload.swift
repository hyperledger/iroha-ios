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

extension IrohaDataModelQuery {
    public struct Payload: Swift.Codable {
        
        public var timestampMs: IrohaSwiftScale.Compact<UInt64>
        public var query: IrohaDataModelQuery.QueryBox
        public var accountId: IrohaDataModelAccount.Id
        
        public init(
            timestampMs: IrohaSwiftScale.Compact<UInt64>,
            query: IrohaDataModelQuery.QueryBox, 
            accountId: IrohaDataModelAccount.Id
        ) {
            self.timestampMs = timestampMs
            self.query = query
            self.accountId = accountId
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: IrohaDataModelQuery.Payload.CodingKeys.self)
            try container.encode(self.timestampMs, forKey: IrohaDataModelQuery.Payload.CodingKeys.timestampMs)
            // todo: check
            try container.encode([0, 0, 0, 0, 0, 0, 0, 0], forKey: IrohaDataModelQuery.Payload.CodingKeys.timestampMs)
            try container.encode(self.query, forKey: IrohaDataModelQuery.Payload.CodingKeys.query)
            try container.encode(self.accountId, forKey: IrohaDataModelQuery.Payload.CodingKeys.accountId)
        }
    }
}

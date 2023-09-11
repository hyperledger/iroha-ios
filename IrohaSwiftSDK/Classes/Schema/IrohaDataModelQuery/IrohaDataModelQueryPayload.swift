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

extension IrohaDataModelQuery {
    public struct Payload: Swift.Codable {
        
        public var timestampMs: IrohaSwiftScale.Compact<IrohaSwiftScale.UInt128>
        public var query: IrohaDataModelQuery.QueryBox
        public var accountId: IrohaDataModelAccount.Id
        
        public init(
            timestampMs: IrohaSwiftScale.Compact<IrohaSwiftScale.UInt128>,
            query: IrohaDataModelQuery.QueryBox, 
            accountId: IrohaDataModelAccount.Id
        ) {
            self.timestampMs = timestampMs
            self.query = query
            self.accountId = accountId
        }
    }
}

extension IrohaDataModelQuery.Payload: ScaleCodec.Encodable {
    public func encode<E>(in encoder: inout E) throws where E : Encoder {
        #warning("check")
        let data = timestampMs.value.data(littleEndian: true, trimmed: true)
        let time = try ScaleCodec.UInt128(decoding: data)

        try encoder.encode(time)
        try encoder.encode(query)
        try encoder.encode(accountId)
    }
}

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
public struct Event: Codable {
    
    public var entityType: IrohaDataModelEventsPipeline.EntityType
    public var status: IrohaDataModelEventsPipeline.Status
    public var hash: IrohaCrypto.Hash
    
    public init(entityType: IrohaDataModelEventsPipeline.EntityType, status: IrohaDataModelEventsPipeline.Status, hash: IrohaCrypto.Hash) {
    self.entityType = entityType
        self.status = status
        self.hash = hash
    }
}
}
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

extension IrohaDataModelAsset {
public struct AssetDefinition: Codable {
    
    public var valueType: IrohaDataModelAsset.AssetValueType
    public var id: IrohaDataModelAsset.DefinitionId
    
    public init(valueType: IrohaDataModelAsset.AssetValueType, id: IrohaDataModelAsset.DefinitionId) {
    self.valueType = valueType
        self.id = id
    }
}
}
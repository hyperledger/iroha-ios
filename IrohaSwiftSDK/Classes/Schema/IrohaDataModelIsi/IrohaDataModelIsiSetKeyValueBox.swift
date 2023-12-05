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
    public struct SetKeyValueBox: Swift.Codable {
        
        public var objectId: IrohaDataModelExpression.EvaluatesTo
        public var key: IrohaDataModelExpression.EvaluatesTo
        public var value: IrohaDataModelExpression.EvaluatesTo
        
        public init(
            objectId: IrohaDataModelExpression.EvaluatesTo,
            key: IrohaDataModelExpression.EvaluatesTo,
            value: IrohaDataModelExpression.EvaluatesTo
        ) {
            self.objectId = objectId
            self.key = key
            self.value = value
        }
    }
}
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

extension IrohaDataModelExpression {
    public struct EvaluatesTo: Swift.Codable {
        
        public var expression: IrohaDataModelExpression.Expression
        
        public init(expression: IrohaDataModelExpression.Expression) {
            self.expression = expression
        }
    }
}

extension IrohaDataModelExpression.EvaluatesTo: ScaleCodec.Encodable {
    public func encode<E>(in encoder: inout E) throws where E : ScaleCodec.Encoder {
        try encoder.encode(expression)
    }
}
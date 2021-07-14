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
public struct If: Codable {
    
    public var condition: Bool
    public var then: IrohaDataModelIsi.Instruction
    public var otherwise: IrohaDataModelIsi.Instruction?
    
    public init(condition: Bool, then: IrohaDataModelIsi.Instruction, otherwise: IrohaDataModelIsi.Instruction?) {
    self.condition = condition
        self.then = then
        self.otherwise = otherwise
    }
}
}
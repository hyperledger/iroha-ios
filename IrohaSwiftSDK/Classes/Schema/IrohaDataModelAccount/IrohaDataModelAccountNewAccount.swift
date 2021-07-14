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

extension IrohaDataModelAccount {
public struct NewAccount: Codable {
    
    public var id: IrohaDataModelAccount.Id
    public var signatories: [IrohaCrypto.PublicKey]
    public var metadata: IrohaDataModelMetadata.Metadata
    
    public init(id: IrohaDataModelAccount.Id, signatories: [IrohaCrypto.PublicKey], metadata: IrohaDataModelMetadata.Metadata) {
    self.id = id
        self.signatories = signatories
        self.metadata = metadata
    }
}
}
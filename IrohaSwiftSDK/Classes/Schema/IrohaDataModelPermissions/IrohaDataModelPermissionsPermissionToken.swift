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

extension IrohaDataModelPermissions {
    public struct PermissionToken: Swift.Codable {
        
        public var name: String
        public var params: [String: IrohaDataModel.Value]
        
        public init(
            name: String, 
            params: [String: IrohaDataModel.Value]
        ) {
            self.name = name
            self.params = params
        }
    }
}

extension IrohaDataModelPermissions.PermissionToken: ScaleCodec.Encodable {
    public func encode<E>(in encoder: inout E) throws where E : Encoder {
        // todo:
    }
}
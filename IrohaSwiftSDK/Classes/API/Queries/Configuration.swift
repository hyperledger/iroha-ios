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

/**
 * Configuration
 *
 * Endpoint: /configure
 * Method: GET
 * Response:
 */

struct Metrics: IrohaQueryJsonCoding {
    enum Error: Swift.Error {
        case queryRejected
        case external(Swift.Error)
    }
    
    typealias Request = Nothing
    typealias ResponseValue = IrohaDataModelQuery.VersionedQueryResult
    typealias ResponseError = Error
    
    let path = "/configure"
    let httpMethod = "GET"
    
    let statusCodeToErrors: [Int: Error] = [:]
    
    func mapError(_ error: Swift.Error) -> ResponseError {
        .external(error)
    }
    
    var queryParameters: [String: CustomStringConvertible] = [:]
}

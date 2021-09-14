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
 * Submit query
 *
 * Endpoint: /query
 * Method: POST
 * Body: IrohaDataModelQuery.SignedQueryRequest
 * Response: IrohaDataModelQuery.QueryResponse
 *
 * GET params:
 *
 * . start - Optional parameter in queries where results can be indexed. Use to return results from specified point. Results are ordered where can be by id which uses rust's PartialOrd and Ord traits.
 * . limit - Optional parameter in queries where results can be indexed. Use to return specific number of results.
 *
 */

struct SubmitQuery: IrohaQueryScaleCoding {
    enum Error: Swift.Error {
        case queryRejected
        case external(Swift.Error)
    }
    
    typealias Request = IrohaDataModelQuery.VersionedSignedQueryRequest
    typealias ResponseValue = IrohaDataModelQuery.QueryResult
    typealias ResponseError = Error
    
    let path = "/query"
    let httpMethod = "POST"
    
    let statusCodeToErrors = [500: Error.queryRejected]
    
    func mapError(_ error: Swift.Error) -> ResponseError {
        .external(error)
    }
    
    var queryParameters: [String: CustomStringConvertible] = [:]
    init(start: Int? = nil, limit: Int? = nil) {
        if let start = start {
            queryParameters["start"] = start
        }
        
        if let limit = limit {
            queryParameters["limit"] = limit
        }
    }
}

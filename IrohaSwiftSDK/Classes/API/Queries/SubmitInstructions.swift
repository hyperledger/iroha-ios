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

/**
 * Submit instructions
 *
 * Endpoint: /instruction
 * Method: POST
 * Body: IrohaDataModelTransaction.Transaction
 * Response: Nothing
 */

struct SubmitInstructions: IrohaQueryScaleCoding {
    
    enum Error: Swift.Error {
        case transactionRejected
        case external(Swift.Error)
    }
    
    typealias Request = IrohaDataModelTransaction.VersionedTransaction
    typealias ResponseValue = Nothing
    typealias ResponseError = Error
    
    let path = "/transaction"
    let httpMethod = "POST"
    
    let statusCodeToErrors = [500: Error.transactionRejected]
    
    func mapError(_ error: Swift.Error) -> ResponseError {
        .external(error)
    }
    
    let queryParameters: [String: CustomStringConvertible] = [:]
}

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
import XCTest

func precondition(_ condition: Bool) {
    if condition {
        PreconditionHandler.preconditionDidNotFireClosure?()
    } else {
        PreconditionHandler.preconditionFireClosure?(nil)
    }
}

func precondition(_ condition: Bool, _ message: String) {
    if condition {
        PreconditionHandler.preconditionDidNotFireClosure?()
    } else {
        PreconditionHandler.preconditionFireClosure?(message)
    }
}

private struct PreconditionHandler {
    fileprivate static var preconditionFireClosure: ((String?) -> Void)?
    fileprivate static var preconditionDidNotFireClosure: (() -> Void)?
    
    fileprivate static func clear() {
        preconditionFireClosure = nil
        preconditionDidNotFireClosure = nil
    }
}

extension XCTestCase {
    func assertNoPreconditionFailure(_ closure: () -> Void) {
        PreconditionHandler.preconditionDidNotFireClosure = {
            PreconditionHandler.clear()
        }
        
        PreconditionHandler.preconditionFireClosure = {
            if let message = $0 {
                XCTFail(message)
            } else {
                XCTFail()
            }
            
            PreconditionHandler.clear()
        }
        
        closure()
    }
    
    func assertPreconditionFailure(_ closure: () -> Void) {
        PreconditionHandler.preconditionDidNotFireClosure = {
            XCTFail()
            PreconditionHandler.clear()
        }
        
        PreconditionHandler.preconditionFireClosure = { _ in
            PreconditionHandler.clear()
        }
        
        closure()
    }
}

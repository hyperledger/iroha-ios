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

extension TimeInterval {
    init(milliseconds: UInt64) {
        self.init(TimeInterval(milliseconds) / 1000)
    }
    
    var milliseconds: UInt64 {
        UInt64(self * 1000)
    }
}

extension Date {
    init(milliseconds: UInt64) {
        self.init(timeIntervalSince1970: TimeInterval(milliseconds: milliseconds))
    }
    
    var milliseconds: UInt64 {
        timeIntervalSince1970.milliseconds
    }
}

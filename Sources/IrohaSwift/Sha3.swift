/*
Copyright Soramitsu Co., Ltd. 2016 All Rights Reserved.
http://soramitsu.co.jp

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

         http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/


import Foundation
import libs

public func sha3_256(message:String) -> String{
    var out: Array<UInt8> = Array(repeating: 0, count: 32)
    let messageArray:Array<UInt8> = Array<UInt8>(message.utf8)
    sha3_256(messageArray, messageArray.count, &out)
    let hash = byteToHexString(hashByte: out)
    return hash
}

public func sha3_384(message:String) -> String{
    var out: Array<UInt8> = Array(repeating: 0, count: 48)
    let messageArray:Array<UInt8> = Array<UInt8>(message.utf8)
    sha3_384(messageArray, messageArray.count, &out)
    let hash = byteToHexString(hashByte: out)
    return hash
}

public func sha3_512(message: String) -> String{
    var out: Array<UInt8> = Array(repeating: 0, count: 64)
    let messageArray:Array<UInt8> = Array<UInt8>(message.utf8)
    sha3_512(messageArray, messageArray.count, &out)
    let hash = byteToHexString(hashByte: out)
    return hash
}

func byteToHexString(hashByte:Array<UInt8>) -> String {
    var result: String = ""
    result = hashByte.map{String(format: "%02x", $0)}.joined(separator: "")
    return result
}

//
//  Sha3.swift
//  IrohaSwift
//
//  Created by Kaji Satoshi on 2016/09/27.
//  Copyright © 2016年 Kaji Satoshi. All rights reserved.
//

import Foundation
import libs

func sha3_256(message:String) -> String{
    var out: Array<UInt8> = Array(repeating: 0, count: 32)
    let messageArray:Array<UInt8> = Array<UInt8>(message.utf8)
    sha3_256(messageArray, messageArray.count, &out)
    var result: String = ""
    result = out.map{String(format: "%02x", $0)}.joined(separator: "")
    print(result)
    return result
}

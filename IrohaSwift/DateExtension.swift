//
//  DateEx.swift
//  IrohaSwift
//
//  Created by Kaji Satoshi on 2016/09/19.
//  Copyright © 2016年 Kaji Satoshi. All rights reserved.
//

import Foundation

extension Date{
    var toString: String {
        var formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter.string(from: Date())
    }
}

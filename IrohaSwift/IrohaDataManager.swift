//
//  IrohaDataManager.swift
//  IrohaSwift
//
//  Created by Kaji Satoshi on 2016/09/30.
//  Copyright © 2016年 Kaji Satoshi. All rights reserved.
//

import Foundation

class IrohaDataManager {
    static let sharedManager = IrohaDataManager()
    var accessPoint = ""
    var uuid = ""
    var publicKey = ""
    private init() {
    }
}

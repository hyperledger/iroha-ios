//
//  DataManager.swift
//  Example-Point
//
//  Created by Kaji Satoshi on 2016/12/12.
//  Copyright © 2016年 Soramitsu Co., Ltd. All rights reserved.
//

import Foundation

class DataManager {
    static let instance: DataManager = DataManager()
    private init() {
    }
    var privateKey = ""
    var publicKey = ""
    var property = 0
}

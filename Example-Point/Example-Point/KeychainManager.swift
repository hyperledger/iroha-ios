//
//  KeychainManager.swift
//  Example-Point
//
//  Created by Kaji Satoshi on 2016/12/12.
//  Copyright © 2016年 Soramitsu Co., Ltd. All rights reserved.
//

import Foundation
import KeychainAccess

class KeychainManager{
    static let sharedManager = KeychainManager()
    private init() {}
    let keychain = Keychain(service: "jp.co.soramitsu.irohapoint")
    
}

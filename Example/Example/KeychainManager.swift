//
//  KeychainManager.swift
//  Example
//
//  Created by Kaji Satoshi on 2016/09/24.
//  Copyright © 2016年 Kaji Satoshi. All rights reserved.
//

import Foundation
import KeychainAccess

class KeyChainManager{
    static let sharedManager = KeyChainManager()
    private init() {}
    let keychain = Keychain(service: "jp.co.soramitsu.Example")    
}

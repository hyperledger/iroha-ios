//
//  Keychain.swift
//  IrohaSwift
//
//  Created by Kaji Satoshi on 2016/09/19.
//  Copyright © 2016年 Kaji Satoshi. All rights reserved.
//

import Foundation

class Keychain{
    let keychainModel = KeychainModel()
    func set(key:String,value:String){
        keychainModel.save(key: key, value: value)
    }
    func get(key:String) -> String{
        return keychainModel.load(key: key)!
    }
    func delete(key:String){
        keychainModel.save(key: key, value: "")
    }
}

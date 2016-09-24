//
//  KeychainManager.swift
//  IrohaSwift
//
//  Created by Kaji Satoshi on 2016/09/19.
//  Copyright © 2016年 Kaji Satoshi. All rights reserved.
//

import Foundation
import Security

class KeychainModel{
    let kSecClassGenericPasswordValue = String(format: kSecClassGenericPassword as String)
    let kSecClassValue = String(format: kSecClass as String)
    let kSecAttrServiceValue = String(format: kSecAttrService as String)
    let kSecValueDataValue = String(format: kSecValueData as String)
    let kSecMatchLimitValue = String(format: kSecMatchLimit as String)
    let kSecReturnDataValue = String(format: kSecReturnData as String)
    let kSecMatchLimitOneValue = String(format: kSecMatchLimitOne as String)
    let kSecAttrAccountValue = String(format: kSecAttrAccount as String)
    
    func save(key: String, value: String) {
        if let dataFromString = value.data(using: String.Encoding.utf8) {
            let keychainQuery = [
                kSecClassValue: kSecClassGenericPasswordValue,
                kSecAttrServiceValue: key,
                kSecValueDataValue: dataFromString
                ] as CFDictionary
            SecItemDelete(keychainQuery)
            SecItemAdd(keychainQuery, nil)
        }
    }
    
    func load(key: String) -> String? {
        let keychainQuery = [
            kSecClassValue: kSecClassGenericPasswordValue,
            kSecAttrServiceValue: key,
            kSecReturnDataValue: kCFBooleanTrue,
            kSecMatchLimitValue: kSecMatchLimitOneValue
            ] as  CFDictionary
        var dataTypeRef: AnyObject?
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        var passcode: String?
        if (status == errSecSuccess) {
            if let retrievedData = dataTypeRef as? Data,
                let result = String(data: retrievedData, encoding: String.Encoding.utf8) {
                passcode = result as String
            }
        }
        else {
            print("Nothing was retrieved from the keychain. Status code \(status)")
        }
        return passcode
    }
}

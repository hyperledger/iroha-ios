//
//  IrohaSwift.swift
//  IrohaSwift
//
//  Created by Kaji Satoshi on 2016/09/18.
//  Copyright © 2016年 Kaji Satoshi. All rights reserved.
//

import Foundation

public func register(keyPair:(publicKey:String, privateKey:String), accessPoint:String, name:String) -> [String:Any]{
    setAddress(accessPoint: accessPoint)
    let req = HttpRequest()
    let parameter: [String : Any] = [
        "publicKey": keyPair.publicKey,
        "screen_name": name,
        "timestamp": Date().timeIntervalSince1970
    ]
    var res = req.postRequest(accessPoint:accessPoint, endpoint: "/account/register", parameters: parameter)
    return res
}

public func getAccountInfo() -> [String:Any]{
    let req = HttpRequest()
    let ap = getAddress()
    let uuid = Keychain().get(key: "uuid")
    return req.getRequest(accessPoint: ap, endpoint: "/account",parameters: ["uuid":uuid])
}

public func getPublicKey() -> String{
    return Keychain().get(key: "publicKey")
}

public func setAddress(accessPoint:String){
    Keychain().set(key: "accessPoint", value: accessPoint)
}

public func getAddress() -> (String){
    let ap:String = Keychain().get(key: "accessPoint")
    return ap
}

public func domainRegister(domain:String) -> [String:Any]{
    let req = HttpRequest()
    let ap = getAddress()
    let timestamp = Date().timeIntervalSince1970
    let pub = Keychain().get(key: "publicKey")
    let message = "timestamp:\(timestamp),owner:\(pub),name:\(domain)"
    let sign = createSignature(message:message)
    let parameter: [String : Any] = [
        "name" : domain,
        "owner" : pub,
        "signature" : sign,
        "timestamp": timestamp
        ]
    
    return req.postRequest(accessPoint: ap, endpoint: "/domain/register", parameters:parameter)
}

public func getAssetsList() -> [String:Any]{
    let req = HttpRequest()
    let ap = getAddress()
    return req.getRequest(accessPoint: ap, endpoint: "/assets/list")
}

public func createAsset(name:String, domain:String)-> [String:Any]{
    let req = HttpRequest()
    let ap = getAddress()
    let pub = Keychain().get(key: "publicKey")
    let message = "name:\(name),domain:\(domain),creator:\(pub)"
    let sign = createSignature(message:message)
    let parameter: [String : Any] = [
        "name" : name,
        "domain" : domain,
        "creator" : pub,
        "signature" : sign,
    ]
    
    return req.postRequest(accessPoint: ap, endpoint: "/asset/create", parameters:parameter)
}

public func assetOperation(assetUuid:String, command:String, amount:String, reciever:String) -> [String:Any]{
    let req = HttpRequest()
    let ap = getAddress()
    let pub = Keychain().get(key: "publicKey")
    let message = "sender:\(pub),reciever:\(reciever),asset-uuid:\(assetUuid),amount:\(amount)"
    let sign = createSignature(message:message)
    let parameter: [String : Any] = [
            "asset-uuid": assetUuid,
            "params" : [
                "command": command,
                "amount": Int(amount),
                "sender" : pub,
                "receiver" : reciever
            ],
            "signature" : sign
    ]
    return req.postRequest(accessPoint: ap, endpoint: "/asset/operation", parameters:parameter)
}


public func getTransaction() -> [String:Any]{
    let req = HttpRequest()
    let ap = getAddress()
    let uuid = Keychain().get(key: "uuid")
    
    return req.getRequest(accessPoint: ap, endpoint: "/history/transaction/\(uuid)")
}

public func getAllTransaction(){
    
}

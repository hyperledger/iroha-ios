//
//  IrohaSwift.swift
//  IrohaSwift
//
//  Created by Kaji Satoshi on 2016/09/18.
//  Copyright © 2016年 Kaji Satoshi. All rights reserved.
//

import Foundation

public func register(keyPair:(publicKey:String, privateKey:String), accessPoint:String, name:String) -> [String:Any]{
    let req = HttpRequest()
    let parameter: [String : Any] = [
        "publicKey": keyPair.publicKey,
        "screen_name": name,
        "timestamp": Date().timeIntervalSince1970
    ]
    let res = req.postRequest(accessPoint:accessPoint, endpoint: "/account/register", parameters: parameter)
    return res
}

public func getAccountInfo(accessPoint:String,uuid:String) -> [String:Any]{
    let req = HttpRequest()
    return req.getRequest(accessPoint: accessPoint, endpoint: "/account",parameters: ["uuid":uuid])
}

public func domainRegister(accessPoint:String, domain:String, keyPair:(publicKey:String, privateKey:String)) -> [String:Any]{
    let req = HttpRequest()
    let timestamp = Date().timeIntervalSince1970
    let message = "timestamp:\(timestamp),owner:\(keyPair.publicKey),name:\(domain)"
    let signature = sign(keyPair.publicKey, privateKey: keyPair.privateKey, message: message)
    let parameter: [String : Any] = [
        "name" : domain,
        "owner" : keyPair.publicKey,
        "signature" : signature,
        "timestamp": timestamp
        ]
    
    return req.postRequest(accessPoint: accessPoint, endpoint: "/domain/register", parameters:parameter)
}

public func getAssetsList(accessPoint:String) -> [String:Any]{
    let req = HttpRequest()
    return req.getRequest(accessPoint: accessPoint, endpoint: "/assets/list")
}

public func createAsset(accessPoint: String, domain:String, keyPair:(publicKey:String, privateKey:String), name:String)-> [String:Any]{
    let req = HttpRequest()
    let pub = Keychain().get(key: "publicKey")
    let message = "name:\(name),domain:\(domain),creator:\(pub)"
    let signature = sign(keyPair.publicKey, privateKey: keyPair.privateKey, message: message)
    let parameter: [String : Any] = [
        "name" : name,
        "domain" : domain,
        "creator" : keyPair.publicKey,
        "signature" : signature,
    ]
    
    return req.postRequest(accessPoint: accessPoint, endpoint: "/asset/create", parameters:parameter)
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

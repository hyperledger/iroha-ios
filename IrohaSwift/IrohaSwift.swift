//
//  IrohaSwift.swift
//  IrohaSwift
//
//  Created by Kaji Satoshi on 2016/09/18.
//  Copyright © 2016年 Kaji Satoshi. All rights reserved.
//

import Foundation
import libs

public func register(keyPair:(publicKey:String, privateKey:String), accessPoint:String, name:String) -> [String:Any]{
    let req = HttpRequest()
    let parameter: [String : Any] = [
        "publicKey": keyPair.publicKey,
        "screen_name": name,
        "timestamp": Date().timeIntervalSince1970
    ]
    let res = req.postRequest(accessPoint: accessPoint, endpoint: "/account/register", parameters: parameter)
    return res
}

public func getAccountInfo(accessPoint:String,uuid:String) -> [String:Any]{
    let req = HttpRequest()
    return req.getRequest(accessPoint: accessPoint, endpoint: "/account",parameters: ["uuid":uuid])
}

public func domainRegister(accessPoint:String, domain:String, keyPair:(publicKey:String, privateKey:String)) -> [String:Any]{
    let req = HttpRequest()
    let timestamp = Int(Date().timeIntervalSince1970)
    let message = "timestamp:\(timestamp),owner:\(keyPair.publicKey),name:\(domain)"
    let signature = sign(publicKey: keyPair.publicKey, privateKey: keyPair.privateKey, message: message)
    let parameter: [String : Any] = [
        "name" : domain,
        "owner" : keyPair.publicKey,
        "signature" : signature,
        "timestamp": timestamp
        ]

    return req.postRequest(accessPoint: accessPoint, endpoint: "/domain/register", parameters:parameter)
}

public func createAsset(accessPoint: String, domain:String, keyPair:(publicKey:String, privateKey:String), name:String)-> [String:Any]{
    let req = HttpRequest()
    let timestamp = Int(Date().timeIntervalSince1970)
    let message = "timestamp:\(timestamp),name:\(name),domain:\(domain),creator:\(keyPair.publicKey)"
    let signature = sign(publicKey: keyPair.publicKey, privateKey: keyPair.privateKey, message: message)
    let parameter: [String : Any] = [
        "name" : name,
        "domain" : domain,
        "creator" : keyPair.publicKey,
        "signature" : signature,
        "timestamp" : timestamp
        ]
    
    return req.postRequest(accessPoint: accessPoint, endpoint: "/asset/create", parameters:parameter)
}

public func getDomainList(accessPoint:String) -> [String:Any]{
    let req = HttpRequest()
    return req.getRequest(accessPoint: accessPoint, endpoint: "/domain/list")
}

public func getAssetsList(accessPoint:String, domain:String) -> [String:Any]{
    let req = HttpRequest()
    return req.getRequest(accessPoint: accessPoint, endpoint: "/assets/list/\(domain)")
}


public func assetOperation(accessPoint: String, command:String, assetUuid:String, amount:String, keyPair:(publicKey:String, privateKey:String), reciever:String) -> [String:Any]{
    let req = HttpRequest()
    let timestamp = Int(Date().timeIntervalSince1970)
    let message = "timestamp:\(timestamp),sender:\(keyPair.publicKey),reciever:\(reciever),command:\(command),amount:\(amount),asset-uuid:\(assetUuid)"
    let signature = sign(publicKey: keyPair.publicKey, privateKey: keyPair.privateKey, message: message)
    let parameter: [String : Any] = [
            "asset-uuid": assetUuid,
            "params" : [
                "command": command,
                "amount": Int(amount),
                "sender" : keyPair.publicKey,
                "receiver" : reciever
            ],
            "signature" : signature,
            "timestamp" : timestamp
    ]
    return req.postRequest(accessPoint: accessPoint, endpoint: "/asset/operation", parameters:parameter)
}


public func getTransaction(accessPoint:String, uuid:String) -> [String:Any]{
    let req = HttpRequest()
    return req.getRequest(accessPoint: accessPoint, endpoint: "/history/transaction/\(uuid)")
}

public func getTransactionWithAssetName(accessPoint:String, asset:String, domain:String) -> [String:Any]{
    let req = HttpRequest()
    return req.getRequest(accessPoint: accessPoint, endpoint: "/history/transaction/\(domain).\(asset)")
}

//
//  IrohaSwift.swift
//  IrohaSwift
//
//  Created by Kaji Satoshi on 2016/09/18.
//  Copyright © 2016年 Kaji Satoshi. All rights reserved.
//

import Foundation

func saveKeyPair() -> String{
    let keyPair = createKeyPair()
    let defaults = UserDefaults.standard
    defaults.set(keyPair.publicKey, forKey: "publicKey")
    Keychain().set(key: "privateKey", value: keyPair.privateKey)
    return keyPair.publicKey
}

func createSignature(message:String!)-> String{
    let defaults = UserDefaults.standard
    let pub:String = defaults.object(forKey: "publicKey") as! String
    let pri:String = Keychain().get(key: "privateKey")
    let sig:String = sign(pub, privateKey: pri, message: message)
    
    return sig
}

public func register(accessPoint:String, name:String) -> [String:Any]{
    setAddress(accessPoint: accessPoint)
    let req = HttpRequest()
    let key = saveKeyPair()
    let parameter: [String : Any] = [
        "publicKey": key,
        "screen_name": name,
        "timestamp": Date().toString
    ]
    var res = req.postRequest(accessPoint:accessPoint, endpoint: "/account/register", parameters: parameter)
    if (res["status"] as! Int) == 200 {
        let defaults = UserDefaults.standard
        defaults.set(res["uuid"] as! String, forKey: "uuid")
    }
    
    return res
}

public func setAddress(accessPoint:String){
    let defaults = UserDefaults.standard
    defaults.set(accessPoint, forKey: "accessPoint")
}

public func getAddress() -> (String){
    let defaults = UserDefaults.standard
    let ap:String = defaults.object(forKey: "accessPoint") as! String
    return (ap)
}

public func getAsset() -> [String:Any]{
    let req = HttpRequest()
    let ap = getAddress()
    return req.getRequest(accessPoint: ap, endpoint: "/assets/list")
}

public func createAsset(name:String, domain:String, amount:String)-> [String:Any]{
    let req = HttpRequest()
    let ap = getAddress()
    let defaults = UserDefaults.standard
    let pub:String = defaults.object(forKey: "publicKey") as! String
    let message = "name:\(name),domain:\(domain),creator:\(pub),amount:\(amount)"
    let sign = createSignature(message:message)
    let parameter: [String : Any] = [
        "asset-create": [
            "name" : name,
            "domain" : domain,
            "amount" : amount,
            "creator" : pub,
            "signature" : sign,
        ]
    ]
    
    return req.postRequest(accessPoint: ap, endpoint: "/asset/create", parameters:parameter)
}

public func assetTransfar(name:String, domain:String, amount:String, reciever:String) -> [String:Any]{
    let req = HttpRequest()
    let ap = getAddress()
    let defaults = UserDefaults.standard
    let pub:String = defaults.object(forKey: "publicKey") as! String
    let message = "sender:\(pub),reciever:\(reciever),name:\(name),domain:\(domain),amount:\(amount)"
    let sign = createSignature(message:message)
    let parameter: [String : Any] = [
        "asset-transfer": [
            "name" : name,
            "domain" : domain,
            "amount" : amount,
            "sender" : pub,
            "receiver" : reciever,
            "signature" : sign
        ]
    ]
    return req.postRequest(accessPoint: ap, endpoint: "/asset/transfer", parameters:parameter)
}


public func getTransaction() -> [String:Any]{
    let req = HttpRequest()
    let ap = getAddress()
    let defaults = UserDefaults.standard
    let uuid = defaults.object(forKey: "uuid") as! String
    
    return req.getRequest(accessPoint: ap, endpoint: "/transaction/\(uuid)")
}

public func getTransaction(uuid:String) -> [String:Any]{
    let req = HttpRequest()
    let ap = getAddress()
    
    return req.getRequest(accessPoint: ap, endpoint: "/transaction/\(uuid)")
}

public func getAllTransaction(){
    
}

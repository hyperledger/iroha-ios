//Copyright 2016 Soramitsu Co., Ltd.
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.

import Foundation
import libs

public func setDatas(accessPoint:String, publicKey:String, uuid:String){
    IrohaDataManager.sharedManager.accessPoint = accessPoint
    IrohaDataManager.sharedManager.publicKey = publicKey
    IrohaDataManager.sharedManager.uuid = uuid
}

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
    let signature = sign(publicKey: keyPair.publicKey, privateKey: keyPair.privateKey, message: sha3_256(message: message))
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
    let signature = sign(publicKey: keyPair.publicKey, privateKey: keyPair.privateKey, message: sha3_256(message: message))
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
    let signature = sign(publicKey: keyPair.publicKey, privateKey: keyPair.privateKey, message: sha3_256(message: message))
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

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

public func setDatas(uuid:String){
    IrohaDataManager.sharedManager.uuid = uuid
}

public func setDatas(accessPoint:String, publicKey:String){
    IrohaDataManager.sharedManager.accessPoint = accessPoint
    IrohaDataManager.sharedManager.publicKey = publicKey
}

public func setDatas(accessPoint:String, publicKey:String, uuid:String){
    IrohaDataManager.sharedManager.accessPoint = accessPoint
    IrohaDataManager.sharedManager.publicKey = publicKey
    IrohaDataManager.sharedManager.uuid = uuid
}

public func register(name:String) -> [String:Any]{
    let manager = IrohaDataManager.sharedManager
    let req = HttpRequest()
    let parameter: [String : Any] = [
        "publicKey": manager.publicKey,
        "screen_name": name,
        "timestamp": Date().timeIntervalSince1970
    ]
    let res = req.postRequest(accessPoint: manager.accessPoint, endpoint: "/account/register", parameters: parameter)
    
    return res
}

public func getAccountInfo() -> [String:Any]{
    let manager = IrohaDataManager.sharedManager
    let req = HttpRequest()
    return req.getRequest(accessPoint: manager.accessPoint, endpoint: "/account",parameters: ["uuid":manager.uuid])
}

public func domainRegister(domain:String, privateKey:String) -> [String:Any]{
    let manager = IrohaDataManager.sharedManager
    let req = HttpRequest()
    let timestamp = Int(Date().timeIntervalSince1970)
    let message = "timestamp:\(timestamp),owner:\(manager.publicKey),name:\(domain)"
    let signature = sign(publicKey: manager.publicKey, privateKey: privateKey, message: sha3_256(message: message))
    let parameter: [String : Any] = [
        "name" : domain,
        "owner" : manager.publicKey,
        "signature" : signature,
        "timestamp": timestamp
        ]

    return req.postRequest(accessPoint: manager.accessPoint, endpoint: "/domain/register", parameters:parameter)
}

public func createAsset(domain:String, privateKey:String, name:String)-> [String:Any]{
    let manager = IrohaDataManager.sharedManager
    let req = HttpRequest()
    let timestamp = Int(Date().timeIntervalSince1970)
    let message = "timestamp:\(timestamp),name:\(name),domain:\(domain),creator:\(manager.publicKey)"
    let signature = sign(publicKey: manager.publicKey, privateKey: privateKey, message: sha3_256(message: message))
    let parameter: [String : Any] = [
        "name" : name,
        "domain" : domain,
        "creator" : manager.publicKey,
        "signature" : signature,
        "timestamp" : timestamp
        ]
    
    return req.postRequest(accessPoint: manager.accessPoint, endpoint: "/asset/create", parameters:parameter)
}

public func getDomainList() -> [String:Any]{
    let req = HttpRequest()
    return req.getRequest(accessPoint: IrohaDataManager.sharedManager.accessPoint, endpoint: "/domain/list")
}

public func getAssetsList(domain:String) -> [String:Any]{
    let req = HttpRequest()
    return req.getRequest(accessPoint: IrohaDataManager.sharedManager.accessPoint, endpoint: "/assets/list/\(domain)")
}


public func assetOperation(command:String, assetUuid:String, amount:String, privateKey:String, reciever:String) -> [String:Any]{
    let manager = IrohaDataManager.sharedManager
    let req = HttpRequest()
    let timestamp = Int(Date().timeIntervalSince1970)
    let message = "timestamp:\(timestamp),sender:\(manager.publicKey),reciever:\(reciever),command:\(command),amount:\(amount),asset-uuid:\(assetUuid)"
    let signature = sign(publicKey: manager.publicKey, privateKey: privateKey, message: sha3_256(message: message))
    let parameter: [String : Any] = [
            "asset-uuid": assetUuid,
            "params" : [
                "command": command,
                "amount": Int(amount),
                "sender" : manager.publicKey,
                "receiver" : reciever
            ],
            "signature" : signature,
            "timestamp" : timestamp
    ]
    return req.postRequest(accessPoint: manager.accessPoint, endpoint: "/asset/operation", parameters:parameter)
}


public func getTransaction() -> [String:Any]{
    let manager = IrohaDataManager.sharedManager
    let req = HttpRequest()
    return req.getRequest(accessPoint: manager.accessPoint, endpoint: "/history/transaction/\(manager.uuid)")
}

public func getTransactionWithAssetName(asset:String, domain:String) -> [String:Any]{
    let req = HttpRequest()
    return req.getRequest(accessPoint: IrohaDataManager.sharedManager.accessPoint, endpoint: "/history/transaction/\(domain).\(asset)")
}

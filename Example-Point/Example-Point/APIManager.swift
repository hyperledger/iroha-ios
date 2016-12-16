//
//  APIManager.swift
//  Example-Point
//
//  Created by Kaji Satoshi on 2016/12/15.
//  Copyright © 2016年 Soramitsu Co., Ltd. All rights reserved.
//

import Foundation
import Alamofire
import IrohaSwift

class APIManager {
    
    
    static let host = ""
   
    static func GetUserInfo(userId:String, completionHandler: @escaping ([String : Any])->()){
        //        print(userId)
        Alamofire.request("\(host)/api/v1/account", method: .get,parameters: ["uuid":userId])
            .responseJSON { response in
                switch response.result {
                case .success(let JSON):
                    if let JSON  = response.result.value {
                        completionHandler(JSON as! [String : Any])
                    }
                    break
                //do json stuff
                case .failure(let error):
                    let JSON = [
                        "status": 500,
                        "message": "サーバーエラーだよ"
                        ] as [String : Any]
                    completionHandler(JSON)
                    break
                }
                
        }
        
    }
    
    static func GetTransaction(userId:String, completionHandler: @escaping ([String:Any])->()){
        Alamofire.request("\(host)/api/v1/history/transaction", method: .get,parameters: ["uuid":userId])
            .responseJSON { response in
                switch response.result {
                case .success(let JSON):
                    if let JSON  = response.result.value {
                        completionHandler(JSON as! [String : Any])
                    }
                    break
                //do json stuff
                case .failure(let error):
                    let JSON = [
                        "status": 500,
                        "message": "サーバーエラーだよ"
                        ] as [String : Any]
                    completionHandler(JSON)
                    break
                }
                
        }
    }
    
    static func Register(name:String, pub:String, completionHandler: @escaping ([String:Any])->()){
        let parameter: [String : Any] = [
            "publicKey": pub,
            "alias": name,
            "timestamp": Int(Date().timeIntervalSince1970)
        ]
        print(parameter)
        Alamofire.request("\(host)/account/register", method:.post, parameters: parameter, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                switch response.result {
                case .success(let JSON):
                    if let JSON  = response.result.value {
                        completionHandler(JSON as! [String : Any])
                    }
                    break
                //do json stuff
                case .failure(let error):
                    let JSON = [
                        "status": 500,
                        "message": "サーバーエラーだよ"
                        ] as [String : Any]
                    completionHandler(JSON)
                    break
                }
        }
        
    }
    
    static func assetOperation(command:String, amount:String, privateKey:String, receiver:String, completionHandler: @escaping ([String:Any])->()){
        let keychain = KeychainManager.instance.keychain
        let timestamp = Int(Date().timeIntervalSince1970)
        let message = "value:\(amount),timestamp:\(timestamp),sender:\(keychain["publicKey"]!),receiver:\(receiver),command:\(command)"
        let signature = sign(publicKey: keychain["publicKey"]!, privateKey: keychain["privateKey"]!, message: sha3_256(message: message))
        let parameter: [String : Any] = [
            "asset-uuid" : "hogehoge",
            "params":[
                "command": command,
                "receiver": receiver,
                "sender":keychain["publicKey"]!,
                "value":Int(amount)!
            ],
            "signature" : signature,
            "timestamp" : timestamp
        ]
        
        Alamofire.request("\(host)/api/v1/asset/operation", method:.post, parameters: parameter, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result {
                case .success(let JSON):
                    if let JSON  = response.result.value {
                        completionHandler(JSON as! [String : Any])
                    }
                    break
                //do json stuff
                case .failure(let error):
                    let JSON = [
                        "status": 500,
                        "message": "サーバーエラーだよ"
                        ] as [String : Any]
                    completionHandler(JSON)
                    break
                }
        }
    }
}

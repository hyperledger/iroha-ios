/*
 Copyright Soramitsu Co., Ltd. 2016 All Rights Reserved.
 http://soramitsu.co.jp
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */


import Foundation
import Alamofire
import IrohaSwift

class APIManager {
    
    
    static let host = Bundle.main.infoDictionary?["Host"] as! String;
   
    static func GetUserInfo(userId:String, completionHandler: @escaping ([String : Any])->()){
        Alamofire.request("\(host)/account", method: .get,parameters: ["uuid":userId])
            .responseJSON { response in
                switch response.result {
                case .success(let JSON):
                    if let JSON  = response.result.value {
                        completionHandler(JSON as! Dictionary)
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
        Alamofire.request("\(host)/history/transaction", method: .get,parameters: ["uuid":userId])
            .responseJSON { response in
                switch response.result {
                case .success(let JSON):
                    if let JSON  = response.result.value {
                        completionHandler(JSON as! Dictionary)
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
        Alamofire.request("\(host)/account/register", method:.post, parameters: parameter, encoding: JSONEncoding.default)
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
                "value":amount
            ],
            "signature" : signature,
            "timestamp" : timestamp
        ]
        
        Alamofire.request("\(host)/asset/operation", method:.post, parameters: parameter, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result {
                case .success(let JSON):
                    if let JSON  = response.result.value {
                        completionHandler(JSON as! Dictionary)
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

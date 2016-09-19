//
//  HttpRequest.swift
//  IrohaSwift
//
//  Created by Kaji Satoshi on 2016/09/18.
//  Copyright © 2016年 Kaji Satoshi. All rights reserved.
//

import Foundation

class HttpRequest{
    func getRequest(host:String, port:Int?, endpoint:String) ->[String:Any] {
        var url : String
        if(port != nil){
            url = "\(host):\(port)\(endpoint)"
        } else {
            url = "\(host)\(endpoint)"
        }
        var request = URLRequest(url: URL(string:url)!)
        request.httpMethod = "GET"
        var d: [String:Any]? = nil

        let semaphore = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: request) {data, response, err in
            if(data != nil){
                let json = try! JSONSerialization.jsonObject(with: data!, options: [])
                if let dictFromJSON = json as? [String:Any] {
                    d = dictFromJSON
                    semaphore.signal()
                }
            }else{
                d = [
                    "status": 404,
                    "message": "not found"
                ]
                semaphore.signal()
            }
        }.resume()
        semaphore.wait(timeout: .distantFuture)
        return d!
    }
    
    func postRequest(host:String, port:Int?, endpoint:String, parameters:[String:Any]?) ->[String:Any] {
        var url : String
        if(port != nil){
            url = "\(host):\(port)\(endpoint)"
        } else {
            url = "\(host)\(endpoint)"
        }
        var request = URLRequest(url: URL(string:url)!)
        if(parameters != nil){
            print(parameters!)
            let jsonData = try! JSONSerialization.data(withJSONObject: parameters!, options: [])
            request.httpBody = jsonData
        }
        request.httpMethod = "POST"
        var d: [String:Any]? = nil
        
        let semaphore = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: request) {data, response, err in
            if(data != nil){
                let json = try! JSONSerialization.jsonObject(with: data!, options: [])
                print(data)
                if let dictFromJSON = json as? [String:Any] {
                    d = dictFromJSON
                    semaphore.signal()
                }
            }else{
                d = [
                    "status": 404,
                    "message": "not found"
                ]
                semaphore.signal()
            }
            }.resume()
        semaphore.wait(timeout: .distantFuture)
        return d!
    }

}

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

public class HttpRequest{
    func getRequest(accessPoint:String, endpoint:String, parameters:[String: Any]? = nil) ->[String:Any] {
        var url : String = ""
        if(parameters == nil){
            url = "\(accessPoint)\(endpoint)"
        }else{
            var parameterArray = [String]()
            for param in parameters! {
                parameterArray.append("\(param.key)=\(param.value)")
            }
            let param = parameterArray.joined(separator: "&")
            url = "\(accessPoint)\(endpoint)?\(param)"
        }
        var request = URLRequest(url: URL(string:url)!)
        request.httpMethod = "GET"
        var d: [String:Any]? = nil

        let semaphore = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: request) {data, response, err in
            if(data != nil){
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    if let dictFromJSON = json as? [String:Any] {
                        d = dictFromJSON
                        semaphore.signal()
                    }
                }catch{
                    d = [
                        "status": 500,
                        "message": "Internal server error."
                    ]
                    semaphore.signal()
                }
            }else{
                d = [
                    "status": 404,
                    "message": "Not found."
                ]
                semaphore.signal()
            }
        }.resume()
        semaphore.wait(timeout: .distantFuture)
        return d!
    }
    
    func postRequest(accessPoint:String, endpoint:String, parameters:[String:Any]?) ->[String:Any] {
        var url : String
        url = "\(accessPoint)\(endpoint)"
        var request = URLRequest(url: URL(string:url)!)
        if(parameters != nil){
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: parameters!, options: [])
                
                request.httpBody = jsonData
            }catch{
                print("error")
            }
        }
        request.httpMethod = "POST"
        var d: [String:Any]? = nil
        
        let semaphore = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: request) {data, response, err in
            if(data != nil){
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    if let dictFromJSON = json as? [String:Any] {
                        d = dictFromJSON
                        semaphore.signal()
                    }
                }catch{
                    d = [
                        "status": 500,
                        "message": "Internal server error."
                    ]
                    semaphore.signal()
                }
            }else{
                d = [
                    "status": 404,
                    "message": "Not found."
                ]
                semaphore.signal()
            }
        }.resume()
        semaphore.wait(timeout: .distantFuture)
        return d!
    }

}

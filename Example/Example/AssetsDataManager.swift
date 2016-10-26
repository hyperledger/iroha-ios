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

//
//  AssetsDataModel.swift
//  Example
//
//  Created by Kaji Satoshi on 2016/09/20.
//  Copyright © 2016年 Kaji Satoshi. All rights reserved.
//

import Foundation

class AssetsDataManager{
    var assetsDataArray: [Dictionary<String, String>] = []
    
    static let sharedManager = AssetsDataManager()
    private init() {
        let defaults = UserDefaults.standard
        let assetsDatas = defaults.object(forKey: "Assets")
        if (assetsDatas as? [Dictionary<String, String>] != nil) {
            self.assetsDataArray = assetsDatas as! [Dictionary<String, String>]
        }
    }

}

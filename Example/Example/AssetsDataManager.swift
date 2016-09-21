//
//  AssetsDataModel.swift
//  Example
//
//  Created by Kaji Satoshi on 2016/09/20.
//  Copyright © 2016年 Kaji Satoshi. All rights reserved.
//

import Foundation

class AssetsDataManager{
    var assetsDataArray: [Dictionary<String, Any>] = []
    
    static let sharedManager = AssetsDataManager()
    private init() {
        let defaults = UserDefaults.standard
        let assetsDatas = defaults.object(forKey: "Assets")
        if (assetsDatas as? [Dictionary<String, Any>] != nil) {
            self.assetsDataArray = assetsDatas as! [Dictionary<String, Any>]
        }
    }

}

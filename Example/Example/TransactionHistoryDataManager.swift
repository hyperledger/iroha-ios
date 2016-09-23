//
//  TransactionHistoryDataManager.swift
//  Example
//
//  Created by Kaji Satoshi on 2016/09/23.
//  Copyright © 2016年 Kaji Satoshi. All rights reserved.
//

import Foundation

class TransactionHistoryDataManager{
    var transactionHistoryDataArray: [Dictionary<String, String>] = []
    
    static let sharedManager = TransactionHistoryDataManager()
    private init() {
        let defaults = UserDefaults.standard
        let transactionHistoryDatas = defaults.object(forKey: "History")
        if (transactionHistoryDatas as? [Dictionary<String, String>] != nil) {
            self.transactionHistoryDataArray = transactionHistoryDatas as! [Dictionary<String, String>]
        }
    }
    
}

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
//  TransactionHistoryViewController.swift
//  Example
//
//  Created by Kaji Satoshi on 2016/09/20.
//  Copyright © 2016年 Kaji Satoshi. All rights reserved.
//

import Foundation
import UIKit
import IrohaSwift

class TransactionHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var historyTableView: UITableView!
    let historyRefresh = UIRefreshControl()
    var transactionHistories = [NSDictionary]()
    var historyAlert = UIAlertController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        historyTableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        historyTableView.delegate = self
        historyTableView.dataSource = self
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        historyRefresh.addTarget(self, action: #selector(refreshHistory), for: UIControlEvents.valueChanged)
        historyTableView.addSubview(historyRefresh)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        historyAlert = UIAlertController(title: nil, message: "履歴情報取得中\n\n\n", preferredStyle: UIAlertControllerStyle.alert)
        let spinnerIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        
        spinnerIndicator.center = CGPoint(x:135.0, y:65.5)
        spinnerIndicator.color = UIColor.black
        spinnerIndicator.startAnimating()
        
        historyAlert.view.addSubview(spinnerIndicator)
        self.present(historyAlert, animated: false, completion: {
            let keychain = KeychainManager.sharedManager.keychain
            let res = IrohaSwift.getTransaction()
            if res["status"] as! Int == 200 {
                self.historyAlert.dismiss(animated: false, completion: {() -> Void in
                    TransactionHistoryDataManager.sharedManager.transactionHistoryDataArray.removeAll()
                    self.transactionHistories = res["history"] as! [NSDictionary]
                    for item in self.transactionHistories {
                        let param: Dictionary<String, String> = (item.value(forKey: "params") as! NSDictionary) as! Dictionary<String, String>
                        TransactionHistoryDataManager.sharedManager.transactionHistoryDataArray.append(param)
                    }
                    self.historyTableView.reloadData()
                })
            } else {
                self.historyAlert.dismiss(animated: false, completion: {() -> Void in
                    
                    self.historyAlert = UIAlertController(title: String(describing: res["status"]!) , message: res["message"] as! String?, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    self.historyAlert.addAction(defaultAction)
                    self.present(self.historyAlert, animated: true, completion: nil)
                })
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TransactionHistoryDataManager.sharedManager.transactionHistoryDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as UITableViewCell
        let name:UILabel = cell.viewWithTag(1) as! UILabel
        let domain:UILabel = cell.viewWithTag(2) as! UILabel
        let value:UILabel = cell.viewWithTag(3) as! UILabel
        let historyData = TransactionHistoryDataManager.sharedManager.transactionHistoryDataArray[indexPath.row]
        name.text = historyData["name"]
        domain.text = historyData["domain"]
        value.text = historyData["amount"]
        
        return cell
    }


    
    func refreshHistory() {
        
        let keychain = KeychainManager.sharedManager.keychain
        let res = IrohaSwift.getTransaction()
        if (res["status"] as! Int) == 200{
            transactionHistories = res["history"] as! [NSDictionary]
            TransactionHistoryDataManager.sharedManager.transactionHistoryDataArray.removeAll()
            for item in transactionHistories {
                let param: Dictionary<String, String> = (item.value(forKey: "params") as! NSDictionary) as! Dictionary<String, String>
                TransactionHistoryDataManager.sharedManager.transactionHistoryDataArray.append(param)
            }
            historyTableView.reloadData()
        }else{
            //とりあえず何もしない
        }

        self.historyRefresh.endRefreshing()
    }
}

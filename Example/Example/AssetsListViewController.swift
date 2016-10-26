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
//  AssetsListViewController.swift
//  Example
//
//  Created by Kaji Satoshi on 2016/09/19.
//  Copyright © 2016年 Kaji Satoshi. All rights reserved.
//

import Foundation
import UIKit
import IrohaSwift

class AssetsListViewController : UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var assetsTableView: UITableView!
    let refreshControl = UIRefreshControl()
    var listAlert = UIAlertController()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib. 
        assetsTableView.delegate = self
        assetsTableView.dataSource = self
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        assetsTableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        assetsTableView.reloadData()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        listAlert = UIAlertController(title: nil, message: "口座情報取得中\n\n\n", preferredStyle: UIAlertControllerStyle.alert)
        let spinnerIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        
        spinnerIndicator.center = CGPoint(x:135.0, y:65.5)
        spinnerIndicator.color = UIColor.black
        spinnerIndicator.startAnimating()
        
        listAlert.view.addSubview(spinnerIndicator)
        self.present(listAlert, animated: false, completion: {
            let res = IrohaSwift.getAccountInfo()
            if res["status"] as! Int == 200 {
                self.listAlert.dismiss(animated: false, completion: {() -> Void in
                    //ここでAssetsDataManager.sharedManager.assetsDataArrayにデータを入れる。
                    self.assetsTableView.reloadData()
                })
            } else {
                self.listAlert.dismiss(animated: false, completion: {() -> Void in
                    
                    self.listAlert = UIAlertController(title: String(describing: res["status"]!) , message: res["message"] as! String?, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    self.listAlert.addAction(defaultAction)
                    self.present(self.listAlert, animated: true, completion: nil)
                })
            }
        })

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onClickCreate(_ sender: AnyObject) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AssetsDataManager.sharedManager.assetsDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "assetsCell", for: indexPath) as UITableViewCell

        let name:UILabel = cell.viewWithTag(1) as! UILabel
        let domain:UILabel = cell.viewWithTag(2) as! UILabel
        let value:UILabel = cell.viewWithTag(3) as! UILabel
        let assetData = AssetsDataManager.sharedManager.assetsDataArray[indexPath.row]
        name.text = assetData["name"]
        domain.text = assetData["domain"]
        value.text = assetData["amount"]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let nextvc = self.storyboard?.instantiateViewController(withIdentifier: "Transfer") as! TransferViewController
        nextvc.assetTxt = AssetsDataManager.sharedManager.assetsDataArray[indexPath.row]["name"]
        nextvc.domainTxt = AssetsDataManager.sharedManager.assetsDataArray[indexPath.row]["domain"]
        nextvc.havingVal = Int(AssetsDataManager.sharedManager.assetsDataArray[indexPath.row]["amount"]!)
        nextvc.assetUuid = AssetsDataManager.sharedManager.assetsDataArray[indexPath.row]["asset-uuid"]
        self.navigationController?.pushViewController(nextvc, animated: true)
    }
    
    func refresh() {
        self.refreshControl.endRefreshing()
    }

}

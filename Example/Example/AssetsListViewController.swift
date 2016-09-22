//
//  AssetsListViewController.swift
//  Example
//
//  Created by Kaji Satoshi on 2016/09/19.
//  Copyright © 2016年 Kaji Satoshi. All rights reserved.
//

import Foundation
import UIKit

class AssetsListViewController : UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var assetsTableView: UITableView!
    let refreshControl = UIRefreshControl()

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
        print(assetData)
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
        self.navigationController?.pushViewController(nextvc, animated: true)
    }
    
    func refresh() {
        self.refreshControl.endRefreshing()
    }

}

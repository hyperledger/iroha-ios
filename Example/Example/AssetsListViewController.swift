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
    let texts = [["name":"Asset1", "domain":"ソラミツ株式会社", "value":"100"]]
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onClickCreate(_ sender: AnyObject) {
        print("click")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return texts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "assetsCell", for: indexPath) as UITableViewCell


        let name:UILabel = cell.viewWithTag(1) as! UILabel
        let domain:UILabel = cell.viewWithTag(2) as! UILabel
        let value:UILabel = cell.viewWithTag(3) as! UILabel

        name.text = texts[indexPath.row]["name"]
        domain.text = texts[indexPath.row]["domain"]
        value.text = texts[indexPath.row]["value"]


        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let nextvc = self.storyboard?.instantiateViewController(withIdentifier: "Transfer") as! TransferViewController
        nextvc.assetTxt = texts[indexPath.row]["name"]!
        nextvc.domainTxt = texts[indexPath.row]["domain"]!
        nextvc.havingVal = Int(texts[indexPath.row]["value"]!)
        self.navigationController?.pushViewController(nextvc, animated: true)
    }
    
    func refresh() {
        self.refreshControl.endRefreshing()
    }

}

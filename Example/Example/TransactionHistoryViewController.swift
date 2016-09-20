//
//  TransactionHistoryViewController.swift
//  Example
//
//  Created by Kaji Satoshi on 2016/09/20.
//  Copyright © 2016年 Kaji Satoshi. All rights reserved.
//

import Foundation
import UIKit

class TransactionHistoryViewController: UIViewController{
    
    @IBOutlet weak var historyTableView: UITableView!
    let historyRefresh = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        historyRefresh.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        historyTableView.addSubview(historyRefresh)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refresh() {
        self.historyRefresh.endRefreshing()
    }
}

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
    let texts = ["Assets1", "Assets2", "Assets3", "Assets4", "Assets5", "Assets6", "Assets7"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib. 
        assetsTableView.delegate = self
        assetsTableView.dataSource = self
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
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
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "assetsCell")
        cell.textLabel?.text = texts[indexPath.row]

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let nextvc = self.storyboard?.instantiateViewController(withIdentifier: "Transfer") as! TransferViewController
        self.navigationController?.pushViewController(nextvc, animated: true)
    }

}

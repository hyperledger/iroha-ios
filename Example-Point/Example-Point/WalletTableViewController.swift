//
//  WalletTableViewController.swift
//  Example-Point
//
//  Created by Kaji Satoshi on 2016/12/12.
//  Copyright © 2016年 Soramitsu Co., Ltd. All rights reserved.
//

import UIKit
import PMAlertController
import IrohaSwift

class WalletTableViewController: UITableViewController {
    let historyRefresh = UIRefreshControl()
    
    var myItems = [["amount":60,"sender":"\(KeychainManager.instance.keychain["publicKey"]!)","opponent":"hogehoge","timestamp":1474],["amount":60,"opponent":"\(KeychainManager.instance.keychain["publicKey"]!)","sender":"hogehoge","timestamp":1474],]
    
    var labeltxt = "0 IRH";
    var label:UILabel?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor.iroha
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.topViewController!.navigationItem.title = "Wallet"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyRefresh.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(historyRefresh)
        loadTransaction()
        self.view.backgroundColor = UIColor.white
        
        tableView.sectionHeaderHeight = 120
        tableView.register(TransactionCell.self, forCellReuseIdentifier: "TransactionCell")
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    func loadTransaction(){
//        self.tabBarController?.tabBar.isHidden = true
        
        if CheckReachability(host_name: "google.com") {
            let alertVC = PMAlertController(title: "通信中", description: "口座情報を取得しています", image: UIImage(named: ""), style: .alert)
            self.present(alertVC, animated: true, completion: {
                alertVC.dismiss(animated: false, completion: nil)
            })
        }else{
            let alertVC = PMAlertController(title: "接続エラー", description: "ネットワークを確認してね", image: UIImage(named: ""), style: .alert)
            
            alertVC.addAction(PMAlertAction(title: "再読み込み", style: .cancel, action: { () -> Void in
                alertVC.dismiss(animated: false, completion: nil)
                self.loadTransaction()
            }))
            
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    func refresh() {
        if CheckReachability(host_name: "google.com") {

        }else{
            self.tabBarController?.tabBar.isHidden = true
            
            let alertVC = PMAlertController(title: "接続エラー", description: "ネットワークを確認してね", image: UIImage(named: ""), style: .alert)
            
            alertVC.addAction(PMAlertAction(title: "OK", style: .cancel, action: { () -> Void in
                alertVC.dismiss(animated: false, completion: nil)
                self.historyRefresh.endRefreshing()
                self.tabBarController?.tabBar.isHidden = false
                
            }))
            
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let myView: UIView = UIView()
        myView.backgroundColor = UIColor.iroha
        label = UILabel(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height:120))
        label!.backgroundColor = UIColor.clear
        label!.text = labeltxt
        label!.textColor = UIColor.white
        label!.font = UIFont.systemFont(ofSize: 29)
        label!.textAlignment = .center
        myView.addSubview(label!)
        
        return myView
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath:IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionCell
        let item = myItems[self.myItems.count - indexPath.row - 1]

        if((item["sender"] as! String) == KeychainManager.instance.keychain["publicKey"]!){
            cell.fillWith(backgroundColor: UIColor.green, textColor: UIColor.white, isSender: true, oppo: item["opponent"] as! String, valueText: "\(item["amount"]!)",time: item["timestamp"]! as! Int)
            
        }else{
            cell.fillWith(backgroundColor: UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1 ), textColor: UIColor.white,  isSender: false, oppo: item["opponent"] as! String, valueText: "\(item["amount"]!)",time: item["timestamp"]! as! Int)
            
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func Initialization(_ sender: AnyObject) {
        let alertVC = PMAlertController(title: "デバッグ用", description: "アプリを初期化します。", image: UIImage(named: ""), style: .alert)
        
        alertVC.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: { () -> Void in
            alertVC.dismiss(animated: false, completion: nil)
        }))
        
        alertVC.addAction(PMAlertAction(title: "OK", style: .default, action: { () in
            alertVC.dismiss(animated: false, completion: nil)
            KeychainManager.instance.keychain["privateKey"] = nil
            exit(0)
        }))
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
}

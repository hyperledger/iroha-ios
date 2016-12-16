//
//  SendViewController.swift
//  Example-Point
//
//  Created by Kaji Satoshi on 2016/12/12.
//  Copyright © 2016年 Soramitsu Co., Ltd. All rights reserved.
//

import UIKit
import TextFieldEffects
import PMAlertController

class SendViewController: UIViewController {
    
    var to = ""
    var amount = ""
    
    @IBOutlet weak var toField: HoshiTextField!
    @IBOutlet weak var amountField: HoshiTextField!
    @IBOutlet weak var sendButton: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor.iroha
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.topViewController!.navigationItem.title = "Send"
        self.tabBarController?.tabBar.tintColor = UIColor.irohaGreen
        toField.text = to
        amountField.text = amount
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let kbToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        kbToolBar.barStyle = UIBarStyle.default
        kbToolBar.sizeToFit()
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let commitButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: Selector("commitButtonTapped"))
        kbToolBar.items = [spacer, commitButton]
        toField.inputAccessoryView = kbToolBar
        amountField.inputAccessoryView = kbToolBar
        
        sendButton.addTarget(self, action: #selector(Send), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func commitButtonTapped (){
        self.view.endEditing(true)
    }

    func Send(){
        if toField.text != "" && amountField.text != "" {
            if(CheckReachability(host_name: "google.com")){
                let alertVC = PMAlertController(title: "送信中", description: "IRHを送信しています", image: UIImage(named: ""), style: .alert)
                self.present(alertVC, animated: true, completion: {
                    APIManager.assetOperation(command: "transfer", amount: self.amountField.text!, privateKey: KeychainManager.instance.keychain["privateKey"]!, receiver: self.toField.text!, completionHandler: {JSON in
                        if (JSON["status"] as! Int) == 200 {
                            
                        }else{
                            alertVC.dismiss(animated: false, completion: {
                                let alertVC = PMAlertController(title: "エラー", description: "\(JSON["message"]!)", image: UIImage(named: ""), style: .alert)
                                
                                alertVC.addAction(PMAlertAction(title: "OK", style: .cancel, action: { () -> Void in
                                }))
                                self.present(alertVC, animated: true, completion: nil)
                            })
                        }
                    })
                })
            }else{
                let alertVC = PMAlertController(title: "接続エラー", description: "ネットワークを確認してね", image: UIImage(named: ""), style: .alert)
                
                alertVC.addAction(PMAlertAction(title: "OK", style: .cancel, action: { () -> Void in
                }))
                
                self.present(alertVC, animated: true, completion: nil)
            }   
        } else if toField.text == "" {
            let alertVC = PMAlertController(title: "エラー", description: "送信先を入力してください", image: UIImage(named: ""), style: .alert)
            
            alertVC.addAction(PMAlertAction(title: "OK", style: .cancel, action: { () -> Void in
            }))
            
            self.present(alertVC, animated: true, completion: nil)
        } else {
            let alertVC = PMAlertController(title: "エラー", description: "送信量を入力してください", image: UIImage(named: ""), style: .alert)
            
            alertVC.addAction(PMAlertAction(title: "OK", style: .cancel, action: { () -> Void in
            }))
            
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

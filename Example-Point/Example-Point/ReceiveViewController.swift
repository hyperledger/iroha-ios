//
//  ReceiveViewController.swift
//  Example-Point
//
//  Created by Kaji Satoshi on 2016/12/12.
//  Copyright © 2016年 Soramitsu Co., Ltd. All rights reserved.
//

import UIKit
import TextFieldEffects
import IrohaSwift
import PMAlertController
import Toast_Swift

class ReceiveViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var accountLabel: UITextField!
    @IBOutlet weak var property: UILabel!
    @IBOutlet weak var qrImg: UIImageView!
    @IBOutlet weak var pubkey: UITextField!
    @IBOutlet weak var amountField: HoshiTextField!
    var qr:UIImage?
    let qrstr = "{\"account\":\"\(KeychainManager.instance.keychain["publicKey"]!)\","

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor.iroha
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.topViewController!.navigationItem.title = "Receive"
        self.tabBarController?.tabBar.tintColor = UIColor.irohaGreen
        property.text = "\(DataManager.instance.property) IRH"


    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(KeychainManager.instance.keychain["uuid"])
        // Do any additional setup after loading the view.
        amountField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(changeTextField), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)

        let pub = KeychainManager.instance.keychain["publicKey"]!
        pubkey.text = pub
        let qrmsg = "\(qrstr)\"amount\":0}"
        qr = createQRCode(message: qrmsg)
        qrImg.image = qr
        
        let keyboardHeader = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        keyboardHeader.barStyle = UIBarStyle.default
        keyboardHeader.sizeToFit()
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let commitButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: Selector("commitButtonTapped"))
        keyboardHeader.items = [spacer, commitButton]
        amountField.inputAccessoryView = keyboardHeader
        GetUserInfo()
        
        accountLabel.isUserInteractionEnabled = true
        accountLabel.delegate = self

    }
    
    
    func GetUserInfo(){
        //        self.tabBarController?.tabBar.isHidden = true
        
        if(CheckReachability(host_name: "google.com")){
            let alertVC = PMAlertController(title: "通信中", description: "アカウント情報を取得しています", image: UIImage(named: ""), style: .alert)
            self.present(alertVC, animated: true, completion: {
                APIManager.GetUserInfo(userId: KeychainManager.instance.keychain["uuid"]!, completionHandler: { JSON in
                    print(JSON)
                    if (JSON["status"] as! Int) == 200 {
                        var dicarr: [Dictionary<String, AnyObject>] = (JSON["assets"] as! NSArray) as! [Dictionary<String, AnyObject>]
                        print(dicarr[0]["value"])
                        DataManager.instance.property = dicarr[0]["value"] as! Int
                        self.property.text = "\(DataManager.instance.property) IRH"

                        alertVC.dismiss(animated: false, completion: nil)
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
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeTextField (sender: NSNotification) {
        if sender.object as! UITextField == amountField{
            let text = (sender.object as! UITextField).text
            var qrmsg = ""
            if text == "" {
                qrmsg = "\(qrstr)\"amount\":0}"
            } else {
                qrmsg = "\(qrstr)\"amount\":\(text!)}"
            }
            qr = createQRCode(message: qrmsg)
            qrImg.image = qr
        }
    }
    
    func commitButtonTapped (){
        self.view.endEditing(true)
    }

    @IBAction func OnCopy(_ sender: Any) {
        var style = ToastStyle()
        style.shadowColor = UIColor.iroha
        style.backgroundColor = UIColor.iroha
        style.messageColor = UIColor.white
        (sender as! UIButton).makeToast("copy to clipboard!", duration:1.0, position: .center, style: style)
        let board = UIPasteboard.general.string = "\(KeychainManager.instance.keychain["publicKey"]!)"

    }
 
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if amountField.text == "" && string == "0" {
            return false
        }
        return true
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



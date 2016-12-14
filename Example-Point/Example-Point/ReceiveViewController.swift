//
//  ReceiveViewController.swift
//  Example-Point
//
//  Created by Kaji Satoshi on 2016/12/12.
//  Copyright © 2016年 Soramitsu Co., Ltd. All rights reserved.
//

import UIKit
import TextFieldEffects

class ReceiveViewController: UIViewController {
    
    @IBOutlet weak var property: UILabel!
    @IBOutlet weak var qrImg: UIImageView!
    @IBOutlet weak var pubkey: UITextField!
    @IBOutlet weak var amountField: HoshiTextField!
    var qr:UIImage?
    let qrstr = "{\"account\":\(KeychainManager.instance.keychain["publicKey"]!),"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        amountField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(changeTextField), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)

        property.text = "\(DataManager.instance.property) IRH"
        let pub = KeychainManager.instance.keychain["publicKey"]!
        pubkey.text = pub
        let qrmsg = "\(qrstr),\"amount\":0}"
        qr = createQRCode(message: qrmsg)
        qrImg.image = qr
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
                qrmsg = "\(qrstr),\"amount\":0}"
            } else {
                qrmsg = "\(qrstr),\"amount\":\(text!)}"
            }
            qr = createQRCode(message: qrmsg)
            qrImg.image = qr
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


extension ReceiveViewController: UITextFieldDelegate {

}

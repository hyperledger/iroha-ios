//
//  RegisterViewController.swift
//  Example-Point
//
//  Created by Kaji Satoshi on 2016/12/14.
//  Copyright © 2016年 Soramitsu Co., Ltd. All rights reserved.
//

import UIKit
import TextFieldEffects
import IrohaSwift

class RegisterViewController: UIViewController {

    @IBOutlet weak var nameField: HoshiTextField!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerButton.layer.borderColor = UIColor.white.cgColor
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func Register () {
        if nameField.text == "" {
            
        } else {
            let keychain = KeychainManager.instance.keychain
            let keypair = IrohaSwift.createKeyPair()
            keychain["username"] = nameField.text
            keychain["publicKey"] = keypair.publicKey
            keychain["privateKey"] = keypair.privateKey
            
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

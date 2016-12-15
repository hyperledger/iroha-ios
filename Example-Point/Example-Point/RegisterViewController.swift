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
    
    @IBOutlet weak var backImg: UIImageView!
    

    @IBOutlet weak var nameField: HoshiTextField!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        rotateView(targetView: backImg)
        registerButton.layer.borderColor = UIColor.white.cgColor
        registerButton.addTarget(self, action: #selector(Register), for: .touchUpInside)
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
            let storyboard: UIStoryboard = self.storyboard!
            let nextVC = storyboard.instantiateViewController(withIdentifier: "Contents")
            self.present(nextVC, animated: true, completion: nil)
        }
    }
    
    func rotateView(targetView: UIImageView, duration: Double = 10.0) {
        UIImageView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
            targetView.transform = targetView.transform.rotated(by: CGFloat(M_PI))
        }) { finished in
            self.rotateView(targetView: targetView, duration: duration)
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

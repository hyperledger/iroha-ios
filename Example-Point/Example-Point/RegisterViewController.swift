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
import PMAlertController

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
        
        let keychain = KeychainManager.instance.keychain
        let keypair = IrohaSwift.createKeyPair()

        if nameField.text != "" {
            if(CheckReachability(host_name: "google.com")){
                let alertVC = PMAlertController(title: "登録中", description: "登録しています", image: UIImage(named: ""), style: .alert)
                self.present(alertVC, animated: true, completion: {
                    APIManager.Register(name: self.nameField.text!, pub: keypair.publicKey, completionHandler: { JSON in
                        print(JSON)
                        if (JSON["status"] as! Int) == 200 {
                            keychain["username"] = self.nameField.text
                            keychain["publicKey"] = keypair.publicKey
                            keychain["privateKey"] = keypair.privateKey
                            keychain["uuid"] = JSON["uuid"] as! String
                            alertVC.dismiss(animated: false, completion: nil)
                            let storyboard: UIStoryboard = self.storyboard!
                            let nextVC = storyboard.instantiateViewController(withIdentifier: "Contents")
                            self.present(nextVC, animated: true, completion: nil)
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
        } else {
            let alertVC = PMAlertController(title: "エラー", description: "ユーザー名を入力してください", image: UIImage(named: ""), style: .alert)
            
            alertVC.addAction(PMAlertAction(title: "OK", style: .cancel, action: { () -> Void in
            }))
            
            self.present(alertVC, animated: true, completion: nil)
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

/*
 Copyright Soramitsu Co., Ltd. 2016 All Rights Reserved.
 http://soramitsu.co.jp
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import UIKit
import TextFieldEffects
import PMAlertController

class SendViewController: UIViewController, UITextFieldDelegate {
    
    var to = ""
    var amount = ""
    
    // 末尾はUIパーツ名をちゃんとつける
    @IBOutlet weak var toField: HoshiTextField!
    @IBOutlet weak var amountField: HoshiTextField!
    @IBOutlet weak var sendButton: UIButton!
    let color = Bundle.main.infoDictionary?["AppColor"] as! String;

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor.hex(hex: color, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.topViewController!.navigationItem.title = "Send"
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.tintColor = UIColor.irohaYellow
        toField.text = to
        amountField.text = amount
        amountField.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        let keyboardHeader = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        keyboardHeader.barStyle = UIBarStyle.default
        keyboardHeader.sizeToFit()
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let commitButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: Selector("commitButtonTapped"))
        keyboardHeader.items = [spacer, commitButton]
        toField.inputAccessoryView = keyboardHeader
        amountField.inputAccessoryView = keyboardHeader
        
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
        if toField.text == KeychainManager.instance.keychain["publicKey"]! {
            let alertVC = PMAlertController(title: "エラー", description: "自分に送ることはできません", image: UIImage(named: ""), style: .alert)
            
            alertVC.addAction(PMAlertAction(title: "OK", style: .cancel, action: { () -> Void in
                self.toField.text = ""
                self.amountField.text = ""
            }))
            
            self.present(alertVC, animated: true, completion: nil)

        }else {
            if toField.text != "" && amountField.text != "" {
                if(CheckReachability(host_name: "google.com")){
                    let alertVC = PMAlertController(title: "送信中", description: "IRHを送信しています", image: UIImage(named: ""), style: .alert)
                    self.present(alertVC, animated: true, completion: {
                        APIManager.assetOperation(command: "transfer", amount: self.amountField.text!, privateKey: KeychainManager.instance.keychain["privateKey"]!, receiver: self.toField.text!, completionHandler: {JSON in
                            print(JSON)
                            if (JSON["status"] as! Int) == 200 {
                                let parameter = ["asset-uuid":"91f2d81f6008bb98bb79e28b227f02b91b2642ad945213c2c1715d934feace01","name":"iroha", "timestamp": 1482053967, "params": ["command":"Transfer","receiver":self.toField.text!,"sender":KeychainManager.instance.keychain["publicKey"]!,"value":self.amountField.text!]] as [String : Any]
                                let walletvc = (self.tabBarController?.viewControllers?[1] as! UINavigationController).viewControllers[0] as! WalletTableViewController
                                walletvc.myItems?.append(parameter as [String : AnyObject])
                                //                            DataManager.instance.property += (self.amountField.text! as! Int)
                                alertVC.dismiss(animated: false, completion: {
                                    let alertVC = PMAlertController(title: "完了", description: "送金が完了しました", image: UIImage(named: ""), style: .alert)
                                    
                                    alertVC.addAction(PMAlertAction(title: "OK", style: .cancel, action: { () -> Void in
                                        self.toField.text = ""
                                        self.amountField.text = ""
                                    }))
                                    self.present(alertVC, animated: true, completion: nil)
                                })
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

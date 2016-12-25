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
import IrohaSwift
import PMAlertController
import Toast_Swift

class ReceiveViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var accountLabel: UITextField!
    @IBOutlet weak var property: UILabel!
    @IBOutlet weak var qrImg: UIImageView!
    @IBOutlet weak var pubkey: UITextField!
    @IBOutlet weak var amountField: HoshiTextField!
    @IBOutlet weak var headerback: UIView!
    
    var qr:UIImage?
    let qrstr = "{\"account\":\"\(KeychainManager.instance.keychain["publicKey"]!)\","
    let unit = Bundle.main.infoDictionary?["Unit"] as! String;
    let color = Bundle.main.infoDictionary?["AppColor"] as! String;


    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.navigationController?.navigationBar.barTintColor = UIColor.iroha
        self.navigationController?.navigationBar.barTintColor = UIColor.hex(hex: color, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.topViewController!.navigationItem.title = "Receive"
        self.tabBarController?.tabBar.tintColor = UIColor.irohaGreen
        property.text = "\(DataManager.instance.property) \(unit)"


    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        headerback.backgroundColor = UIColor.hex(hex: color, alpha: 1)
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
                    if (JSON["status"] as! Int) == 200 {
                        var dicarr: [Dictionary<String, AnyObject>] = (JSON["assets"] as! NSArray) as! [Dictionary<String, AnyObject>]
                        DataManager.instance.property = dicarr[0]["value"] as! Int
                        self.property.text = "\(DataManager.instance.property) \(self.unit)"

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
        style.shadowColor = UIColor.hex(hex: color, alpha: 1)
        style.backgroundColor = UIColor.hex(hex: color, alpha: 1)
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
    
    @IBAction func ResetUserData(_ sender: Any) {
        let keychain = KeychainManager.instance.keychain
        keychain["privateKey"] = ""
        keychain["publicKey"] = ""
        let storyboard: UIStoryboard = self.storyboard!
        let nextVC = storyboard.instantiateViewController(withIdentifier: "Register")
        self.present(nextVC, animated: true, completion: nil)
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



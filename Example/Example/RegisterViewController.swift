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

//
//  RegisterViewController.swift
//  Example
//
//  Created by Kaji Satoshi on 2016/09/21.
//  Copyright © 2016年 Kaji Satoshi. All rights reserved.
//

import UIKit
import IrohaSwift

class RegisterViewController: UIViewController ,UITextFieldDelegate{
    
    @IBOutlet weak var wrapperScrollView: UIScrollView!
    @IBOutlet weak var accessField: UITextField!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var accountCreateButton: UIButton!
    
    
    var underActiveFieldRect = CGRect()
    var alertController = UIAlertController()

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(shownKeyboard), name:Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hiddenKeyboard), name:Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        accessField.delegate = self
        userNameField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == accessField {
            underActiveFieldRect = userNameField.frame
        }else if textField == userNameField{
            underActiveFieldRect = accountCreateButton.frame
        }
        return true
    }
    
    func shownKeyboard(notification: Notification) {
        if let userInfo = notification.userInfo {
            if let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] {
                wrapperScrollView.contentInset = UIEdgeInsets.zero
                wrapperScrollView.scrollIndicatorInsets = UIEdgeInsets.zero
                let convertedKeyboardFrame = wrapperScrollView.convert(keyboardFrame, from: nil)
                let offsetY: CGFloat =  underActiveFieldRect.maxY - convertedKeyboardFrame.minY
                if offsetY < 0 {
                    return
                }
                updateScrollViewSize(moveSize: offsetY, duration: animationDuration as! TimeInterval)
               
            }
        }
    }
    
    func hiddenKeyboard(notification: Notification) {
        wrapperScrollView.contentInset = UIEdgeInsets.zero
        wrapperScrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    func updateScrollViewSize(moveSize: CGFloat, duration: TimeInterval) {
        UIView.beginAnimations("ResizeForKeyboard", context: nil)
        UIView.setAnimationDuration(duration)
        
        let contentInsets = UIEdgeInsetsMake(0, 0, moveSize, 0)
        wrapperScrollView.contentInset = contentInsets
        wrapperScrollView.scrollIndicatorInsets = contentInsets
        wrapperScrollView.contentOffset = CGPoint(x: 0,y :moveSize)
        UIView.commitAnimations()
    }

    
    
    @IBAction func onClickCreate(_ sender: AnyObject) {
        if(accessField.text == "" || userNameField.text == ""){
            alertController = UIAlertController(title: "警告", message: "すべての情報を入力してください", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)

        }else{
            alertController = UIAlertController(title: nil, message: "口座開設中\n\n\n", preferredStyle: UIAlertControllerStyle.alert)
            let spinnerIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        
            spinnerIndicator.center = CGPoint(x:135.0, y:65.5)
            spinnerIndicator.color = UIColor.black
            spinnerIndicator.startAnimating()
        
            alertController.view.addSubview(spinnerIndicator)
            self.present(alertController, animated: false, completion: {
                let keypair = IrohaSwift.createKeyPair()
                do{
                    try KeychainManager.sharedManager.keychain.set(self.accessField.text!, key: "accessPoint")
                    try KeychainManager.sharedManager.keychain.set(keypair.publicKey, key: "publicKey")
                    try KeychainManager.sharedManager.keychain.set(keypair.privateKey, key: "privateKey")
                }catch{
                    print("error")
                }
                IrohaSwift.setDatas(accessPoint: self.accessField.text!, publicKey: keypair.publicKey)
                let res = IrohaSwift.register(name: self.userNameField.text!)
                if res["status"] as! Int == 200 {
                    do{
                        try KeychainManager.sharedManager.keychain.set(res["uuid"] as! String, key: "uuid")
                    }catch{
                        print("error")
                    }
                    IrohaSwift.setDatas(uuid: res["uuid"] as! String)
                    self.alertController.dismiss(animated: false, completion: {() -> Void in
                        let nextvc = self.storyboard?.instantiateViewController(withIdentifier: "Tabbar")
                        self.present(nextvc!, animated: true, completion: nil)
                    })
                } else {
                    self.alertController.dismiss(animated: false, completion: {() -> Void in
                        do {
                            try KeychainManager.sharedManager.keychain.remove("privateKey")
                            try KeychainManager.sharedManager.keychain.remove("publicKey")
                        } catch let error {
                            print("error: \(error)")
                        }
                        self.alertController = UIAlertController(title: String(describing: res["status"]!) , message: res["message"] as! String?, preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        self.alertController.addAction(defaultAction)
                        self.present(self.alertController, animated: true, completion: nil)
                    })
                }
            })
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

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
//  CreateAssetViewController.swift
//  Example
//
//  Created by Kaji Satoshi on 2016/09/20.
//  Copyright © 2016年 Kaji Satoshi. All rights reserved.
//

import Foundation
import UIKit
import IrohaSwift

class CreateAssetViewController : UIViewController, UITextFieldDelegate {
    @IBOutlet weak var assetNameField: UITextField!
    @IBOutlet weak var domainNameField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var wrapperScrollView: UIScrollView!
    
    var underActiveFieldRect = CGRect()
    var creatAssetAlert = UIAlertController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(shownKeyboard), name:Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hiddenKeyboard), name:Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        assetNameField.delegate = self
        domainNameField.delegate = self
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickCreate(_ sender: AnyObject) {
        self.view.endEditing(true)
        if(domainNameField.text == "" || assetNameField.text == ""){
            creatAssetAlert = UIAlertController(title: "警告", message: "すべての情報を入力してください", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            creatAssetAlert.addAction(defaultAction)
            present(creatAssetAlert, animated: true, completion: nil)
            
        }else{
            creatAssetAlert = UIAlertController(title: nil, message: "アセット作成中\n\n\n", preferredStyle: UIAlertControllerStyle.alert)
            let spinnerIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
            
            spinnerIndicator.center = CGPoint(x:135.0, y:65.5)
            spinnerIndicator.color = UIColor.black
            spinnerIndicator.startAnimating()
            
            creatAssetAlert.view.addSubview(spinnerIndicator)
            
            self.present(creatAssetAlert, animated: false, completion: { () -> Void in
                var data:Dictionary<String, String>
                let keychain = KeychainManager.sharedManager.keychain
                let key = keychain["privateKey"]!
                let res = IrohaSwift.domainRegister(domain: self.domainNameField.text!,privateKey: key )
                if (res["status"] as! Int) == 200 {
                    let res = IrohaSwift.createAsset(domain: self.domainNameField.text!,privateKey: key , name: self.assetNameField.text!)
                    if (res["status"] as! Int) == 200{
                        data = ["domain":self.domainNameField.text!, "name":self.assetNameField.text!, "asset-uuid":res["asset-uuid"] as! String]
                        AssetsDataManager.sharedManager.assetsDataArray.append(data)
                        self.saveAssetsData(assetsDatas: AssetsDataManager.sharedManager.assetsDataArray)
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        self.creatAssetAlert.dismiss(animated: false, completion: {() -> Void in
                            self.creatAssetAlert = UIAlertController(title: String(describing: res["status"]!) ,    message: res["message"] as! String?, preferredStyle: .alert)
                            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            self.creatAssetAlert.addAction(defaultAction)
                            self.present(self.creatAssetAlert, animated: true, completion: {() -> Void in
                                self.navigationController?.popViewController(animated: true)
                            })
                        })
                    }
                }
            })
        }
    }
    
    func saveAssetsData(assetsDatas: [Dictionary<String, Any>]) {
        let defaults = UserDefaults.standard
        defaults.set(assetsDatas, forKey: "Assets")
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == domainNameField {
            underActiveFieldRect = (assetNameField.superview?.frame)!
        }else if textField == assetNameField{
            underActiveFieldRect = createButton.frame
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

}

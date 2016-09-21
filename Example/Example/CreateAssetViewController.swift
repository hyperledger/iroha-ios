//
//  CreateAssetViewController.swift
//  Example
//
//  Created by Kaji Satoshi on 2016/09/20.
//  Copyright © 2016年 Kaji Satoshi. All rights reserved.
//

import Foundation
import UIKit

class CreateAssetViewController : UIViewController, UITextFieldDelegate {
    @IBOutlet weak var assetNameField: UITextField!
    @IBOutlet weak var domainNameField: UITextField!
    @IBOutlet weak var amountField: UITextField!
    
    @IBOutlet weak var createButton: UIButton!
    var underActiveFieldRect = CGRect()
    
    @IBOutlet weak var wrapperScrollView: UIScrollView!
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
        amountField.delegate = self
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickCreate(_ sender: AnyObject) {
        var data:Dictionary<String, Any>
        data = ["domain":domainNameField.text, "asset":assetNameField.text, "amount":Int(amountField.text!)]
        AssetsDataManager.sharedManager.assetsDataArray.append(data)
        saveAssetsData(assetsDatas: AssetsDataManager.sharedManager.assetsDataArray)
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
            underActiveFieldRect = (amountField.superview?.frame)!
        }else{
            underActiveFieldRect = createButton.frame
        }
        return true
    }
    
    func shownKeyboard(notification: Notification) {
        print("Shown")
        if let userInfo = notification.userInfo {
            print(userInfo[UIKeyboardFrameEndUserInfoKey])
            print(userInfo[UIKeyboardAnimationDurationUserInfoKey])
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

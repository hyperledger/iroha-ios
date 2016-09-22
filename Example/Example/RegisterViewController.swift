//
//  RegisterViewController.swift
//  Example
//
//  Created by Kaji Satoshi on 2016/09/21.
//  Copyright © 2016年 Kaji Satoshi. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController ,UITextFieldDelegate{
    
    @IBOutlet weak var wrapperScrollView: UIScrollView!
    @IBOutlet weak var accessField: UITextField!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var accountCreateButton: UIButton!
    
    
    var underActiveFieldRect = CGRect()
    
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
        print("Shown")
        if let userInfo = notification.userInfo {
            print(userInfo[UIKeyboardFrameEndUserInfoKey])
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
        print("hide")
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

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

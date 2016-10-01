//
//  AccountInfoViewController.swift
//  Example
//
//  Created by Kaji Satoshi on 2016/09/21.
//  Copyright © 2016年 Kaji Satoshi. All rights reserved.
//

import UIKit
import IrohaSwift
import KeychainAccess

class AccountInfoViewController: UIViewController {
    
    
    @IBOutlet weak var QRImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        let qrString = KeychainManager.sharedManager.keychain["publicKey"]
        QRImage.image = createQRCode(message: qrString!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

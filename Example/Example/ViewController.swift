//
//  ViewController.swift
//  Example
//
//  Created by Kaji Satoshi on 2016/09/18.
//  Copyright © 2016年 Kaji Satoshi. All rights reserved.
//

import UIKit
import IrohaSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(createSeed())
        var keyPair = createKeyPair()
        var sig = sign(keyPair.publicKey, privateKey: keyPair.privateKey, message: "Test")
        print(verify(keyPair.publicKey, signature: sig, message: "Test"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


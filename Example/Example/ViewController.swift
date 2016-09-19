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
        let reg = IrohaSwift.register(ip: "myhostName", port: nil, name: "hoge")
        print(reg)
        IrohaSwift.assetTransfar(name: "a", domain: "a", amount: "100", reciever: "hoge")
        let assets = IrohaSwift.getAsset()
        print(assets)
        IrohaSwift.setAddress(ip: "192.168.1.1", port: nil)
        print(getAddress())

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


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
//  QRGenerator.swift
//  Example
//
//  Created by Kaji Satoshi on 2016/09/22.
//  Copyright © 2016年 Kaji Satoshi. All rights reserved.
//

import Foundation
import UIKit
import CoreImage

func createQRCode(message: String, correctionLevel: String = "L", moduleSize: CGFloat = 1) -> UIImage {
    
    let dat = message.data(using: String.Encoding.utf8)!
    
    let qr = CIFilter(name: "CIQRCodeGenerator", withInputParameters: [
        "inputMessage": dat,
        "inputCorrectionLevel": correctionLevel,
        ])!
    
    // moduleSize でリサイズ
    let sizeTransform = CGAffineTransform(scaleX: 100 , y: 100)
    let ciImg = qr.outputImage!.applying(sizeTransform)
    let image:UIImage = UIImage(ciImage: ciImg, scale: 1, orientation: .up)
    let size = CGSize(width: 160, height: 160)
    UIGraphicsBeginImageContext(size)
    image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
    let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return resizeImage!
}

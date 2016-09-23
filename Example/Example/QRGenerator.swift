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

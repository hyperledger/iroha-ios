//
//  QRImgGenerator.swift
//  Example-Point
//
//  Created by Kaji Satoshi on 2016/12/12.
//  Copyright © 2016年 Soramitsu Co., Ltd. All rights reserved.
//


import Foundation
import UIKit
import CoreImage

func createQRCode(message: String, size: Int = 100, correctionLevel: String = "L") -> UIImage {
    let data = message.data(using: String.Encoding.utf8)!
    let qrFilter = CIFilter(name: "CIQRCodeGenerator")!
    
    qrFilter.setDefaults()
    qrFilter.setValue(data, forKey: "inputMessage")
    qrFilter.setValue("H", forKey: "inputCorrectionLevel")
    let sizeTransform = CGAffineTransform(scaleX: CGFloat(size) , y: CGFloat(size))
    let ciImage = qrFilter.outputImage!.applying(sizeTransform)
    
    return UIImage(ciImage: ciImage, scale: 1, orientation: .up)
    
}

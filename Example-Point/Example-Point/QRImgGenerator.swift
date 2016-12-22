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

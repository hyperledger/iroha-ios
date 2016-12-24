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


import UIKit

extension UIColor {
    
    class var iroha:UIColor {
        get {
            return UIColor(red: 228/255, green: 35/255, blue: 45/255, alpha: 1)
        }
    }
    
    class var irohaGreen:UIColor {
        get {
            return UIColor(red: 120/255, green: 255/255, blue: 131/255, alpha: 1)
        }
    }
    
    class var irohaYellow:UIColor {
        get {
            return UIColor(red: 255/255, green: 228/255, blue: 75/255, alpha: 1)
        }
    }

}

extension UIColor {
    class func hex ( hex : String, alpha : CGFloat) -> UIColor {
        let hexStr = hex.replacingOccurrences(of: "#", with: "") as NSString
        let scanner = Scanner(string: hexStr as String)
        var color: UInt32 = 0
        if scanner.scanHexInt32(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(color & 0x0000FF) / 255.0
            return UIColor(red:r,green:g,blue:b,alpha:alpha)
        } else {
            return UIColor.white
        }
    }
}

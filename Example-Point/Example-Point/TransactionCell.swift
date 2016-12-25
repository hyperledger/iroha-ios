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

class TransactionCell: UITableViewCell {
    
    let color = UIColor.black
    var pay = false
    var value = 0;
    var trans: UIView?
    var transLabel:UILabel?
    var label:UILabel?
    var dateLabel:UILabel?
    var oppLabel:UILabel?
    var typeImg:UIImageView?
    let ovalShapeLayer = CAShapeLayer()
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        trans = UIView()
        trans!.frame = CGRect(x:0, y: 0, width: UIScreen.main.bounds.size.width, height: 60)
        self.addSubview(trans!)
        
//        // 円のCALayer作成
//        ovalShapeLayer.strokeColor = UIColor.white.cgColor
//        ovalShapeLayer.fillColor = UIColor.white.cgColor
//        ovalShapeLayer.lineWidth = 0.0
//        
//        // 図形は円形
//        ovalShapeLayer.path = UIBezierPath(ovalIn: CGRect(x: 10, y: 22, width: 15.0, height: 15.0)).cgPath
//        self.layer.addSublayer(ovalShapeLayer)
//
        typeImg = UIImageView(frame: CGRect(x:10, y:10, width:trans!.frame.height-20, height:trans!.frame.height-20))
        typeImg?.image = UIImage(named: "icon_send")
        trans!.addSubview(typeImg!)

        let lineLeft:CGFloat = trans!.frame.origin.x + trans!.frame.width
        //        let lineMargin:CGFloat = 12
        label = UILabel()
        label = UILabel(frame: CGRect(x:0, y:0, width:trans!.frame.width-10, height:trans!.frame.height))
        label!.backgroundColor = UIColor.clear
        label!.textColor = UIColor.black
        label!.font = UIFont.boldSystemFont(ofSize: 22)
        label!.textAlignment = .right
        trans!.addSubview(label!)
        
        dateLabel = UILabel()
        dateLabel = UILabel(frame: CGRect(x:0, y:-20, width:trans!.frame.width-4, height:trans!.frame.height))
        dateLabel!.backgroundColor = UIColor.clear
        dateLabel!.textColor = UIColor.gray
        dateLabel!.font = UIFont.boldSystemFont(ofSize: 14)
        dateLabel!.textAlignment = .right
        dateLabel?.text = "100"
        trans!.addSubview(dateLabel!)
        
        oppLabel = UILabel()
        oppLabel = UILabel(frame: CGRect(x:trans!.frame.height, y:0, width:trans!.frame.width-100, height:trans!.frame.height))
        oppLabel!.backgroundColor = UIColor.clear
        oppLabel!.textColor = UIColor.gray
        oppLabel!.font = UIFont.boldSystemFont(ofSize: 15)
        oppLabel!.textAlignment = .left
        oppLabel!.text = "from hoge"
        trans!.addSubview(oppLabel!)
        
        let sepalator = UIView()
        sepalator.frame = CGRect(x: 0, y: 60 - 1, width: UIScreen.main.bounds.size.width, height: 1)
        sepalator.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        self.addSubview(sepalator)
    }
    
    func fillWith(isSender:Bool, oppo:String, valueText: String, time: Int) {
        if(isSender){
            self.typeImg?.image = UIImage(named: "icon_send-2")
            oppLabel!.text = "to \(oppo)"
        }else{
            self.typeImg?.image = UIImage(named: "icon_receive-2")
            oppLabel!.text = "from \(oppo)"
        }
        dateLabel?.text = calcTimeDiff(time: time)
        self.label?.text = valueText
    }
    
    func fillWithRegister(time: Int) {
        dateLabel?.text = calcTimeDiff(time: time)
        oppLabel!.text = "Register"
        self.typeImg?.image = UIImage(named: "icon_receive-2")
        self.label?.text = "100"
    }
    
    func calcTimeDiff(time:Int) -> String{
        let sec = Int(Date().timeIntervalSince1970) - time
        if (sec <= 0) {
            return "now";
        } else if (sec < 60) {
            return "\(sec) sec";
        } else if (sec < 3600) {
            return "\(Int(round(Double(sec/60)))) min";
        } else if (sec < 3600 * 24) {
            return "\(Int(round(Double(sec / (60 * 60))))) hour";
        } else if (sec < 3600 * 24 * 31) {
            return "\(Int(round(Double(sec / (60 * 60 * 24))))) day";
        } else {
            let date = Date(timeIntervalSince1970: TimeInterval(time));
            let formatter = DateFormatter()
            formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale!
            formatter.dateFormat = "yyyy/MM/dd"
            formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone!
            return formatter.string(from: date)
        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addLine(frame:CGRect) {
        let line = UIView(frame:frame)
        line.layer.cornerRadius = frame.height / 2
        line.backgroundColor = color
        self.addSubview(line)
    }
}

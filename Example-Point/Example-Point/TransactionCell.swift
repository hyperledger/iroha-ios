//
//  TransactionCEll.swift
//  Example-Point
//
//  Created by Kaji Satoshi on 2016/12/15.
//  Copyright © 2016年 Soramitsu Co., Ltd. All rights reserved.
//

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
    let ovalShapeLayer = CAShapeLayer()
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        trans = UIView()
        trans!.frame = CGRect(x:0, y: 0, width: UIScreen.main.bounds.size.width, height: 60)
        self.addSubview(trans!)
        
        // 円のCALayer作成
        ovalShapeLayer.strokeColor = UIColor.white.cgColor
        ovalShapeLayer.fillColor = UIColor.white.cgColor
        ovalShapeLayer.lineWidth = 0.0
        
        // 図形は円形
        ovalShapeLayer.path = UIBezierPath(ovalIn: CGRect(x: 10, y: 22, width: 15.0, height: 15.0)).cgPath
        self.layer.addSublayer(ovalShapeLayer)
        
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
        oppLabel = UILabel(frame: CGRect(x:30, y:0, width:trans!.frame.width-20, height:trans!.frame.height))
        oppLabel!.backgroundColor = UIColor.clear
        oppLabel!.textColor = UIColor.gray
        oppLabel!.font = UIFont.boldSystemFont(ofSize: 15)
        oppLabel!.textAlignment = .left
        oppLabel!.text = "from hoge-chan"
        trans!.addSubview(oppLabel!)
        
        let sepalator = UIView()
        sepalator.frame = CGRect(x: 0, y: 60 - 1, width: UIScreen.main.bounds.size.width, height: 1)
        sepalator.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        self.addSubview(sepalator)
    }
    
    func fillWithFulu(backgroundColor: UIColor, textColor: UIColor, isSender:Bool, oppo:String, valueText: String, time: Int) {
        self.ovalShapeLayer.fillColor = backgroundColor.cgColor
        self.transLabel?.textColor = textColor
        oppLabel!.text = "shake \(oppo)"
        dateLabel?.text = calcTimeDiff(time: time)
        self.label?.text = valueText
    }
    
    func fillWith(backgroundColor: UIColor, textColor: UIColor, isSender:Bool, oppo:String, valueText: String, time: Int) {
        self.ovalShapeLayer.fillColor = backgroundColor.cgColor
        self.transLabel?.textColor = textColor
        if(isSender){
            oppLabel!.text = "to \(oppo)"
        }else{
            oppLabel!.text = "from \(oppo)"
        }
        dateLabel?.text = calcTimeDiff(time: time)
        self.label?.text = valueText
    }
    
    func calcTimeDiff(time:Int) -> String{
        let sec = Int(Date().timeIntervalSince1970) - time
        if (sec <= 0) {
            return "now";
        } else if (sec < 60) {
            return "\(sec)秒前";
        } else if (sec < 3600) {
            return "\(Int(round(Double(sec/60)))) 分前";
        } else if (sec < 3600 * 24) {
            return "\(Int(round(Double(sec / (60 * 60))))) 時間前";
        } else if (sec < 3600 * 24 * 31) {
            return "\(Int(round(Double(sec / (60 * 60 * 24))))) 日前";
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

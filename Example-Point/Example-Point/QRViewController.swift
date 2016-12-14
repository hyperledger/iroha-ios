//
//  QRViewController.swift
//  Example-Point
//
//  Created by Kaji Satoshi on 2016/12/12.
//  Copyright © 2016年 Soramitsu Co., Ltd. All rights reserved.
//


import Foundation
import UIKit
import AVFoundation
import PMAlertController

class QRViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate{
    
    
    @IBOutlet weak var cameraRegion: UIImageView!
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer?
    var captureDevice: AVCaptureDevice?
    var input:AVCaptureDeviceInput!
    var output: AVCaptureMetadataOutput!
    var dataValueDict: Dictionary<String, String> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraRegion.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.tabBarController?.tabBar.isHidden = true
        
        cameraSetting()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.captureSession.stopRunning()
        for output in self.captureSession.outputs {
            self.captureSession.removeOutput(output as? AVCaptureOutput)
        }
        
        for input in self.captureSession.inputs {
            self.captureSession.removeInput(input as? AVCaptureInput)
        }
        self.captureSession = nil
        self.captureDevice = nil
    }
    
    
    func cameraSetting(){
        
        self.captureSession = AVCaptureSession()
        
        self.captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do {
            self.input = try AVCaptureDeviceInput(device: self.captureDevice) as AVCaptureDeviceInput
        } catch let error as NSError {
            print(error)
        }
        
        if(self.captureSession.canAddInput(self.input)) {
            self.captureSession.addInput(self.input)
        }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        self.previewLayer!.frame = self.cameraRegion.frame
        self.previewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        self.view.layer.addSublayer(self.previewLayer!)
        
        self.output = AVCaptureMetadataOutput();
        self.output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main);
        self.captureSession.addOutput(self.output);
        
        self.output.metadataObjectTypes = [AVMetadataObjectTypeQRCode];
        
        self.captureSession.startRunning()
        self.view.sendSubview(toBack: self.cameraRegion)
        
    }
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        self.captureSession.stopRunning()
        for data in metadataObjects {
            if (data as AnyObject).type == AVMetadataObjectTypeQRCode {
                let dataValue: String = (data as! AVMetadataMachineReadableCodeObject).stringValue
                let cnvData = convertStringToDictionary(text: dataValue)
                print(cnvData)
                if let dataDict = cnvData {
                    if(dataDict["type"] as! String == "trans"){
                        if(dataDict["account"] as! String == KeychainManager.sharedManager.keychain["publicKey"]){
                            let alertVC = PMAlertController(title: "エラー", description: "自分に送信することはできません", image: UIImage(named: "tibihash3.png"), style: .alert)
                            
                            alertVC.addAction(PMAlertAction(title: "OK", style: .cancel, action: { () -> Void in
                                self.captureSession.startRunning()
                            }))
                            self.present(alertVC, animated: true, completion: nil)
                        }
                        if(dataDict["value"]! as! Int == 0){
                            let alertVC = PMAlertController(title: "エラー", description: "要求額が正しくありません", image: UIImage(named: "tibihash3.png"), style: .alert)
                            
                            alertVC.addAction(PMAlertAction(title: "OK", style: .cancel, action: { () -> Void in
                                self.captureSession.startRunning()
                            }))
                            self.present(alertVC, animated: true, completion: nil)
                        }else{
                            self.captureSession.stopRunning()
                            let prevvc = navigationController?.viewControllers[(navigationController?.viewControllers.count)! - 1] as! SendViewController
                            
                            navigationController?.popViewController(animated: true)
                        }
                    }else{
                        let alertVC = PMAlertController(title: "エラー", description: "不正なQRコードです", image: UIImage(named: "tibihash3.png"), style: .alert)
                        
                        alertVC.addAction(PMAlertAction(title: "OK", style: .cancel, action: { () -> Void in
                            self.captureSession.startRunning()
                        }))
                        self.present(alertVC, animated: true, completion: nil)
                    }
                }else{
                    let alertVC = PMAlertController(title: "エラー", description: "不正なQRコードです", image: UIImage(named: "tibihash3.png"), style: .alert)
                    
                    alertVC.addAction(PMAlertAction(title: "OK", style: .cancel, action: { () -> Void in
                        self.captureSession.startRunning()
                    }))
                    self.present(alertVC, animated: true, completion: nil)
                }
                
            }
        }
        
    }
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
}

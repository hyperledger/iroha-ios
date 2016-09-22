//
//  QRViewController.swift
//  Example
//
//  Created by Kaji Satoshi on 2016/09/21.
//  Copyright © 2016年 Kaji Satoshi. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

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
        print(cameraRegion.frame)
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
                print(dataValue)
                self.captureSession.stopRunning()
                let prevvc = navigationController?.viewControllers[(navigationController?.viewControllers.count)! - 2] as! TransferViewController
                prevvc.toAccount = dataValue
                print(prevvc)
                navigationController?.popViewController(animated: true)
            }
        }

    }

}

//
//  ViewController.swift
//  ARPractice
//
//  Created by 谭钧豪 on 16/8/7.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation

let screen = UIScreen.mainScreen().bounds

class ViewController: UIViewController {
    
    var imageView:UIImageView!
    
    var captureSession:AVCaptureSession!

    override func viewDidLoad() {
        super.viewDidLoad()
        let spaceManager = SpaceMotionManager()
        spaceManager.delegate = self
        spaceManager.startUpdate()
        imageView = UIImageView(image: UIImage(named: "IMG_8737"))
        imageView.center = CGPoint(x: screen.width/2, y: screen.height/2)
        self.view.addSubview(imageView)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ///添加相机（暂未添加）
    func start(){
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        var input:AVCaptureInput!
        do{input = try AVCaptureDeviceInput(device: captureDevice)}catch{print(error)}
        captureSession.addInput(input)
        
    }


}

extension ViewController: SpaceMotionDelegate{
    
    ///实现方位更新之后，控件模拟现实位置，但是平移暂未实现。
    func spaceDidUpdate(rotation: CGFloat, attitude: CMAttitude, realAcceleration: CMAcceleration) {
        let xOffset = CGFloat(1000*tan(attitude.roll))
        let yOffset = CGFloat(1000*tan(attitude.pitch))
        var transform = CGAffineTransformIdentity
        transform = CGAffineTransformTranslate(transform, xOffset, yOffset)
        transform = CGAffineTransformRotate(transform, rotation)
        if fabs(realAcceleration.x) > 1.3{
            self.imageView.frame.origin.x += CGFloat(1000*realAcceleration.x)
        }
        if fabs(realAcceleration.y) > 1.3{
            self.imageView.frame.origin.y += CGFloat(1000*realAcceleration.y)
        }
        if fabs(realAcceleration.z) > 1.3{
//            transform = CGAffineTransformScale(transform, <#T##sx: CGFloat##CGFloat#>, <#T##sy: CGFloat##CGFloat#>)
        }
        self.imageView.transform = transform
        
    }
}


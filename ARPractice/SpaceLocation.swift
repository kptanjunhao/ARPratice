//
//  SpaceLocation.swift
//  ARPractice
//
//  Created by 谭钧豪 on 16/8/7.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//

import UIKit
import CoreMotion


protocol SpaceMotionDelegate{
    func spaceDidUpdate(rotation:CGFloat,attitude:CMAttitude,realAcceleration:CMAcceleration)
}

class SpaceMotionManager :NSObject{
    let manager:CMMotionManager
    
    var horizontalAngle:CGFloat = 0.0
    var verticalAngle:CGFloat = 0.0
    var magneticAngle:CGFloat = 0.0
    var initialAttitude:CMAttitude!
    
    var delegate:SpaceMotionDelegate?
    
    var isUpdating:Bool = false
    
    let updateInterval:NSTimeInterval = 0.02
//    let updateInterval:NSTimeInterval = 1
    
    override init(){
        manager = CMMotionManager()
        super.init()
    }
    
    ///开始获取方位信息
    func startUpdate(){
        if isUpdating{
            return
        }
        isUpdating = true
        let queue = NSOperationQueue.mainQueue()
        
        if manager.deviceMotionAvailable{
            
            manager.deviceMotionUpdateInterval = updateInterval
            manager.startDeviceMotionUpdatesToQueue(queue) {
                data,error in
                guard let data = data else{return}
                let rotation = atan2(data.gravity.x, data.gravity.y) - M_PI
                
                
                print("实际加速度！－－－－－－－－－－－－－－")
                print(data.userAcceleration.x)
                print(data.userAcceleration.y)
                print(data.userAcceleration.z)
                
                if self.initialAttitude == nil {
                    self.initialAttitude = data.attitude
                    return
                }
                
                let realAcceleration = CMAcceleration(x: data.gravity.x + data.userAcceleration.x,
                                                      y: data.gravity.y + data.userAcceleration.y,
                                                      z: data.gravity.z + data.userAcceleration.z)
                data.attitude.multiplyByInverseOfAttitude(self.initialAttitude)
                self.delegate?.spaceDidUpdate(CGFloat(rotation), attitude: data.attitude, realAcceleration: realAcceleration)
                
                
            }
        }
        
    }
    
    func stopUpdating(){
        if !isUpdating{
            return
        }
        isUpdating = false
        manager.stopAccelerometerUpdates()
        manager.stopDeviceMotionUpdates()
        manager.stopGyroUpdates()
        manager.stopMagnetometerUpdates()
    }
    
//    func magnitudeFromAttitude(attitude: CMAttitude) -> Double{
//        return sqrt(pow(attitude.roll, 2) + pow(attitude.yaw, 2) + pow(attitude.pitch, 2))
//    }
    
    
    
}
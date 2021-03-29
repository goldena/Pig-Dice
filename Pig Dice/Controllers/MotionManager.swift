//
//  MotionManager.swift
//  Pig Dice
//
//  Created by Denis Goloborodko on 21.03.21.
//

import UIKit
import CoreMotion

protocol MotionManagerDelegate {
    func acceleratorDataUpdated(gravityDirection: CGVector)
}

class MotionManager {
    
    private var motionManager: CMMotionManager!
    private var accelerometerUpdatesOperationQueue: OperationQueue!
    
    var gravityDirection: CGVector!
    var delegate: MotionManagerDelegate?
    
    init?() {
        self.motionManager = CMMotionManager()
        
        guard self.motionManager.isAccelerometerAvailable else { return }

        // Setup Operations Queue for Accelerometer updates
        self.accelerometerUpdatesOperationQueue = OperationQueue()
        self.accelerometerUpdatesOperationQueue.maxConcurrentOperationCount = 1
        self.accelerometerUpdatesOperationQueue.qualityOfService = .background
        
        self.motionManager.accelerometerUpdateInterval = 0.1
        
        self.motionManager.startAccelerometerUpdates(to: self.accelerometerUpdatesOperationQueue) { (accelerometerData, error) in
            
            if let error = error {
                NSLog("Failed to fetch data from accelerometer with an error: \(error)")
                return
            }
            
            guard let accelerometerData = accelerometerData else { return }
            
            DispatchQueue.main.async {
                self.gravityDirection = CGVector(
                    dx: accelerometerData.acceleration.x,
                    dy: accelerometerData.acceleration.y * -1
                )
                
                self.delegate?.acceleratorDataUpdated(gravityDirection: self.gravityDirection)
            }
        }
    }
}


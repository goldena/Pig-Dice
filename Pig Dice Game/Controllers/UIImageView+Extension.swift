//
//  UIImageView+Extension.swift
//  Pig Dice Game
//
//  Created by Denis Goloborodko on 9.03.21.
//

import UIKit

extension UIImageView {

    func rotate(degrees: Double, duration: Double) {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        
        var radians: Double {
            degrees * .pi / 180
        }
        
        rotation.toValue = NSNumber(value: radians)
        rotation.duration = CFTimeInterval(duration)
        
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
}

//
//  UIView+Shake.swift
//  EnergyKeeper
//
//  Created by Juan Carlos Estevez on 5/29/19.
//  Copyright © 2019 Juan Carlos Estevez. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-15.0, 15.0, -13.0, 13.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        DispatchQueue.main.async {
            self.layer.add(animation, forKey: "shake")
        }
    }
    
}

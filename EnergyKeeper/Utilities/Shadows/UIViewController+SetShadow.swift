//
//  UIViewController+SetShadow.swift
//  EnergyKeeper
//
//  Created by Juan Carlos Estevez on 5/14/19.
//  Copyright © 2019 Juan Carlos Estevez. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func setShadow(to view: UIView, _ light: Bool = false, _ viewCornerRadius: CGFloat = 0.0){
        if light{
            view.setShadow(with: shadowColor, opacity: opacity * 0.7, offset: ofset, radius: radius * 0.8, viewCornerRadius: viewCornerRadius)
        }else{
            view.setShadow(with: shadowColor, opacity: opacity, offset: ofset, radius: radius, viewCornerRadius: viewCornerRadius)
        }
        
    }
    
}

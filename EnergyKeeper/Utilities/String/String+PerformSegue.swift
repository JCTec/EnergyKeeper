//
//  String+PerformSegue.swift
//  EnergyKeeper
//
//  Created by Juan Carlos Estevez on 6/4/19.
//  Copyright © 2019 Juan Carlos Estevez. All rights reserved.
//

import Foundation
import UIKit

extension String{
    
    func performSegue(on view: UIViewController){
        if view.canPerformSegue(withIdentifier: self){
            DispatchQueue.main.async {
                view.performSegue(withIdentifier: self, sender: view)
            }
        }
    }
    
}

//
//  Power.swift
//  EnergyKeeper
//
//  Created by Juan Carlos Estevez on 9/26/19.
//  Copyright © 2019 Juan Carlos Estevez. All rights reserved.
//

import Foundation

struct PowerMesure {
    let voltage: Double!
    let current: Double!
    
    func power() -> Double{
        return voltage * current
    }
    
    func getPower() -> String{
        return "\(ceil((voltage * current)*100)/100)"
    }
    
    func getVoltage() -> String{
        return "\(ceil((voltage)*100)/100)"
    }
    
    func getCurrent() -> String{
        return "\(ceil((current)*100)/100)"
    }
}

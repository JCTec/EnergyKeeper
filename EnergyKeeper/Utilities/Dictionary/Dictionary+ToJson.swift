//
//  Dictionary+ToJson.swift
//  EnergyKeeper
//
//  Created by Juan Carlos Estevez on 9/26/19.
//  Copyright © 2019 Juan Carlos Estevez. All rights reserved.
//

import Foundation

extension Dictionary {
    
    func toJSON() -> String!{
        
        var count = 0
        
        var json = "{"
        
        for (key,value) in self {
            
            count += 1
            
            json.append("\"")
            json.append("\(key)")
            json.append("\"")
            json.append(":")
            json.append("\"")
            json.append("\(value)")
            json.append("\"")
            
            if(count != self.count){
                json.append(",")
            }
        }
        
        json.append("}")
        
        
        return json
    }
    
}

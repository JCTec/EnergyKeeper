//
//  String+Trim.swift
//  EnergyKeeper
//
//  Created by Juan Carlos Estevez on 6/11/19.
//  Copyright © 2019 Juan Carlos Estevez. All rights reserved.
//

import Foundation

extension String{
    func trim() -> String{
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

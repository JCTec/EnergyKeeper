//
//  SensorIndividualCollectionViewCell.swift
//  EnergyKeeper
//
//  Created by Juan Carlos Estevez on 9/26/19.
//  Copyright © 2019 Juan Carlos Estevez. All rights reserved.
//

import UIKit

class SensorIndividualCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var potencyLabel: UILabel!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var voltageLabel: UILabel!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    
    static let identifier: String = "sensorIndividual"
    static var nib: UINib! = {
        return "Sensor".loadNib()!
    }()
    
    private let cornerRadiusOfSquares: CGFloat = 7.5
    
    var powerMessure: PowerMesure! {
        didSet{
            voltageLabel.text = powerMessure.getVoltage()
            currentLabel.text = powerMessure.getCurrent()
            potencyLabel.text = powerMessure.getPower()
        }
    }
    
    // MARK: - Set Up
    override func awakeFromNib() {
        mainTitle.textColor = .lightGray
        
        backView.layer.cornerRadius = cornerRadiusOfSquares
        leftView.layer.cornerRadius = cornerRadiusOfSquares
        rightView.layer.cornerRadius = cornerRadiusOfSquares
    }
}

//
//  AlertDisplayer.swift
//  EnergyKeeper
//
//  Created by Juan Carlos Estevez on 9/27/19.
//  Copyright © 2019 Juan Carlos Estevez. All rights reserved.
//

import Foundation
import UIKit
import AlertDisplayer

protocol AlertDisplayerViewControllerDelegate: class {
    func didPressOk()
    func didPressCancel()
}

class AlertDisplayerViewController: UIViewController {
    
    @IBOutlet weak var alertDisplayer: AlertDisplayer!
    
    private var loginSegue: String = "loginSegue"

    var text: String!
    var titleText: String!
    var leftText: String!
    var rightText: String?
    var image: URL?
    
    var negative: Bool = false
    
    weak var delegate: AlertDisplayerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertDisplayer.decorations = EKColors.Blue.flat
        alertDisplayer.textColor = .black
        
        if negative {
            alertDisplayer.configureWith(self, 350, 120, #imageLiteral(resourceName: "exit"))
            
        }else{
            if image == nil{
                alertDisplayer.configureWith(self, 350, 190)
            }else{
                alertDisplayer.configureWith(self, 350, 250, UIImage())
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
}

// MARK: - AlertDisplayerDelegate
extension AlertDisplayerViewController: AlertDisplayerDelegate{
    
    func quantyOfExtraSpaceForImage() -> CGFloat {
        if negative{
            return 80.0
        }else{
            return 100.0
        }
    }
    
    func mainImageHightMultiplier() -> CGFloat {
        if negative{
            return 0.5
        }else{
            return 1.0
        }
    }
    
    func setUpButtons() {
    }
    
    func setFont(to label: UILabel) {
    }
    
    func setBoldFont(to label: UILabel) {
    }
    
    func alertDisplayerDidLoad() {
        //Aditional Setup
        
        alertDisplayer.normalLabel.text = text
        alertDisplayer.boldLabel.text = titleText
        alertDisplayer.boldLabel.numberOfLines = 0
        
        if rightText != nil{
            alertDisplayer.setUpButtons(leftText, rightText)
            alertDisplayer.leftButton.setTitleColor(.black, for: .normal)
            alertDisplayer.rightButton.setTitleColor(.black, for: .normal)
            
        }else{
            alertDisplayer.setUpButtons(leftText)
            alertDisplayer.leftButton.setTitleColor(.black, for: .normal)
            
        }
    }
    
    func didPressOk() {
        print("didPressOkDelegate")
        UserAPI.shared.logOut()
        loginSegue.performSegue(on: self)
    }
    
    func didPressCancel() {
        print("didPressCancelDelegate")
    }
    
    func didSelectMainImage() {
    }
    
    func alertDisplayerWillAppear() {
        if negative {
            alertDisplayer.topConstraint.constant = 15.0
            alertDisplayer.boldLabel.textColor = .red
            alertDisplayer.normalLabel.isHidden = true
            alertDisplayer.mainImage.contentMode = .scaleAspectFit
        }else{
            alertDisplayer.topConstraint.constant = 0.0
            alertDisplayer.boldLabel.textColor = .black
            alertDisplayer.normalLabel.isHidden = false
        }
        
        setShadow(to: alertDisplayer)
        
    }
    
}

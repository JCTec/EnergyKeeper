//
//  LoginControllerViewController.swift
//  EnergyKeeper
//
//  Created by Juan Carlos Estevez on 9/25/19.
//  Copyright © 2019 Juan Carlos Estevez. All rights reserved.
//

import UIKit

class LoginControllerViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var keepLogin: UISwitch!
    @IBOutlet weak var loginButton: UIButton!
    
    private var homeSegue: String = "homeSegue"
    
    // MARK: - Set Up
    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
        // Do any additional setup after loading the view.
    }
    
    private func setUp(){
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        loginButton.layer.cornerRadius = 5.0
        
        setShadow(to: loginButton, true, 5.0)
    }
    
    // MARK: - Private Funcs
    private func email() -> String{
        return emailField.text?.trim() ?? ""
    }
    
    private func password() -> String{
        return passwordField.text?.trim() ?? ""
    }
    
    private func valid() -> Bool {
        
        if email().isEmpty{
            emailField.shake()
            return false
        }
        
        if password().isEmpty{
            passwordField.shake()
            return false
        }
        
        return true
    }
    
    // MARK: - Actions
    @IBAction func didSelectLogin(_ sender: Any) {
        dismissKeyboard()

        if valid(){
            
            let keepLogin: Bool = self.keepLogin.isOn
            
            UserAPI.shared.login(email: email(), password: password(), keepLogin) { (result) in
                
                switch result{
                    case .success(let user):
                        if user.id == nil{
                            self.emailField.shake()
                            self.passwordField.shake()
                        }else{
                            self.homeSegue.performSegue(on: self)
                        }
                    
                    case .failure(_):
                        self.emailField.shake()
                        self.passwordField.shake()
                }
            }
        }
        
    }
    
     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        view.window!.layer.add(transition, forKey: kCATransition)
     }
}

//
//  SessionHandlerViewController.swift
//  EnergyKeeper
//
//  Created by Juan Carlos Estevez on 9/27/19.
//  Copyright © 2019 Juan Carlos Estevez. All rights reserved.
//

import UIKit

class SessionHandlerViewController: UIViewController {
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    private var notLogin: String = "notLogin"
    private var didLogin: String = "didLogin"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loading.isHidden = false
        loading.startAnimating()

        UserAPI.shared.checkSession { (result) in
            
            if result{
                self.didLogin.performSegue(on: self)
            }else{
                self.notLogin.performSegue(on: self)
            }
            
        }
    }
        
    func setUp() {
        loading.isHidden = true
        loading.hidesWhenStopped = true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

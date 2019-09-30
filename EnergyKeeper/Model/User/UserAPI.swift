//
//  UserAPI.swift
//  EnergyKeeper
//
//  Created by Juan Carlos Estevez on 9/26/19.
//  Copyright © 2019 Juan Carlos Estevez. All rights reserved.
//

import Foundation
import UserNotifications
import SwiftKeychainWrapper

class UserAPI {
    
    static let shared = UserAPI()
    
    private init(){
        print("User Interface")
    }
    
    static let emailID: String = "email-UserID"
    
    func email() -> String{
        return UserDefaults.standard.string(forKey: UserAPI.emailID) ?? ""
    }
    
    func save(email: String){
        UserDefaults.standard.set(email, forKey: UserAPI.emailID)
    }
    
    func login(email: String, password: String,_ keep: Bool = true ,completed: @escaping (Result<User, Error>) -> ()){
        
        let urlStr = "\(BaseUrl)/api/login"
        guard let url = URL(string: urlStr) else { return }
        
        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        let parametersData = try? JSONSerialization.data(withJSONObject: parameters)
        
        var urlRequest = URLRequest(url: url, cachePolicy:
            .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30.0)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = parametersData
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("no-cache", forHTTPHeaderField: "Cache-Control")
        
        let request = URLSession.shared.dataTask(with: urlRequest) { (data, urlResponse, error) in
            
            if let err = error {
                completed(.failure(err))
                return
            }
            
            do{
                try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                let login = try JSONDecoder().decode(User.self, from: data!)
                
                if keep && login.id != nil{
                    self.save(email: email)
                    let _ = KeychainWrapper.standard.set(email, forKey: "email-EnergyKeeper")
                    let _ = KeychainWrapper.standard.set(password, forKey: "password-EnergyKeeper")
                }
                
                completed(.success(login))
            }catch let jsonError {
                completed(.failure(jsonError))
            }
            
        }
        
        DispatchQueue.main.async {
            request.resume()
        }
    }
    
    func checkSession(completed: @escaping (_ estatus: Bool)->Void){
        let email = KeychainWrapper.standard.string(forKey: "email-EnergyKeeper") ?? ""
        let password = KeychainWrapper.standard.string(forKey: "password-EnergyKeeper") ?? ""
        
        if email.isEmpty || password.isEmpty{
            completed(false)
        }

        login(email: email, password: password, false) { (result) in
            
            switch result{
                case .success(_):
                    completed(true)
                case .failure(_):
                    completed(false)

            }
            
        }
    }
    
    func logOut(){
        KeychainWrapper.standard.removeObject(forKey: "email-EnergyKeeper")
        KeychainWrapper.standard.removeObject(forKey: "password-EnergyKeeper")

    }
}

//
//  FacebookProvider.swift
//  Bookme5IOS
//
//  Created by Remi Robert on 06/12/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import UIKit
import Alamofire
import FBSDKLoginKit
import FBSDKCoreKit

class FacebookProvider: Provider {
    
    var isValid: Bool {
        return false
    }
    
    let providerType = LoginProviderType.Facebook
    var delegate: LoginProviderDelegate?
    private var parentController: UIViewController!
    private var permissions: [String]!
    
    init(parentController: UIViewController, permissions: [String] = [ "email"]) {
        self.permissions = permissions
        self.parentController = parentController
    }
    
    func login() {
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(permissions: self.permissions, from: self.parentController) { (result:LoginManagerLoginResult?, error:Error?) in
            
            if error != nil || result == nil {
                self.delegate?.loginProvider(loginProvider: self, didError: error as NSError?)
            }
            else {
                if let token = result?.token {
                    let tokenString = token.tokenString
                    self.getFBUserDetails(for: tokenString)
                }
                else {
                    self.delegate?.loginProvider(loginProvider: self, didError: NSError(domain: "Token not found", code: 404, userInfo: nil))
                }
            }
        }
    }
    
    func getFBUserDetails(for token:String) {
        let request =  GraphRequest.init(graphPath: "me", parameters: ["fields":"first_name,last_name,email, picture.type(large), gender"], httpMethod: .get)
        request.start(completionHandler: { (connection, result, error) in
            guard let userInfo = result as? [String: Any] else {
                self.delegate?.loginProvider(loginProvider: self, didError: error as NSError?)
                return
            }
            self.delegate?.loginProvider(loginProvider: self, didSucceed: User.init(with: userInfo, token: token))
            
        })
    }
}

//
//  EmailLoginProvider.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 02/10/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//
import UIKit

class EmailLoginProvider: Provider {
    
    var user: LoginUser
    var providerType: LoginProviderType  =  LoginProviderType.Email
    var delegate: LoginProviderDelegate?
    private var parentController: UIViewController!
    init(parentController: UIViewController, user:LoginUser) {
        self.parentController = parentController
        self.user = user
    }
    
    var isValid: Bool {
        return user.isValid()
    }
    
    func login() {
        if(isValid) {
            self.delegate?.loginProvider(loginProvider: self, didSucceed: user)
        }
    }
}

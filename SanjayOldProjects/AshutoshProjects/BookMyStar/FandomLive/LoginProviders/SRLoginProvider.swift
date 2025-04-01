//
//  LoginProvider.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 02/10/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit
import SVProgressHUD

typealias successCompletionRequestBlock = ((_ user: UserInfoModel) -> Void)
typealias errorCompletionBlock = ((_ error: NSError?) -> Void)

enum LoginProviderType: String {
    case Facebook = "Facebook"
    case Google = "Google"
    case Email = "Email"
    
}

protocol LoginProviderDelegate {
    func loginProvider(loginProvider: Provider, didSucceed user:User)
    func loginProvider(loginProvider: Provider, didSucceed user:LoginUser)
    func loginProvider(loginProvider: Provider, didError error: NSError?)
}

protocol Provider {
    var providerType: LoginProviderType {get }
    var delegate: LoginProviderDelegate? {get set}
    func login()
    var isValid: Bool { get }
}

class SRLoginProvider: LoginProviderDelegate {
    
    private var successRequestBlock: successCompletionRequestBlock?
    private var errorRequestBlock: errorCompletionBlock?
    var currentProvider: Provider!
    
    public func login( provider: Provider, completionRequest: @escaping  successCompletionRequestBlock, completionError: @escaping errorCompletionBlock) {
        self.successRequestBlock = completionRequest
        self.errorRequestBlock = completionError
        self.currentProvider = provider
        self.currentProvider.delegate = self
        provider.login()
    }
    
    internal func loginProvider(loginProvider: Provider, didSucceed user: User) {
        self.performSocialSignInRequest(loginProvider: loginProvider, user: user)
    }
    
    internal func loginProvider(loginProvider: Provider, didError error: NSError?) {
        self.errorRequestBlock?(error)
    }
    internal func loginProvider(loginProvider: Provider, didSucceed user:LoginUser) {
        self.performSignInRequest(user: user)
    }
}

extension SRLoginProvider {
    func performSocialSignInRequest(loginProvider: Provider, user:User) {
        SVProgressHUD.show()
        
        var userInfo:[String:Any] = ["Email": user.email,
                                     "LoginType": user.provideType == "ga" ? "1": "2" ,
                                     "Name": user.fullName,
                                     "MobileNo": "",
                                     "Gender": user.gender,
                                     "Token": user.idToken
        ]
        
        
        userInfo.append(anotherDict: SRUtilities.sharedInstance().extraPostParams())
        SRDataManager.sharedInstance().performNetworkServiceRequest(requestURL: API.socialLoginURL, postData: userInfo) { (result) -> Void in
            switch (result) {
            case .success(let json):
                
                if let result:[String:Any] = json as? Dictionary {
                    self.parseSignInJSON(json: result, user: user)
                } else {
                    self.showAlertWith(title:"", message:AlertMessages.GeneralErrorMsg)
                }
                break
            case .failure(let error):
                self.showAlertWith(title:"", message:error)
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                }
                break;
            }
        }
    }
    
    func performSignInRequest(user:LoginUser) {
        SVProgressHUD.show()
        var userInfo:[String:Any] = ["Email": user.email,
                                     "Password": user.password
        ]
        
        userInfo.append(anotherDict: SRUtilities.sharedInstance().extraPostParams())
        
        SRDataManager.sharedInstance().performNetworkServiceRequest(requestURL: API.loginURL, postData: userInfo) { (result) -> Void in
            switch (result) {
            case .success(let json):
                
                if let result:[String:Any] = json as? Dictionary {
                    self.parseSignInJSON(json: result, user: User.init(with: user.email))
                } else {
                    self.showAlertWith(title:"", message:AlertMessages.GeneralErrorMsg)
                }
                break
            case .failure(let error):
                self.showAlertWith(title:"", message:error)
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                }
                break;
            }
        }
    }
}

extension SRLoginProvider {
    
    func parseSignInJSON(json:[String:Any],  user: User? ) {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
        
        guard let statusCode = json["status"] as? String, statusCode.boolValue == true  else {
            if let messageText = json["message"] as? String {
                self.showAlertWith(title:"", message:messageText)
            } else {
                self.showAlertWith(title:"", message:AlertMessages.GeneralErrorMsg)
            }
            return
        }
        
        if let resultArray = json["result"] as? [Any] {
            self.successRequestBlock?(UserInfoModel.init(with: user, jsonValue: resultArray.first as? [String : Any]))
        }
    }
    
    
    func showAlertWith(title: String?, message: String)  {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        let rootController = UIApplication.shared.keyWindow?.rootViewController
        rootController?.present(alertController, animated: true, completion: nil)
    }
}

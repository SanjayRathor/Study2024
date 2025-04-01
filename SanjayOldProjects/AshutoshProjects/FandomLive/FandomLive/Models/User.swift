//
//  User.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 02/10/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit
import GoogleSignIn
/*
 Normal Signin “”
 Google 1
 Facebook 2
 Insta 3
 Email 4
 Others 5
 
 */

class UserInfoModel:Codable {
    
    public var userId: String = ""
    public var idToken: String = ""
    public var userType: String = ""
    public var name: String = ""
    public var profileImageUrl: URL? = URL.init(string: "") ?? nil
    public var email:String = ""
    public var provideType:String = ""
    init() {
        
    }
    
    // "status":"true","message":"","result":UserId,UserName,UserType
    init(with user: User?, jsonValue:[String:Any]?) {
        
        if let json = jsonValue {
            if let id = json["UserId"] as? String  {
                userId = id
            }
            
            if let userName = json["UserName"] as? String  {
                name = userName
            }
            
            if let type = json["UserType"] as? String  {
                userType = type
            }
        }
        
        if let userData = user {
            self.idToken = userData.idToken
            self.profileImageUrl = userData.profileImageUrl
            self.email = userData.email
            self.provideType = userData.provideType
        }
    }
}


struct User {
    public var userId: String = ""
    public var idToken: String = ""
    public var fullName: String = ""
    public var givenName: String = ""
    public var familyName: String = ""
    public var profileImageUrl: URL? = URL.init(string: "") ?? nil
    public var email:String = ""
    public var provideType:String = ""
    public var gender:String = "3"
    
    internal init(with email:String) {
        self.email = email
        
    }
    
}

extension User {
    
    internal init(with user: GIDGoogleUser) {
        userId = user.userID
        idToken = user.authentication.idToken
        fullName = user.profile.name
        givenName = user.profile.givenName
        familyName = user.profile.familyName
        let emailField = Email(raw: user.profile.email)
        email = emailField?.raw ?? ""
        if (user.profile.hasImage) {
            profileImageUrl = user.profile.imageURL(withDimension: 200)
        }
        provideType = "ga"
    }
    
    internal init(with fbUser:[String:Any]?, token:String) {
        
        if let dict = fbUser {
            if let emailString = dict["email"] as? String {
                email = emailString
            }
            if let genderString = dict["gender"] as? String {
                gender = genderString
            }
            
            if let name = dict["first_name"] as? String, let lastName = dict["last_name"] as? String {
                fullName = name +  " " +  lastName
            }
            
            userId = dict["id"] as! String
            if let imageURL = ((fbUser!["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                print(imageURL)
                profileImageUrl = URL(string: imageURL)
            }
        }        
        idToken = token
        provideType = "fb"
    }
}


struct LoginUser {
    let email: String
    let password: String
    
    func isValid() -> Bool {
        return email != "" && password != ""
    }
    
    func validateFields() ->String? {
        var err:String? = nil
        do {
            _ = try self.email.validatedText(validationType: ValidatorType.email)
            _ = try self.password.validatedText(validationType: ValidatorType.password)
            
        } catch(let error) {
            err = (error as! ValidationError).message
            
        }
        return err
    }
}


struct SignUser {
    
    var name: String = ""
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var gender: String = ""
    var country: String = ""
    var referralReferral: String = ""
    var mobile: String = ""
    var otp: String = ""
    
    func validateFields() ->String? {
        var err:String? = nil
        do {
            _ = try self.name.validatedText(validationType: ValidatorType.username)
            _ = try self.email.validatedText(validationType: ValidatorType.email)
            _ = try self.password.validatedText(validationType: ValidatorType.password)
            _ = try self.gender.validatedText(validationType: ValidatorType.gender)
            _ = try self.country.validatedText(validationType: ValidatorType.country)
            _ = try self.mobile.validatedText(validationType: ValidatorType.mobile)
            //_ = try self.referralReferral.validatedText(validationType: ValidatorType.referral)
            _ = try self.confirmPassword.validatePasswords(password: password, confirmPassword: confirmPassword)
            
        } catch(let error) {
            err = (error as! ValidationError).message
            
        }
        return err
    }
}



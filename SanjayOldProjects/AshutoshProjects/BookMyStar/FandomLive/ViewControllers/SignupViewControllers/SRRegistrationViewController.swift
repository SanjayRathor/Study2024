//
//  SRRegistrationViewController.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 05/10/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit
import SVProgressHUD
import iOSDropDown

class SRRegistrationViewController: UIViewController,KeyboardProtocol {
    // Declare callback function variable
    var clickValue: ((_ value: clickAction)->())?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var containers: [UIView]!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var genderTextField: DropDown!
    @IBOutlet weak var referrelTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var confirmPwdTextField: UITextField!
    @IBOutlet weak var name: UITextField!
    var genderValue = "1"
    var signUpUser:SignUser =  SignUser.init()
    var userProfile:UserInfoModel =  UserInfoModel()
    
    
    @IBOutlet weak var mobileTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerForKeyboardNotification()
        
        genderTextField.optionArray = ["Male", "Female", "Other"]
        genderTextField.optionIds = [1, 2, 3]
        genderTextField.isSearchEnable = false
        //genderTextField.checkMarkEnabled = true
        genderTextField.isEnabled = true
        genderTextField.didSelect{(selectedText , index , id) in
            self.genderValue = ("\(id)")
            
        }
        
        containers.forEach { view in
            view.addShadow(color: UIColor.init(red: 219, green: 219, blue: 219), cornerRadius: 0)
        }
        
        let countryLocale : Locale =  Locale.current
        self.countryTextField.text = countryName(from: countryLocale.regionCode ?? "India");
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "mobileScreenSegue") {
            let viewController = segue.destination as! SROTPViewController
            viewController.signupModel = self.signUpUser
            viewController.userProfile = self.userProfile
        }
    }
    
}

extension SRRegistrationViewController {
    
    func countryName(from countryCode: String) -> String {
        if let name = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: countryCode) {
            return name
        } else {
            return countryCode
        }
    }
    
    @IBAction func continueButtonDidClicked(_ sender: Any) {
        if referrelTextField.text!.isEmpty {
            referrelTextField.text = ""
        }
        
        self.signUpUser = SignUser(name:name.text!, email: emailTextField.text!, password: passwordTextField.text!, confirmPassword: confirmPwdTextField.text!, gender: genderValue, country: countryTextField.text!,  mobile: mobileTextField.text!)
        
        if let errorMessage = signUpUser.validateFields() {
            self.showAlertWith(title: "", message: errorMessage)
        } else {
            self.registerRequestForUser(signupModel: signUpUser)
        }
        
    }
}

extension SRRegistrationViewController {
    
    func registerRequestForUser(signupModel:SignUser) {
        SVProgressHUD.show()
        var userInfo:[String:Any] = [
            "Email": signupModel.email,
            "LoginType": "4",
            "Name": signupModel.name,
            "MobileNo": signupModel.mobile,
            "Gender": signupModel.gender,
            "ReferralCode": signupModel.referralReferral,
            "Password":signupModel.password,
            "Country":signupModel.country,
            "Token": ""
        ]
        
        userInfo.append(anotherDict: SRUtilities.sharedInstance().extraPostParams())
        //let multiformPost:[String:Any] = ["data": userInfo, "ProfilePic": ""]
        
        SRDataManager.sharedInstance().performNetworkServiceRequest(requestURL: API.signUpURL, postData: userInfo ) { (result) -> Void in
            switch (result) {
            case .success(let json):
                
                if let result:[String:Any] = json as? Dictionary {
                    self.parseSignUpJSON(json: result)
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
    
    func parseSignUpJSON(json:[String:Any]) {
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
            self.userProfile = UserInfoModel.init(with: nil, jsonValue: resultArray.first as? [String : Any])
        }
        self.performSegue(withIdentifier: "mobileScreenSegue", sender: self)
    }
}

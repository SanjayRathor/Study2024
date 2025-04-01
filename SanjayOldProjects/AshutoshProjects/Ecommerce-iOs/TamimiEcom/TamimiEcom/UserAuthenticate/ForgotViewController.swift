//
//  ForgotViewController.swift
//  TamimiEcom
//
//  Created by Ansh on 13/09/20.
//  Copyright © 2020  ltd. All rights reserved.
//

import UIKit
import Toast_Swift
import SwiftyJSON
import SVProgressHUD

class ForgotViewController: UIViewController {
    
    @IBOutlet weak var countryFlag: UIImageView!
    var gTextField:UITextField!
    var isValidateCall = false
    var countryCode = "+966"

    @IBOutlet weak var btnValidate: UIButton!
    @IBOutlet weak var passwordtxtField: UITextField!
    @IBOutlet weak var conPasswordtxtField: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtOtp: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setPlacehoder()
        self.passwordtxtField.delegate =  self
        self.conPasswordtxtField.delegate = self
        self.passwordtxtField.returnKeyType = .next
        self.conPasswordtxtField.returnKeyType = .default
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.sideMenuController?.isLeftViewSwipeGestureEnabled = false
        self.sideMenuController?.isLeftViewSwipeGestureDisabled = true
        // self.sideMenuController?.isRightViewSwipeGestureEnabled = false
        //self.sideMenuController?.isRightViewSwipeGestureDisabled = true
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.sideMenuController?.isLeftViewSwipeGestureEnabled = true
        self.sideMenuController?.isLeftViewSwipeGestureDisabled = false
        // self.sideMenuController?.isRightViewSwipeGestureEnabled = true
        // self.sideMenuController?.isRightViewSwipeGestureDisabled = false
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitActioin(_ sender: Any) {
        if gTextField != nil {
        gTextField.resignFirstResponder()
        }
        if !self.isValidPhone(phone: txtMobile.text ?? "") {
            alert(Constants.appName, message: Constants.mobileValidateMasg, view: self)
        }else if !isValidateCall {
            alert(Constants.appName, message: Constants.validateMobMsg, view: self)
        }
        else if txtOtp.text == "" {
            alert(Constants.appName, message: Constants.otpMsg, view: self)
        }
        else if passwordtxtField.text == "" {
            alert(Constants.appName, message: Constants.passwordMsg, view: self)
        }else if conPasswordtxtField.text == "" {
            alert(Constants.appName, message: Constants.passwordMsg, view: self)
        }
        else if passwordtxtField.text != conPasswordtxtField.text {
            alert(Constants.appName, message: Constants.passwordMsgRE, view: self)
        }
        else  {
            self.getFogInformation()
        }
    }
    func getFogInformation() {
        let phoneNo : String = self.txtMobile.text ?? ""
        let password : String = self.passwordtxtField.text ?? ""
        let otp : String = self.txtOtp.text ?? ""
        let params : [String : String] = ["phoneNo":phoneNo ,"password":password,"otp":otp]
        NetworkManager.shared.postJSONResponse(path: Constants.resetPasswordByPhoneNo, parameters: params) { (value, status) in
            switch status {
            case .success:
                if let valueData  = value as? NSDictionary {
                    if let code = valueData["code"] as? Int {
                        if code == 201 {
                            print(valueData)
                            self.txtMobile.text = ""
                            self.txtOtp.text = ""
                            self.passwordtxtField.text = ""
                            self.conPasswordtxtField.text = ""

                            if let message = valueData["message"] as? String {
                                alert(Constants.appName, message: message, view: self)
                            }
                        }
                        else {
                            if let message = valueData["message"] as? String {
                                alert(Constants.appName, message: message, view: self)
                            }
                        }
                    }else {
                        if let message = valueData["message"] as? String {
                            alert(Constants.appName, message: message, view: self)
                        }
                    }
                }
            case .error(let error):
                print(error!)
            }
        }
    }
    @IBAction func validateMobile(_ sender: Any) {
        if gTextField != nil{
        gTextField.resignFirstResponder()
        }
        if txtMobile.text == "" {
            alert(Constants.appName, message: Constants.mobileValidateMasg, view: self)
            return
        }
        txtMobile.resignFirstResponder()
        let post:[String:Any] = [
            "phoneNo": txtMobile.text!,"countryCode":"+91"
        ]
        NetworkManager.shared.postJSONResponse(path:Constants.validatefoguserUser, parameters:post) { (value, status) in
            switch status {
            case .success:
                if let valueData  = value as? NSDictionary {
                    if let code = valueData["code"] as? Int {
                        if code == 201 {
                            self.isValidateCall = true
                            self.validateEnable(isEnabled: false)
                        }
                        if let message = valueData["message"] as? String {
                            alert(Constants.appName, message: message, view: self)
                        }
                    }
                }
            case .error(let error):
                print(error!)
            }
        }
    }
    func validateEnable(isEnabled:Bool) {
        self.btnValidate.isEnabled = isEnabled
        self.btnValidate.alpha = 1.0
        if !isEnabled {
            self.btnValidate.alpha = 0.5
            let delayTime = DispatchTime.now() + 30.0
            DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
                self.validateEnable(isEnabled: true)
            })
        }
    }
  
}
extension ForgotViewController:UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        gTextField = textField
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.passwordtxtField {
            self.conPasswordtxtField.becomeFirstResponder()
        }else {
            textField.resignFirstResponder()
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        if newString.length == 1 && newString == " " {
            return false
        }
        return true
    }
}
extension ForgotViewController {
    func setPlacehoder() {
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7),
            NSAttributedString.Key.font : UIFont(name: "SegoeUI-SemiLightItalic", size: 13)! // Note the !
        ]
        txtMobile.attributedPlaceholder = NSAttributedString(string: "012 345 6789", attributes:attributes)

        txtOtp.attributedPlaceholder = NSAttributedString(string: "Enter OTP", attributes:attributes)
        passwordtxtField.attributedPlaceholder = NSAttributedString(string: "password*", attributes:attributes)
        conPasswordtxtField.attributedPlaceholder = NSAttributedString(string: "re-enter password*", attributes:attributes)
    }
}
extension ForgotViewController : CountrySelection {
   
    @IBAction func flagSelection(_ sender: Any) {
        let countryViewController : CountryViewController = CountryViewController(nibName: "CountryViewController", bundle: nil)
        countryViewController.delagate = self
        self.navigationController?.pushViewController(countryViewController, animated: true)
    }
    func selectedCountryInformation(dict: NSDictionary) {
         print(dict)
        if let nameImage = dict.object(forKey: "nameImage") as? String {
            if let image = UIImage(named: nameImage) {
                self.countryFlag.image = image
                self.txtMobile.text = ""
                self.isValidateCall = false
            }
            if let dial_code = dict.object(forKey: "dial_code") as? String {
                self.countryCode = dial_code
            }
        }
       }
    func isValidPhone(phone: String) -> Bool {
           let phoneRegex = "^[0-9]{5,16}$"
           let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
           return phoneTest.evaluate(with: phone)
       }
}

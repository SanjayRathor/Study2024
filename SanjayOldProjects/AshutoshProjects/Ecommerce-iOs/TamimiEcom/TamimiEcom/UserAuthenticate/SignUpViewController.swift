//
//  SignUpViewController.swift
//  TamimiEcom
//
//  Created by Ansh on 04/09/20.
//  Copyright © 2020  All rights reserved.
//

import UIKit
import SwiftyJSON

class SignUpViewController: UIViewController {
    var countryCode = "+966"
    @IBOutlet weak var flagImage: UIImageView!
        var gTextField:UITextField!
    var isValidateCall = false
    @IBOutlet weak var btnValidate: UIButton!
    @IBOutlet weak var saturationTxtField: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtOtp: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var subscribBtn: UIButton!
    @IBOutlet weak var rewardbtn: UIButton!
    @IBOutlet weak var internalView: UIView!
    @IBOutlet weak var stBottom: NSLayoutConstraint!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setPlacehoder()
        txtFirstName.delegate = self;
        txtLastName.delegate = self;
        txtEmail.delegate = self;
        txtMobile.delegate = self;
        txtOtp.delegate = self;
        txtPassword.delegate = self;
        subscribBtn.isSelected = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func rewardmemberAction(_ sender: Any) {
        rewardbtn.isSelected = !rewardbtn.isSelected
        
    }
    @IBAction func subscribeAction(_ sender: Any) {
        subscribBtn.isSelected = !subscribBtn.isSelected
        
    }
    @IBOutlet weak var saturationAction: UIButton!
    
    @IBAction func signupAction(_ sender: Any) {
        if gTextField != nil {
            gTextField.resignFirstResponder()
        }
        if txtFirstName.text == "" {
            alert(Constants.appName, message: Constants.salutationNameMsg, view: self)
        }
        else if txtFirstName.text == "" {
            alert(Constants.appName, message: Constants.firstNameMsg, view: self)
        }else if txtLastName.text == "" {
            alert(Constants.appName, message: Constants.lastNameMsg, view: self)
        }
        else if txtLastName.text == "" {
            alert(Constants.appName, message: Constants.lastNameMsg, view: self)
        }else if txtEmail.text == "" || !validateEmail(txtEmail.text!) {
            alert(Constants.appName, message: Constants.emailMsg, view: self)
        }
        else if !self.isValidPhone(phone: txtMobile.text ?? "") {
            alert(Constants.appName, message: Constants.mobileValidateMasg, view: self)
        }
        else if txtPassword.text == "" {
            alert(Constants.appName, message: Constants.passwordMsg, view: self)
        }
        else if !isValidateCall {
            alert(Constants.appName, message: Constants.validateMobMsg, view: self)
        }
        else if txtOtp.text == "" {
            alert(Constants.appName, message: Constants.otpMsg, view: self)
        }
        else  {
            self.saveSignUpInformation()
        }
    }
    func saveSignUpInformation() {
        let st : String = self.saturationTxtField.text ?? ""
        let firstName : String = self.txtFirstName.text ?? ""
        let lastName : String = self.txtLastName.text ?? ""
        let email : String = self.txtEmail.text ?? ""
        let mob : String = self.txtMobile.text ?? ""
        let otp : String = self.txtOtp.text ?? ""
        var gender = "female"
        if st == "Mr." {
            gender = "male"
        }
        let password : String = self.txtPassword.text ?? ""
        let params : [String : String] = ["salutation":st,"fname":firstName ,"lname":lastName,"email":email,"phoneNo":mob,"aboutMe":"","password":password,"gender":gender,"dob":"01/07/1995","otp":otp]
        
        NetworkManager.shared.postJSONResponse(path: Constants.signup, parameters: params) { (value, status) in
            switch status {
            case .success:
                if let valueData  = value as? NSDictionary {
                    if let success = valueData["success"] as? Int {
                        if success == 1 {
                            self.navigationController?.popViewController(animated: true)
                        }
                        if let msg = valueData["message"] as? String {
                            alert(Constants.appName, message: msg, view: UIApplication.shared.keyWindow?.rootViewController ?? self)
                        }
                    }
                }
            case .error(let error):
                print(error!)
            }
        }
    }
    
    @IBAction func validateAction(_ sender: Any) {
        if gTextField != nil {
        gTextField.resignFirstResponder()
        }
        if txtMobile.text == "" {
            alert(Constants.appName, message: Constants.mobileValidateMasg, view: self)
            return
        }
        txtMobile.resignFirstResponder()
        let post:[String:Any] = [
            "phoneNo": txtMobile.text!,"countryCode":self.countryCode
        ]
        NetworkManager.shared.postJSONResponse(path:Constants.validateUser, parameters:post) { (value, status) in
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
    
    @IBAction func openTamilMember(_ sender: Any) {
        let storyboard = UIStoryboard(name: "UserMoreInfo", bundle: nil)
        let webViewViewController = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        webViewViewController.isTamilMemberPage = true
        self.navigationController?.pushViewController(webViewViewController, animated: true)
    }
}
extension SignUpViewController {
    override func viewWillAppear(_ animated: Bool) {
        self.sideMenuController?.isLeftViewSwipeGestureEnabled = false
        self.sideMenuController?.isLeftViewSwipeGestureDisabled = true
    }
    override func viewDidAppear(_ animated: Bool) {
        self.sideMenuController?.isLeftViewSwipeGestureEnabled = true
        self.sideMenuController?.isLeftViewSwipeGestureDisabled = false
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension SignUpViewController:UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        gTextField = textField
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.txtMobile {
            self.isValidateCall = false;
            self.validateEnable(isEnabled: true)
        }
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        if newString.length == 1 && newString == " " {
            return false
        }
        return true
    }
}
extension SignUpViewController {
    @IBAction func ssaAction(_ sender: Any) {
        let alert = UIAlertController(title: Constants.appName, message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Mrs.", style: .default , handler:{ (UIAlertAction)in
            self.saturationTxtField.text = "Mrs."
        }))
        alert.addAction(UIAlertAction(title: "Mr.", style: .default , handler:{ (UIAlertAction)in
            self.saturationTxtField.text = "Mr."
        }))
        alert.addAction(UIAlertAction(title: "Ms.", style: .default , handler:{ (UIAlertAction)in
            self.saturationTxtField.text = "Ms."
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
        }))
        
        self.present(alert, animated: true, completion: {
        })
    }
    
    func updateOrderIfExist() {
        let orderNumber = ApplicationStates.getOrderNumber()
        if orderNumber == "" {
            PresentingCoordinator.shared().loginSucessAndPageRefersh()
            
        }else {
            let post:[String:Any] = [
                "orderNumber": orderNumber,
                "orderId": ApplicationStates.getOrderId(),
                "customerId": ApplicationStates.getUserID(),
            ]
            
            NetworkManager.shared.postJSONResponse(path:Constants.editOrder, parameters:post) { (value, status) in
                switch status {
                case .success:
                    if let valueData  = value as? NSDictionary {
                        if let success = valueData["success"] as? Int {
                            if success == 1 {
                                PresentingCoordinator.shared().loginSucessAndPageRefersh()
                            }
                        }
                    }
                case .error(let error):
                    print(error!)
                }
            }
        }
    }
}
extension SignUpViewController {
    func setPlacehoder() {
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7),
            NSAttributedString.Key.font : UIFont(name: "SegoeUI-SemiLightItalic", size: 13)! // Note the !
        ]
        saturationTxtField.attributedPlaceholder = NSAttributedString(string: "salutation*", attributes:attributes)
        txtFirstName.attributedPlaceholder = NSAttributedString(string: "first name*", attributes:attributes)
        txtLastName.attributedPlaceholder = NSAttributedString(string: "last name*", attributes:attributes)
        txtEmail.attributedPlaceholder = NSAttributedString(string: "email*", attributes:attributes)
        txtMobile.attributedPlaceholder = NSAttributedString(string: "012 345 6789", attributes:attributes)
        txtOtp.attributedPlaceholder = NSAttributedString(string: "Enter OTP", attributes:attributes)
        txtPassword.attributedPlaceholder = NSAttributedString(string: "password*", attributes:attributes)
        
    }
}
extension SignUpViewController : CountrySelection {
    @IBAction func flagSelection(_ sender: Any) {
        let countryViewController : CountryViewController = CountryViewController(nibName: "CountryViewController", bundle: nil)
        countryViewController.delagate = self
        self.navigationController?.pushViewController(countryViewController, animated: true)
    }
    func selectedCountryInformation(dict: NSDictionary) {
        print(dict)
        if let nameImage = dict.object(forKey: "nameImage") as? String {
            if let image = UIImage(named: nameImage) {
                self.flagImage.image = image
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

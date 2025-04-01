//
//  SignInViewController.swift
//  TamimiEcom
//
//  Created by Ansh on 04/09/20.
//  Copyright © 2020  All rights reserved.
//

import UIKit
import Toast_Swift
import SwiftyJSON
import SVProgressHUD

class SignInViewController: UIViewController {
    
    var countryCode = "+966"
    @IBOutlet weak var btnEye: UIButton!
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var hintLbl: UILabel!
    @IBOutlet weak var lblDonitHaveAccount: UILabel!
    @IBOutlet var mobTxtField: UITextField!
    @IBOutlet weak var passwordtxtField: UITextField!
    @IBOutlet weak var remberBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let st1 = "Don't have an account?"
        let s2 = "Sign Up."
        let s3 =  "\(st1) \(s2)"
        self.btnEye.isSelected =  !self.passwordtxtField.isSecureTextEntry

        
        let attributedString = NSMutableAttributedString(string: s3, attributes: [
            .font: UIFont(name: "SegoeUI", size: 13.0)!,
            .foregroundColor: UIColor(red: 238.0 / 255.0, green: 27.0 / 255.0, blue: 34.0 / 255.0, alpha: 1.0)
        ])
        attributedString.addAttribute(.font, value: UIFont(name: "SegoeUI-Bold", size: 13.0)!, range: NSRange(location: st1.count+1, length: s2.count))
        lblDonitHaveAccount.attributedText = attributedString
        
        self.mobTxtField.delegate = self
        self.passwordtxtField.delegate = self
        
        let mob = ApplicationStates.getRMob()
        let pass = ApplicationStates.getRPassword()
        
        if mob != ""{
            self.mobTxtField.text = mob
            self.remberBtn.isSelected = true
        }
        
        if pass != "" {
            self.passwordtxtField.text = pass
        }
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7),
            NSAttributedString.Key.font : UIFont(name: "SegoeUI-SemiLightItalic", size: 13)! // Note the !
        ]
        
        mobTxtField.attributedPlaceholder = NSAttributedString(string: "012 345 6789", attributes:attributes)
        passwordtxtField.attributedPlaceholder = NSAttributedString(string: "password", attributes:attributes)
        
        
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
    
    @IBAction func remberAction(_ sender: Any) {
        self.remberBtn.isSelected = !self.remberBtn.isSelected
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "UserAuthenticate", bundle: nil)
        let signUpViewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        if let navigation = self.sideMenuController?.children.last as? UINavigationController {
            navigation.pushViewController(signUpViewController, animated: true)
        }else {
            self.navigationController?.pushViewController(signUpViewController, animated: true)
        }
    }
    
    @IBAction func passwordView(_ sender: Any) {
        self.passwordtxtField.isSecureTextEntry = !self.passwordtxtField.isSecureTextEntry
        self.btnEye.isSelected =  !self.passwordtxtField.isSecureTextEntry
    }
    
    @IBAction func submitBtnAction(_ sender: Any) {
         if mobTxtField.text == ""  {
            alert(Constants.appName, message: Constants.mobileValidateMasg, view: self)
        }
        else if !self.isValidPhone(phone: mobTxtField.text ?? "")  {
            alert(Constants.appName, message: Constants.mobileValidateMasg, view: self)
        }
        else if passwordtxtField.text == "" {
            alert(Constants.appName, message: Constants.passwordMsg, view: self)
        }else  {
            self.getLoginInformation()
        }
    }
    func getLoginInformation() {
        let phoneNo : String = self.mobTxtField.text ?? ""
        let password : String = self.passwordtxtField.text ?? ""
        
        
        self.mobTxtField.resignFirstResponder()
        self.passwordtxtField.resignFirstResponder()
        SVProgressHUD.show()
        let params : [String : String] = ["phoneNo":phoneNo ,"password":password,"countryCode":self.countryCode]
        NetworkManager.shared.postJSONResponse(path: Constants.login, parameters: params) { (value, status) in
            print(value)
            switch status {
            case .success:
                if let valueData  = value as? NSDictionary {
                    if let code = valueData["code"] as? Int {
                        if code == 201 {
                            if  self.remberBtn.isSelected {
                                let dict : [String: String] = ["rMob":phoneNo,"rPassword":password]
                                ApplicationStates.setRemberMobAndPassword(info:dict)
                            }else {
                                let dict : [String: String] = ["rMob":"","rPassword":""]
                                ApplicationStates.setRemberMobAndPassword(info:dict)
                            }
                            let response = JSON(value!)
                            let responseData = response["data"].dictionaryValue
                            if let user : [String:Any] = responseData["user"]?.dictionaryObject {
                                print(user)
                                if let data = valueData["data"]  as? NSDictionary {
                                    if let sid = data["sid"] as? String {
                                        ApplicationStates.setUserSid(sid: sid)
                                    }
                                    if let loyaltyUserId = data["userId"] as? String {
                                        ApplicationStates.setLoyaltyUserId(loyaltyUserId: loyaltyUserId)
                                    }
                                }
                                ApplicationStates.setUserData(Info: user)
                                self.updateOrderIfExist()
                            }else if let msg = valueData["message"] as? String {
                                DispatchQueue.main.async {
                                    SVProgressHUD.dismiss()
                                }
                                alert(Constants.appName, message: msg, view: self)
                            }
                            
                            print(ApplicationStates.getUserID())
                        }else {
                            if let msg = valueData["message"] as? String {
                                DispatchQueue.main.async {
                                    SVProgressHUD.dismiss()
                                }
                                alert(Constants.appName, message: msg, view: self)
                            }                        }
                    }
                }
            case .error(let error):
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                }
                print(error!)
            }
        }
    }
    
    @IBAction func fogAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "UserAuthenticate", bundle: nil)
        let forgotViewController = storyboard.instantiateViewController(withIdentifier: "ForgotViewController") as! ForgotViewController
        
        if let navigation = self.sideMenuController?.children.last as? UINavigationController {
            navigation.pushViewController(forgotViewController, animated: true)
        }else {
            self.navigationController?.pushViewController(forgotViewController, animated: true)
        }
    }
    
    
}
extension SignInViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.mobTxtField {
            self.passwordtxtField.becomeFirstResponder()
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
extension SignInViewController {
    func updateOrderIfExist() {
        let orderNumber = ApplicationStates.getOrderNumber()
        if orderNumber == "" {  DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            PresentingCoordinator.shared().loginSucessAndPageRefersh()
            }
        }else {
            SVProgressHUD.show()
            let post:[String:Any] = [
                "logIn":ApplicationStates.isUserLoggedIn(),
                "source":"MOBILE",
                "orderNumber": orderNumber,
                "orderId": ApplicationStates.getOrderId(),
                "customerId": ApplicationStates.getUserID()
            ]
            NetworkManager.shared.postJSONResponse(path: Constants.editOrder ,parameters:post) { (value, status) in
                print(value)
                switch status {
                case .success:
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                    if let valueData  = value as? NSDictionary {
                        if let code = valueData["code"] as? Int {
                            if code == 201 {
                                    PresentingCoordinator.shared().loginSucessAndPageRefersh()
                            }
                        }
                    }
                    }
                case .error(let error):
                    print(error!)
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                    }
                }
            }
        }
    }
}
extension SignInViewController : CountrySelection {
   
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
                self.mobTxtField.text = ""
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

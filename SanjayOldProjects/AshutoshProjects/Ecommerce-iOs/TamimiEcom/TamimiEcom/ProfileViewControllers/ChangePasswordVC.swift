//
//  ChangePasswordVC.swift
//  TamimiEcom
//
//  Created by Ansh on 20/09/20.
//  Copyright © 2020  ltd. All rights reserved.
//

import UIKit

class ChangePasswordVC: UIViewController {

    @IBOutlet weak var txtCurrent: UITextField!
    @IBOutlet weak var txtNewpassword: UITextField!
    @IBOutlet weak var txtRepassword: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        txtCurrent.delegate = self
        txtNewpassword.delegate = self
        txtRepassword.delegate = self
        self.setPlacehoder()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backAcrtion(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func subMitAction(_ sender: Any) {
        if txtCurrent.text == "" {
            alert(Constants.appName, message: "Please enter current password", view: self)
        }else if txtNewpassword.text == "" {
            alert(Constants.appName, message: "Please enter new password", view: self)
        }else if txtRepassword.text == "" {
            alert(Constants.appName, message: "Please enter re-enter password", view: self)
        }else  if txtNewpassword.text != txtRepassword.text {
            alert(Constants.appName, message: "New password and re-enter password does not matched", view: self)
        }else {
            self.serviceCall()
        }
    }
    func serviceCall() {
        self.txtCurrent.resignFirstResponder()
        self.txtNewpassword.resignFirstResponder()
        self.txtRepassword.resignFirstResponder()
        let password : String = self.txtCurrent.text ?? ""
        let newPassword : String = self.txtNewpassword.text ?? ""
        let params : [String : String] = ["password":password ,"newPassword":newPassword,"customerId":ApplicationStates.getUserID()]
        NetworkManager.shared.postJSONResponse(path: Constants.resetPassword, parameters: params) { (value, status) in
            switch status {
            case .success:
               if let valueData  = value as? NSDictionary {
                                 if let message = valueData["message"] as? String {
                                    alert(Constants.appName, message: message, view: self)
                                    if let code = valueData["code"] as? Int {
                                    if code == 201 {
                                        self.txtCurrent.text = ""
                                        self.txtRepassword.text = ""
                                        self.txtNewpassword.text = ""

                                        }
                                    }
                }
                }
            case .error(let error):
                print(error!)
            }
        }
    }
}
extension ChangePasswordVC:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        
        if newString == " " {
            return false
        }
        return true
    }
}
extension ChangePasswordVC {
    func setPlacehoder() {
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.init(red: 106.0/255.0, green: 109.0/255.0, blue: 110.0/255.0, alpha: 1.0),
            NSAttributedString.Key.font : UIFont(name: "SegoeUI-SemiLightItalic", size: 13)! // Note the !
        ]
        txtCurrent.attributedPlaceholder = NSAttributedString(string: "Current Password*", attributes:attributes)
        txtNewpassword.attributedPlaceholder = NSAttributedString(string: "New Password*", attributes:attributes)
        txtRepassword.attributedPlaceholder = NSAttributedString(string: "Re - Enter New Password*", attributes:attributes)

    }
}

//
//  SRForgotViewController.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 05/10/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit
import SVProgressHUD

class SRForgotViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        submitButton.setGradientImage(for: .normal);
        self.hideKeyboardWhenTappedAround()
        containerView.addShadow(color: UIColor.init(red: 219, green: 219, blue: 219), cornerRadius: 0)
    }
    
    @IBAction func submitButtonDidClicked(_ sender: Any) {
        
        do {
            _ = try self.emailTextField.validatedText(validationType: ValidatorType.email)
            
            self.forgotPasswordForUser(email: self.emailTextField.text!)
            
        } catch(let error) {
            self.showAlertWith(title: "", message: (error as! ValidationError).message)
        }
        
    }
    
}
extension SRForgotViewController {
    
    func forgotPasswordForUser(email:String) {
        SVProgressHUD.show()
        var userInfo:[String:Any] = [
            "Email": emailTextField.text!,
        ]
        userInfo.append(anotherDict: SRUtilities.sharedInstance().extraPostParams())
        SRDataManager.sharedInstance().performNetworkServiceRequest(requestURL: API.forgetPasswordURL, postData: userInfo) { (result) -> Void in
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
        
        //self.navigationController?.view.makeToast(AlertMessages.EmailSentMsg)
        self.showToastMessage(AlertMessages.EmailSentMsg)
        self.navigationController?.popViewController(animated: true)
    }
}

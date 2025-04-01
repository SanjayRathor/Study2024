//
//  SROTPViewController.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 08/10/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit
import SVProgressHUD

class SROTPViewController: UIViewController, KeyboardProtocol {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var mobileView: UIView!
    @IBOutlet weak var mobileTextField: UITextField!
    var signupModel:SignUser!
    var userProfile:UserInfoModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.registerForKeyboardNotification()
        mobileView.addShadow(color: UIColor.init(red: 219, green: 219, blue: 219), cornerRadius: 0)
        mobileTextField.text = signupModel.mobile
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.mobileTextField .resignFirstResponder()
    }
    
    
    @IBAction func continueButtonDidClicked(_ sender: Any) {
        do {
            _ = try self.mobileTextField.validatedText(validationType: ValidatorType.mobile)
            self.validateRequestFor(mobileNo: self.mobileTextField.text!)
        } catch(let error) {
            let errorMessage = (error as! ValidationError).message
            self.showAlertWith(title: "", message: errorMessage)
        }
    }
    
    
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "VeryfyOTPScreenSegue") {
           let viewController = segue.destination as! SROTPVarificationViewController
             viewController.signupModel = signupModel
             viewController.userProfile = self.userProfile
        }
    }
}

extension SROTPViewController {
    func validateRequestFor(mobileNo:String?) {
        guard let mobileNumber = mobileNo else {
            return
        }
        
        SVProgressHUD.show()
        self.signupModel.mobile = mobileNumber
        
        let otpURLString = String(format: API.varifyMobileNoURL, mobileNumber, userProfile.userId,"V")
        SRDataManager.sharedInstance().performNetworkGETServiceRequest(requestURL: otpURLString) { (result) -> Void in
            switch (result) {
            case .success(let json):
                
                if let result:[String:Any] = json as? Dictionary {
                    self.parseSignInJSON(json: result)
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
    
    func parseSignInJSON(json:[String:Any]) {
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
        
        if let otpString = json["result"] as? String {
            self.signupModel.otp = otpString;
        }
        //self.navigationController?.view.makeToast("otp has been sent to mobile number")
        self.showToastMessage("otp has been sent to mobile number")
        self.performSegue(withIdentifier: "VeryfyOTPScreenSegue", sender: self)
    }
    
}

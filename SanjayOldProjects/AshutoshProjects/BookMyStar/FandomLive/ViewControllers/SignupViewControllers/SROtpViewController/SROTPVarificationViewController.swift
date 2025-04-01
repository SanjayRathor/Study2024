//
//  SROTPVarificationViewController.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 08/10/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit
import Repeat
import SVProgressHUD

class SROTPVarificationViewController: UIViewController, KeyboardProtocol {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var pinView: SVPinView!
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var resendOTPLabel: UILabel!
    var signupModel:SignUser!
    var userProfile:UserInfoModel!
    //Re-send code in 0:30
    
    var pinCode = ""
    var mobileNumber = ""
    private var timerInstance: Repeater? = nil
    var counter = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.resendButton.isHidden = true
        self.hideKeyboardWhenTappedAround()
        self.registerForKeyboardNotification()
        self.setCountDownTimer()
        self.setPinField()
        
        self.mobileNumber =  self.signupModel.mobile
        let mas = NSMutableAttributedString(string: "")
        mas.append(NSAttributedString(string:"Enter 6 digit number that was sent to \(self.mobileNumber)", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.init(red: 40, green: 33, blue: 105)]))
        mas.append(NSAttributedString(string: ", wrong number ?", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.init(red: 241, green: 93, blue: 27)]))
        messageLabel.attributedText = mas
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.pinView.becomeFirstResponderAtIndex = 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        view.endEditing(true)
        pinView .resignFirstResponder()
        self.timerInstance?.pause()
        self.timerInstance = nil
    }
    @IBAction func popVC(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}

extension SROTPVarificationViewController {
    
    func setPinField () {
        pinView.didFinishCallback = { pin in
            self.continueButton.isEnabled = pin.count == 6 ? true : false
            self.pinCode = String(format: pin)
        }
        
        pinView.didChangeCallback = { pin in
            self.continueButton.isEnabled = pin.count == 6 ? true : false
        }
    }
    
    func setCountDownTimer () {
        self.resendOTPLabel.text = "Re-send code in 0:\(self.counter)"
        self.timerInstance =  Repeater.every(.seconds(1), count: 30) { repeater  in
            DispatchQueue.main.async {
                self.counter = self.counter-1;
                self.resendOTPLabel.text = "Re-send code in 0:\(self.counter)"
                if (repeater.state == .finished) {
                    self.resendButton.isHidden = false
                    self.resendOTPLabel.alpha = 0.0;
                }
            }
        }
    }
    
    @IBAction func resendButtonDidClicked(_ sender: Any) {
        self.validateRequestFor(mobileNo: self.mobileNumber)
    }
    
    @IBAction func continueButtonDidClicked(_ sender: Any) {
        self.validateOTPRequestFor()
    }
}

extension SROTPVarificationViewController {
    func validateOTPRequestFor() {
        SVProgressHUD.show()
        let otpURLString = String(format: API.varifyMobileOTPURL, mobileNumber, self.pinCode)
        SRDataManager.sharedInstance().performNetworkGETServiceRequest(requestURL:otpURLString) { (result) -> Void in
            switch (result) {
            case .success(let json):
                
                if let result:[String:Any] = json as? Dictionary {
                    self.parseOTPJSON(json: result)
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
    
    func parseOTPJSON(json:[String:Any]) {
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
        
        SRApplicationStates.setUserLoggedIn()
        RepositoryManager.shared.saveProfileFor(user: userProfile)
        AppCoordinator.showDashBoardController()
        
    }
    
}

extension SROTPVarificationViewController {
    
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
            //self.navigationController?.view.makeToast("otp has been sent to mobile number")
            self.showToastMessage("otp has been sent to mobile number")
        }
    }
}

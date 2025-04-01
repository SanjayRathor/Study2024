//
//  SRSignTableViewCell.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 06/10/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit

enum clickAction:Int {
    case forgotPasswordAction, loginAction, facebookAction, googleAction, signupAction
}

class SRSignTableViewCell: UITableViewCell {
    
    // Declare callback function variable
    var clickValue: ((_ value: clickAction)->())?
    
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passworView: UIView!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passworLabel: UITextField!
    
    @IBOutlet weak var forgotButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        emailLabel.delegate = self;
        passworLabel.delegate = self;
        
        emailView.addShadow(color: UIColor.init(red: 219, green: 219, blue: 219), cornerRadius: 0)
        passworView.addShadow(color: UIColor.init(red: 219, green: 219, blue: 219), cornerRadius: 0)
        
        forgotButton.addTarget(self, action: #selector(forgotPassowrdDidClicked), for:.touchUpInside)
        loginButton.addTarget(self, action: #selector(loginDidClicked), for: .touchUpInside)
        facebookButton.addTarget(self, action: #selector(facebookDidClicked), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(googleDidClicked), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(signupDidClicked), for: .touchUpInside)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

extension SRSignTableViewCell:UITextFieldDelegate {
    
   @objc func forgotPassowrdDidClicked() {
        clickValue?(.forgotPasswordAction)
    }
    
    @objc func loginDidClicked() {
        clickValue?(.loginAction)
    }
    
    @objc func facebookDidClicked() {
        clickValue?(.facebookAction)
    }
    
   @objc func googleDidClicked() {
        clickValue?(.googleAction)
    }
    
   @objc func signupDidClicked() {
        clickValue?(.signupAction)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true
    }
}

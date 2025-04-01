//
//  CustomAlertView.swift
//  CustomAlertView
//
//  Created by Daniel Luque Quintana on 16/3/17.
//  Copyright © 2017 dluque. All rights reserved.
//

import UIKit
import iOSDropDown;

class CustomAlertView: UIViewController {
    
    @IBOutlet weak var alertHeightConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var secondTextField: DropDown!
    @IBOutlet weak var thirdTextField: DropDown!
    
    public var optionIdsOne : [Int]?
    public var optionIdsTwo : [Int]?
    var noOfOptions:Int = 1
    
    
    var delegate: CustomAlertViewDelegate?
    var selectedOption = "First"
    let alertViewGrayColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (noOfOptions == 1) {
            alertHeightConstraints.constant = 190
            thirdTextField.isHidden = true;
            secondTextField.isHidden = true;
        } else if (noOfOptions == 2) {
            thirdTextField.isHidden = true;
            alertHeightConstraints.constant = 230
        } else if (noOfOptions == 3) {
            alertHeightConstraints.constant = 280
        }
        
        self.view.layoutIfNeeded()
        
    }
    
    func prepareMessage(title:String, message:String) {
        self.titleLabel.text = title;
        self.messageLabel.text = message;
    }
    
    func prepareFirstDropDownWith(optionsArray:[String:Any], ids:[String:Any]) {
        
        secondTextField.optionArray = ["Male", "Female", "Other"]
        secondTextField.optionIds = [1, 2, 3]
        
        secondTextField.isSearchEnable = false
        //genderTextField.checkMarkEnabled = true
        secondTextField.isEnabled = true
        secondTextField.didSelect{(selectedText , index , id) in
            
        }
    }
    
    func prepareSecondDropDownWith(optionsArray:[String:Any], ids:[String:Any]) {
        
        thirdTextField.optionArray = ["Male", "Female", "Other"]
        thirdTextField.optionIds = [1, 2, 3]
        
        thirdTextField.isSearchEnable = false
        //genderTextField.checkMarkEnabled = true
        thirdTextField.isEnabled = true
        thirdTextField.didSelect{(selectedText , index , id) in
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        animateView()
        cancelButton.addBorder(side: .Top, color: alertViewGrayColor, width: 1)
        cancelButton.addBorder(side: .Right, color: alertViewGrayColor, width: 1)
        okButton.addBorder(side: .Top, color: alertViewGrayColor, width: 1)
    }
    
    func setupView() {
        alertView.layer.cornerRadius = 15
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    func animateView() {
        alertView.alpha = 0;
        self.alertView.frame.origin.y = self.alertView.frame.origin.y + 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.alertView.alpha = 1.0;
            self.alertView.frame.origin.y = self.alertView.frame.origin.y - 50
        })
    }
    
    @IBAction func onTapCancelButton(_ sender: Any) {
        topTextField.resignFirstResponder()
        secondTextField.resignFirstResponder()
        thirdTextField.resignFirstResponder()
        
        delegate?.cancelButtonTapped()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapOkButton(_ sender: Any) {
        topTextField.resignFirstResponder()
        secondTextField.resignFirstResponder()
        thirdTextField.resignFirstResponder()
        
        
        // delegate?.okButtonTapped(selectedOption: selectedOption, textFieldValue: alertTextField.text!)
        
        self.dismiss(animated: true, completion: nil)
    }
    
}

//
//  UITextField+Extension.swift
//  ValidatorsMediumPost
//
//  Created by Arlind on 8/5/18.
//  Copyright © 2018 Arlind Aliu. All rights reserved.
//

import UIKit.UITextField

extension UITextField {
    func validatedText(validationType: ValidatorType) throws -> String {
        let validator = VaildatorFactory.validatorFor(type: validationType)
        return try validator.validated(self.text!)
    }
}

extension String {
    func validatedText(validationType: ValidatorType) throws -> String {
        let validator = VaildatorFactory.validatorFor(type: validationType)
        return try validator.validated(self)
    }
    
    func validatePasswords(password:String, confirmPassword:String) throws -> String {
        
        if (confirmPassword.isEmpty || confirmPassword != password) {
            throw ValidationError("Password didn't match" )
        }
        return confirmPassword
    }
    
}

private var __maxLengths = [UITextField: Int]()
extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        let t = textField.text
        textField.text = t?.safelyLimitedTo(length: maxLength)
    }
}

extension String
{
    func safelyLimitedTo(length n: Int)->String {
        if (self.count <= n) {
            return self
        }
        return String( Array(self).prefix(upTo: n) )
    }
}

class UITextFieldPadding : UITextField {
  let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
  override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
}


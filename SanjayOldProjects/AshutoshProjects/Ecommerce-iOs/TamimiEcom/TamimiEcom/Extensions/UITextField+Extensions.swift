//
//  UITextField+Extension.swift
//  TamimiEcom
//
//  Created by Sanjay Singh Rathor on 08/08/20.
//  Copyright © 2020  . All rights reserved.
//

import UIKit.UITextField


extension UITextField {
       @IBInspectable var placeholderColor: UIColor {
           get {
               return attributedPlaceholder?.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor ?? .clear
           }
           set {
               guard let attributedPlaceholder = attributedPlaceholder else { return }
            let attributes: [NSAttributedString.Key: UIColor] = [.foregroundColor: newValue]
               self.attributedPlaceholder = NSAttributedString(string: attributedPlaceholder.string, attributes: attributes)
           }
       }
    
    func updatePlaceHolderColor () {
        if let placeholder = self.placeholder {
            self.attributedPlaceholder = NSAttributedString(string:placeholder,
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        }
    }
   }

extension UITextField {
    func setUnderLine() {
        let border = CALayer()
        let width = CGFloat(0.5)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  UIScreen.main.bounds.size.width-20, height: self.frame.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        self.setNeedsDisplay()
        self.setNeedsLayout()
    }
}

extension UITextField {
    func setGrayBorderColor() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.masksToBounds = true
    }
    
    func setPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

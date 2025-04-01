//
//  DesignableImageView.swift
//  TamimiEcom
//
//  Created by Sanjay Singh Rathor on 08/08/20.
//  Copyright © 2020  . All rights reserved.
//

import UIKit

@IBDesignable class DesignableImageView: UIImageView {
    
}

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get { return layer.borderColor.flatMap { UIColor(cgColor: $0) } }
        set { layer.borderColor = newValue?.cgColor }
    }
}

extension CGRect {
    func shifted(by x: CGFloat) -> CGRect {
        var newRect = self
        newRect.origin.x += x
        return newRect
    }
}

@IBDesignable
class DesignableTextField: UITextField {
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.shifted(by: 16.0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.shifted(by: 16.0)
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.shifted(by: 16.0)
    }
}



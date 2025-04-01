//
//  UIView+Constraints.swift
//  dineout
//
//  Created by Ashish Bhandari - TIL on 25/02/19.
//  Copyright © 2019 TIL. All rights reserved.
//


struct ConstraintTag {
    static let W = "widthIdentifier"
    static let H = "heightIdentifier"
    static let X = "centerXIdentifier"
    static let Y = "centerYIdentifier"
    static let T = "topIdentifier"
    static let L = "leftIdentifier"
    static let R = "rightIdentifier"
    static let B = "bottomIdentifier"
}

extension NSLayoutDimension {
    
    func constraintEqualTo(constant: CGFloat, identifier: String) -> NSLayoutConstraint {
        let constraint = self.constraint(equalToConstant: constant)
        constraint.identifier = identifier
        return constraint
    }
    
    func constraintEqualTo(anchor: NSLayoutDimension, identifier: String) -> NSLayoutConstraint {
        let constraint = self.constraint(equalTo: anchor, multiplier: 1.0)
        constraint.identifier = identifier
        return constraint
    }
}

extension NSLayoutXAxisAnchor {
    
    func constraintEqualTo(anchor: NSLayoutXAxisAnchor, identifier: String, constant: CGFloat) -> NSLayoutConstraint {
        let constraint = self.constraint(equalTo: anchor, constant: constant)
        constraint.identifier = identifier
        return constraint
    }
}

extension NSLayoutYAxisAnchor {
    
    func constraintEqualTo(anchor: NSLayoutYAxisAnchor, identifier: String, constant: CGFloat) -> NSLayoutConstraint {
        let constraint = self.constraint(equalTo: anchor, constant: constant)
        constraint.identifier = identifier
        return constraint
    }
}


extension UIView {
    
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    func addSizeAnchors(onView view: UIView, size: CGSize) {
        guard self.subviews.contains(view) else {
            return
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        var anchors = [NSLayoutConstraint]()
        anchors.append(view.widthAnchor.constraintEqualTo(constant: size.width, identifier: ConstraintTag.W))
        anchors.append(view.heightAnchor.constraintEqualTo( constant: size.height, identifier: ConstraintTag.H))
        NSLayoutConstraint.activate(anchors)
    }
    
    func addEdgeAnchors(onView view: UIView, edgeInsets: UIEdgeInsets = .zero) {
        guard self.subviews.contains(view) else {
            return
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        var anchors = [NSLayoutConstraint]()
        anchors.append(view.topAnchor.constraintEqualTo(anchor: topAnchor, identifier: ConstraintTag.T, constant: edgeInsets.top))
        anchors.append(view.leadingAnchor.constraintEqualTo(anchor: leadingAnchor, identifier: ConstraintTag.L, constant: edgeInsets.left))
        anchors.append(trailingAnchor.constraintEqualTo(anchor: view.trailingAnchor, identifier: ConstraintTag.R, constant: edgeInsets.right))
        anchors.append(bottomAnchor.constraintEqualTo(anchor: view.bottomAnchor, identifier: ConstraintTag.B, constant: edgeInsets.bottom))
        NSLayoutConstraint.activate(anchors)
    }
    
    func constraint(withIdentifier: String) -> NSLayoutConstraint? {
        return self.constraints.filter{ $0.identifier == withIdentifier }.first
    }
}

//
//  Router.swift
//  Study2024
//
//  Created by Sanjay Singh Rathor on 01/10/23.
//

import Foundation
import UIKit

public protocol Router: AnyObject {
    
  func present(_ viewController: UIViewController,
                animated: Bool)
  func present(_ viewController: UIViewController,
               animated: Bool,
             onDismissed: (()->Void)?)
  func dismiss(animated: Bool)
}


extension Router {
    public func present(_ viewController: UIViewController,
                        animated: Bool) {
        present(viewController,
                animated: animated, onDismissed: nil)
    }
}

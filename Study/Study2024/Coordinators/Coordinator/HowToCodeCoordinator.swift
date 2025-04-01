//
//  HowToCodeCoordinator.swift
//  Study2024
//
//  Created by Sanjay Singh Rathor on 01/10/23.
//

import Foundation
public class HowToCodeCoordinator: Coordinator {
   
    // MARK: - Instance Properties
    public var children: [Coordinator] = []
    public let router: Router
    
    // MARK: - Object Lifecycle
    public init(router: Router) {
        self.router = router
    }
    
    // MARK: - Coordinator
    public func present(animated: Bool,
                        onDismissed: (() -> Void)?) {
//      let viewController = stepViewControllers.first!
//      router.present(viewController,
//                     animated: animated,
//                     onDismissed: onDismissed)
    }
    
}

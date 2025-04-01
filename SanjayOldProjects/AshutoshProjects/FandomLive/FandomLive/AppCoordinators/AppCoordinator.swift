//
//  AppCoordinator.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 05/10/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit

class AppCoordinator: NSObject {
    
    func rootViewController() -> UIViewController? {
        if (!SRApplicationStates.isUserOpenedFirstTime() ) {
            let storyboard = UIStoryboard(storyboard: .signup)
            let viewController = storyboard.instantiateViewController(withIdentifier: "SignupNavigationController")
            return viewController
        }
        
        if (SRApplicationStates.isUserLoggedIn() ) {
            let storyboard = UIStoryboard(storyboard: .main)
            let viewController = storyboard.instantiateViewController(withIdentifier: "SRTabBarController")
            return viewController;
        }
        
        let storyboard = UIStoryboard(storyboard: .signup)
        let viewController = storyboard.instantiateViewController(withIdentifier: "KnockKnockViewController")
        let navigationController = UINavigationController.init(rootViewController: viewController)
        navigationController.navigationBar.isHidden = true
        return navigationController;
    }
}

extension AppCoordinator {
   static func getLoginScreenController() -> UIViewController {
    let storyboard = UIStoryboard(storyboard: .signup)
           let viewController = storyboard.instantiateViewController(withIdentifier: "KnockKnockViewController")
           let navigationController = UINavigationController.init(rootViewController: viewController)
           navigationController.navigationBar.isHidden = true
           return navigationController;
    }
    
    static func promptUserForSignIn() {
        let viewController =  AppCoordinator.getLoginScreenController()
        guard let topVC = UIApplication.shared.topMostViewController() else {
            return
            
        }
        topVC.present(viewController, animated: true, completion: nil)
    }
}

extension AppCoordinator {
    static func showDashBoardController() {
        
        let storyboard = UIStoryboard(storyboard: .main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SRTabBarController")
        UIApplication.shared.keyWindow?.rootViewController = viewController
        switchRootViewController(rootViewController: viewController, animated: true) {
        }
    }
    
    static func switchRootViewController(rootViewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        guard let window = UIApplication.shared.keyWindow else { return }
        if animated {
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                let oldState: Bool = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                window.rootViewController = rootViewController
                UIView.setAnimationsEnabled(oldState)
            }, completion: { (finished: Bool) -> () in
                if (completion != nil) {
                    completion!()
                }
            })
        } else {
            window.rootViewController = rootViewController
        }
    }
    
}

extension AppCoordinator {
    
    static func logoutUser() {
        SRApplicationStates.setUserLoggedOut()
        
        let storyboard = UIStoryboard(storyboard: .signup)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SignupNavigationController")
        UIApplication.shared.keyWindow?.rootViewController = viewController
        switchRootViewController(rootViewController: viewController, animated: true) {
        }
    }
}


extension AppCoordinator {
    
    static func showInterestsViewController( navigationController:UINavigationController?) {
        
        let storyboard = UIStoryboard(storyboard: .signup)
        let viewController = storyboard.instantiateViewController(withIdentifier: "FLInterestsViewController") as! FLInterestsViewController
        viewController.hideSkip = false

       // navigationController?.pushViewController(viewController, animated: true)
        
        let navController = UINavigationController.init(rootViewController: viewController)
        UIApplication.shared.keyWindow?.rootViewController = navController
        
        
        viewController.launchDashboardCallback = {
            self.showDashBoardController()
        }
    
    }
}

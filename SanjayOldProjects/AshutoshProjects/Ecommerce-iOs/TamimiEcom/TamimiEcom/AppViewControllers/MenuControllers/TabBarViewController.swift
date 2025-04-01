//
//  TabBarViewController.swift
//  TamimiEcom
//
//  Created by Ansh on 24/08/20.
//  Copyright © 2020  . All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is CartDashBordViewController {
//            if !ApplicationStates.isUserLoggedIn() {
//            let storyboard = UIStoryboard(name: "UserAuthenticate", bundle: nil)
//            let signInViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
//                self.navigationController?.pushViewController(signInViewController, animated: true)
//                return false
//
//                }else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let cartListViewController = storyboard.instantiateViewController(withIdentifier: "CartListViewController") as! CartListViewController
            self.navigationController?.pushViewController(cartListViewController, animated: true)
           return false
          //  }
        }
        else if viewController is ProfileViewController {
            if !ApplicationStates.isUserLoggedIn() {
            let storyboard = UIStoryboard(name: "UserAuthenticate", bundle: nil)
            let signInViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
                self.navigationController?.pushViewController(signInViewController, animated: true)
                return false

                }
        }
        
    return true
    }
}

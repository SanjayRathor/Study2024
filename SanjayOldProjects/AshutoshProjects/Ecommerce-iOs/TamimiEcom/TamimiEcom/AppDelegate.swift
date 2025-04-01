//
//  AppDelegate.swift
//  TamimiEcom
//
//  Created by Sanjay Singh Rathor on 08/08/20.
//  Copyright © 2020  . All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        self.window!.rootViewController = PresentingCoordinator.shared().rootViewController()
        IQKeyboardManager.shared.enable = true
        
        return true
    }
    
}


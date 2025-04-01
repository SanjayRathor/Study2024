//
//  AppDelegate.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 01/10/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKCoreKit
import IQKeyboardManagerSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
       
        _ =  SRNetworkManager.sharedInstance()
        
        IQKeyboardManager.shared.enable = true
        self.window?.rootViewController = AppCoordinator().rootViewController()
         applyAppAppearance()
        // You can skip this line if you have the latest version of the SDK installed
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    /*func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
     let appId: String = "Settings.appId"
     if url.scheme != nil && url.scheme!.hasPrefix("fb\(appId)") && url.host ==  "authorize" {
     return ApplicationDelegate.shared.application(app, open: url, options: options)
     }
     return false
     }*/
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return ApplicationDelegate.shared.application(app, open: url, options: options)
    }
    
    private func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        let googleDidHandle = GIDSignIn.sharedInstance().handle(url as URL,
                                                                sourceApplication: sourceApplication,
                                                                annotation: annotation)
        
        let facebookDidHandle = ApplicationDelegate.shared.application(
            application,
            open: url as URL,
            sourceApplication: sourceApplication,
            annotation: annotation)
        
        return googleDidHandle || facebookDidHandle
    }
    
}


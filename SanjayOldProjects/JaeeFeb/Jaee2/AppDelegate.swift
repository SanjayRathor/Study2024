//
//  AppDelegate.swift
//  Jaee2
//
//  Created by Abdulaziz  Almohsen on 6/25/17.
//  Copyright © 2017 Jaee. All rights reserved.
//

import UIKit
import CoreData
import OneSignal
import Sentry
import Alamofire
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        

      
        guard let gai = GAI.sharedInstance() else {
            assert(false, "Google Analytics not configured correctly")
            return true
        }
        gai.tracker(withTrackingId: "UA-106574096-1")
        // Optional: automatically report uncaught exceptions.
        gai.trackUncaughtExceptions = true
        
        // Optional: set Logger to VERBOSE for debug information.
        // Remove before app release.
        gai.logger.logLevel = .verbose;
        
        
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]

        // Replace 'YOUR_APP_ID' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "acb2e111-088f-4e26-bb21-6b9c45c8711f",
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)

        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;

        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
            let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
            
            let userID = status.subscriptionStatus.userId
            print("userID = \(userID)")
            let pushToken = status.subscriptionStatus.pushToken
            print("pushToken = \(pushToken)")
            
            if pushToken != nil {
                if let playerID = userID {
                    // do something
                    print("playerID = \(playerID)")
                    print(UserDataSingleton.sharedDataContainer.user_id)
                    print("fuck it")
                   
                   
                }
            }
        })
        
//         Sync hashed email if you have a login system or collect it.
//           Will be used to reach the user at the most optimal time of day.
//         OneSignal.syncHashedEmail(userEmail)
        
//
        do {
            Client.shared = try Client(dsn: "https://f9c33111a1884acaa5ce4c58c658b5b4:57ca8f03a7e040a69855ae84c9ce5521@sentry.io/259589")
            try Client.shared?.startCrashHandler()
        } catch let error {
//            print("\(error)")
            // Wrong DSN or KSCrash not installed
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Jaee2")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func sentplayerID (playerID : String , userID : String){
        print("in function")
        
        let param = ["user_id": "\(userID)",
            "player_id":"\(playerID)"
        ]
        let urlStr = "http://jaeeapp.com/api/client/addPlayer"
        let url = URL(string: urlStr)
        let user = "apiuser"
        let password = "ApiAuthPass2017"
        
        var headers: HTTPHeaders = [
            "Authorization": "Basic YXBpdXNlcjpBcGlBdXRoUGFzczIwMTchQCM="
        ]
        
        
        Alamofire.request(url!, method: .post, parameters: param,encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
            print(response)
            if let value: AnyObject = response.result.value as AnyObject? {
                //Handle the results as JSON
                print(value)
                print("hello world")
                
                let usertoken = JSON(value)
            }
        }
    
    }

}


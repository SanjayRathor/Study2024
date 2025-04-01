//
//  PresentingCoordinator.swift
//  TamimiEcom
//
//  Created by Sanjay Singh Rathor on 23/08/20.
//  Copyright © 2020  . All rights reserved.
//

import UIKit
import SVProgressHUD

class PresentingCoordinator: NSObject {
    
    private static let coordinator = PresentingCoordinator()
       public class func shared() -> PresentingCoordinator {
           return coordinator
       }
       private override init () {
           super.init()
       }
    
    func rootViewController () -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: "TabBarViewController")], animated: false)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
        mainViewController!.rootViewController = navigationController
        return mainViewController!
    }
    func loginSucessAndPageRefersh() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: "TabBarViewController")], animated: false)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
        mainViewController!.rootViewController = navigationController
        UIApplication.shared.keyWindow?.rootViewController = mainViewController;
    }
    func logoutSucessAndPageRefersh() {
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
           navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: "TabBarViewController")], animated: false)
           let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
           mainViewController!.rootViewController = navigationController
           UIApplication.shared.keyWindow?.rootViewController = mainViewController;
       }
    func openLoginPage() {
        let storyboard = UIStoryboard(name: "UserAuthenticate", bundle: nil)
        let signInViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        if let ms = UIApplication.shared.keyWindow?.rootViewController as? MainViewController {
            if let navigation = ms.rootViewController as? UINavigationController {
            navigation.pushViewController(signInViewController, animated: true)
                }
        }else {
            UIApplication.shared.keyWindow?.rootViewController?
            .navigationController?.pushViewController(signInViewController, animated: true)
        }
    }
    func openShareDailog(productId:String,type:String) {
        SVProgressHUD.show()
        
        let post:[String:Any] = [
            "id": productId,"type":type
        ]
        NetworkManager.shared.postJSONResponse(path: Constants.shortUrl, parameters:post) { (value, status) in
            switch status {
            case .success:
                print(value)
                if let valueData  = value as? NSDictionary {
                    if let code = valueData["code"] as? Int {
                        if code == 201 {
                            if let data  = valueData["data"] as? NSDictionary {
                        if let shareUrl = data["shortUrl"] as? String {
                            self.openSharePage(share: shareUrl)
                            }else if  let shareUrl = data["longUrl"] as? String {
                                self.openSharePage(share: shareUrl)
                            }
                        }
                        }
                    }
                }
            case .error(let error):
                print(error!)
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                }
            }
        }
    }
    func openSharePage(share:String) {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            let items = [URL(string: share)!] as [Any]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
            UIApplication.shared.keyWindow?.rootViewController?.present(ac, animated: true)
        }
    }
}

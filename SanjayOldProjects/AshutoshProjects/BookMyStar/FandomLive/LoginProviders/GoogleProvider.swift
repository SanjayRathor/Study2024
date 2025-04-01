

import UIKit
import Alamofire
import GoogleSignIn

class GoogleProvider: NSObject, Provider, GIDSignInDelegate, GIDSignInUIDelegate {
   
    var isValid: Bool {
           return false
       }
    
    
    let providerType = LoginProviderType.Google
    var delegate: LoginProviderDelegate?
    var parentController: UIViewController!
    
    @objc(signIn:presentViewController:) func sign(_ signIn: GIDSignIn!,
                                                   present viewController: UIViewController!) {
        self.parentController.present(viewController, animated: true, completion: nil)
    }
    
    @objc(signIn:dismissViewController:) func sign(_ signIn: GIDSignIn!,
                                                   dismiss viewController: UIViewController!) {
        self.parentController.dismiss(animated: true, completion: nil)
    }
    
    @objc private func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: NSError!) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
           if (error == nil) {
                self.delegate?.loginProvider(loginProvider: self, didSucceed: User.init(with: user))
           }
           else {
                self.delegate?.loginProvider(loginProvider: self, didError: error as NSError?)
           }
       }
    
    func login() {
        GIDSignIn.sharedInstance().clientID = SocialSDKKeys.googleClientKey
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().shouldFetchBasicProfile = true
        GIDSignIn.sharedInstance()?.scopes = ["profile","email"]
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    init(parentController: UIViewController) {
        self.parentController = parentController
    }
    
    
   /* init(parentController: UIViewController) {
        self.parentController = parentController
    }
    
   
    
    func login() {
        GIDSignIn.sharedInstance().clientID = SocialSDKKeys.googleClientKey
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().shouldFetchBasicProfile = true
        GIDSignIn.sharedInstance()?.scopes = ["profile","email"]
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            self.delegate?.loginProvider(loginProvider: self, didSucceed: User.init(with: user))
        }
        else {
            self.delegate?.loginProvider(loginProvider: self, didError: error as NSError?)
        }
    }
    
    @objc private func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: NSError!) {
           GIDSignIn.sharedInstance().signIn()
    }
    */

}

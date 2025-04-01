//
//  Utilities.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 01/10/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit
import FCUUID

class SRUtilities: NSObject {
    var deviceAPNSToken:String?
    var sessionToken:String?
    var appUserId:String?
    
    private static let _sharedInstance = SRUtilities()
    public class func sharedInstance() -> SRUtilities {
        return _sharedInstance
    }
    
    private override init () {
        self.sessionToken = ""
        self.deviceAPNSToken = ""
        self.appUserId = ""
    }
    
    func getDeviceApnsToken() ->String {
        return deviceAPNSToken ?? ""
    }
    
    func setDeviceApnsToken(apns:String?) {
        if let apnsToken = apns {
            self.deviceAPNSToken = apnsToken
        }
    }
    
    func setSessionToken(session:String?) {
        if let sessionValue = session {
            self.sessionToken = sessionValue
        }
    }
    func getSessionToken() ->String {
        return sessionToken ?? ""
    }
    
    func setUserId(userId:String?) {
        if let userId = userId {
            self.appUserId = userId
        }
    }
    func getUserId() ->String {
        return appUserId ?? ""
    }
    func deviceUDID() -> String {
        return  FCUUID.uuidForDevice()
    }
    
    func extraPostParams() -> [String:Any] {
        let systemVersion = UIDevice.current.systemVersion
        let postParams:[String : Any] =  [
            //"Appversion": "1",
            "DeviceId": deviceUDID(),
            "DeviceType":"mobile",
            "Os":"IOS",
            "OsVersion":systemVersion
        ]
        return postParams
    }
    
  static func showToastMessage(_ message: String)  {
        if let topViewController = UIApplication.shared.topMostViewController() {
            Loaf(message, state: .custom(.init(backgroundColor: .black, icon: nil, textAlignment: .center, width: .screenPercentage(0.8))), sender:  topViewController).show()
        } else {
            UIApplication.shared.keyWindow?.rootViewController?.view.makeToast(message)
        }
    }

}


struct globalVariables {
    static let rect = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
    static let width  = UIScreen.main.bounds.width
    static let height: CGFloat =  64
}
//   self.navigationController?.view.backgroundColor = navigationColor
//    self.navigationController?.navigationItem.hidesBackButton = true
//    self.navigationItem.hidesBackButton = true
//
//    // Navigation Bar color and shadow
//    self.navigationController?.navigationBar.barTintColor = navigationColor
//    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//    self.navigationController?.navigationBar.shadowImage = UIImage()
//
//    // Title Label
//    self.navigationController?.navigationBar.addSubview(self.titleLabel)
//
//    // Tab Bar
//    self.view.addSubview(self.tabBar)


enum AlertMessages {
    static var Apptitle   = "Your App Title"
    static var Firstname  = "Please Enter Firstname"
    static var SurName    = "Please Enter SurName"
    static var MobileNo   =  "Please Enter MobileNo"
    static var EmailId    =  "Please Enter Valid EmailId"
    static var Password   =  "Please Enter Password"
    static var ConfirmPassword   =  "Please Enter Confirm Password"
    static var Submited    = "Details Submited SuccessFully"
    static var MobileExits   = "Mobile No Already Exits"
    static var ValidMobileNo  =  "Please Enter Valid Mobile No"
    static var ReqPassword  =  "Password Should be minimum 6 character Length"
    static var PassMatch   =  "Password and Confirm Password Should be Same"
    static var GeneralErrorMsg  = "Oops, something went wrong. Please try again later."
    static var EmailSentMsg = "Please check your email to reset your password."
    static var CityMissingMsg = "Please select city."
    static var AmountMissingMsg = "Please enter the amount."
    static var TeamAMissingMsg = "Please choose teamA."
    static var TeamBMissingMsg = "Please choose teamB."
    static var MainArtistMissingMsg = "Please choose main artist."
    static var EmptyErrorMsg  = "No Data Found"
    static var NetworkErrorMsg  = "Please check your network settings."
    
    
    
}

extension DispatchQueue {
    // This method will dispatch the `block` to self.
    // If `self` is the main queue, and current thread is main thread, the block
    // will be invoked immediately instead of being dispatched.
    func safeAsync(_ block: @escaping ()->()) {
        if self === DispatchQueue.main && Thread.isMainThread {
            block()
        } else {
            async { block() }
        }
    }
}



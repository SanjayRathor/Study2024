//
//  ApplicationStates.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 01/10/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit

private enum UserDefaultKeys:String {
    case isOpenedFirestTime
    case isUserLoggedIn
    case userLoggedInId
    case userMobileNumber
}

class SRApplicationStates: NSObject {
    static func isUserOpenedFirstTime() -> Bool {
        return UserDefaults.standard.bool(forKey: UserDefaultKeys.isOpenedFirestTime.rawValue)
    }
    static func setUserOpenedFirstTime() -> Void {
        return UserDefaults.standard.set(true, forKey:UserDefaultKeys.isOpenedFirestTime.rawValue)
    }
    
    static func isUserLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: UserDefaultKeys.isUserLoggedIn.rawValue)
    }
    
    static func setUserLoggedIn() -> Void {
        return UserDefaults.standard.set(true, forKey:UserDefaultKeys.isUserLoggedIn.rawValue)
    }
    static func setUserLoggedOut() -> Void {
        return UserDefaults.standard.set(false, forKey:UserDefaultKeys.isUserLoggedIn.rawValue)
    }
    
}

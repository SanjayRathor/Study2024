//
//  ServiceConstants.swift
//  TamimiEcom
//
//  Created by Sanjay Singh Rathor on 08/08/20.
//  Copyright © 2020  . All rights reserved.
//

import Foundation
import UIKit

enum SocialSDKKeys {
    static let googleClientKey = "612462430100-cck0ijdbhp3aonst2pndu4f6v90li2kp.apps.googleusercontent.com"
}

//var kGradintStartColor =  UIColor.hexColorStr("#E3197E", alpha: 1)
//var kGradintEndColor =  UIColor.hexColorStr("#46286E", alpha: 1)
//   
enum NetworkEnvironment {
    case qa
    case production
    case staging
}

let environment:NetworkEnvironment = .staging

var environmentBaseURL : String {
    switch environment {
    case .production: return "https://api.fandomlive.fourbrick.in/"
    case .qa: return "https://api.fandomlive.fourbrick.in/"
    case .staging: return "https://api.fandomlive.fourbrick.in/"
    }
}

struct API {
    private init() {
    }
    
    static var baseURL: String {
        return "https://api.fandomlive.fourbrick.in"
    }
    
    //Post Api
    static var loginURL: String {
        return environmentBaseURL+"Login"
    }
    
}

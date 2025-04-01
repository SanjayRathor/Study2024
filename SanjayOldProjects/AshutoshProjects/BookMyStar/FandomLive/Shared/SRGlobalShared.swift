//
//  GlobalShared.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 01/10/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit

enum SocialSDKKeys {
    static let googleClientKey = "693419841405-0rgbo7u6imukfh4815adna1e7nl0d9ql.apps.googleusercontent.com"
}

struct Defaults {
    static let Latitude: Double = 51.400592
    static let Longitude: Double = 4.760970
}

enum NetworkEnvironment {
    case qa
    case production
    case staging
}

let environment:NetworkEnvironment = .staging

var environmentBaseURL : String {
    switch environment {
    case .production: return "https://api.bookmystar.club/"
    case .qa: return "https://api.bookmystar.club/"
    case .staging: return "https://api.bookmystar.club/"
    }
}

struct API {
    private init() {
    }
    
    static var baseURL: String {
        return "https://api.bookmystar.club"
    }
    
   //Post Api
     static var loginURL: String {
         return environmentBaseURL+"Login"
     }
     static var socialLoginURL: String {
         return environmentBaseURL+"SocialMediaLogin"
     }
     
     static var signUpURL: String {
         return environmentBaseURL+"signupIos"
     }
     
     static var updatePasswordURL: String {
         return environmentBaseURL+"UpdatePassword"
     }
     
     static var forgetPasswordURL: String {
         return environmentBaseURL+"ForgetPassword"
     }
     
     static var likeCampaignURL: String {
            return environmentBaseURL+"likeCampaign"
     }
     static var voteCampaignURL: String {
         return environmentBaseURL+"VoteCampaign"
     }
     
     static var getInterestURL: String {
         return environmentBaseURL+"getInterest"
     }
     
     static var submitInterestURL: String {
         return environmentBaseURL+"submituserInterest"
     }
     static var getforumThreardURL: String {
         return environmentBaseURL+"getforumThreard"
     }
     
     static var getThreardCommentsURL: String {
            return environmentBaseURL+"getthreardComments"
        }
     
     static var getThreardRepliesURL: String {
            return environmentBaseURL+"getthreardReplies"
        }
     
     //get api
     static var getUserURL: String {
         return environmentBaseURL+"getUser"
     }
     
     static var updateUserURL: String {
         return environmentBaseURL+"UpdateUser"
     }
     static var varifyMobileNoURL: String {
         return environmentBaseURL+"VarifyMobileNo?MobileNo=%@&UserId=%@&Key=%@"
     }
     
     static var varifyMobileOTPURL: String {
         return environmentBaseURL+"VarifyMobileOTP?MobileNo=%@&OTP=%@"
     }
     
     //Dashboard Apis
     static var getCampaignURL: String {
            return environmentBaseURL+"dashboardCampaign?UserId=%@"
        }
     
     static var getmyCampaignURL: String {
         return environmentBaseURL+"getmyCampaign?UserId=%@"
     }
     static var getmyFavoritesURL: String {
         return environmentBaseURL+"getfavouriteCampaign?UserId=%@"
     }
     
    static var getCampaignInfoURL: String {
         return environmentBaseURL+"GetCampaignInfo?CampaignId=%@&UserId=%@"
     }
     
     static var getSearchURL: String {
            return environmentBaseURL+"dashboardSearch?inputText=%@"
        }
     
    
}

//UserId


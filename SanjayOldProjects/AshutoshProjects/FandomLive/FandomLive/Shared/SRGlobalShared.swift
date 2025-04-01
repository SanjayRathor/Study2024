//
//  GlobalShared.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 01/10/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit

enum SocialSDKKeys {
    static let googleClientKey = "612462430100-cck0ijdbhp3aonst2pndu4f6v90li2kp.apps.googleusercontent.com"
}


var kGradintStartColor =  UIColor.hexColorStr("#E3197E", alpha: 1)
var kGradintEndColor =  UIColor.hexColorStr("#46286E", alpha: 1)
   

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
    static var likeRewardCampaignURL: String {
        return environmentBaseURL+"likeRewardCampaign"
    }
    static var likeSecurityCampaignURL: String {
        return environmentBaseURL+"likeSecurityCampaign"
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
    
    static var getCommentsLikeURL: String {
        return environmentBaseURL+"threadcommentLike"
    }
    
    
    
    static var getRewardPackageURL: String {
        return environmentBaseURL+"getRewardPackage"
    }
    
    static var getSecurityUpdateMasterURL: String {
        return environmentBaseURL+"getSecurityUpdateMaster"
    }
    
    static var getMediaLinkURL: String {
        return environmentBaseURL+"getMediaLink"
    }
    
    
    static var getSocialMediaImageURL: String {
        return environmentBaseURL+"getSocialMediaImage"
    }
    static var getOrganizerLegalInfoURL: String {
        return environmentBaseURL+"organizerLegalInfo"
    }
    
    static var getSecurityDocumentMasterURL: String {
        return environmentBaseURL+"getSecurityDocumentMaster"
    }
    
    static var getVotingStatisticsURL: String {
        return environmentBaseURL+"votingStatistics"
    }
    
    static var getRewardStatisticsURL: String {
        return environmentBaseURL+"rewardStatistics"
    }
    
    
    //MARK: - Get APIS
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
    
    //Campaign Tabs
    static var getVotingCampaignListURL: String {
        return environmentBaseURL+"getVotingCampaignList?UserId=%@"
    }
    
    static var getRewardCampaignList: String {
        return environmentBaseURL+"getRewardCampaignList?UserId=%@"
    }
    
    static var getRewardCampaignInfo: String {
        return environmentBaseURL+"GetRewardCampaignInfo?CampaignId=%@&UserId=%@"
    }
    
    static var getSecurityCampaignURL: String {
        return environmentBaseURL+"userSecurityCampaignList?UserId=%@"
    }
    static var getSecurityCampaignInfoURL: String {
        return environmentBaseURL+"GetSecurityCampaignInfo?CampaignId=%@&UserId=%@"
    }
    
    static var getMakeSecurityCampaignURL: String {
        return environmentBaseURL+"makeSecurityCampaign"
    }
    
    static var getThreardRepliesURL: String {
        return environmentBaseURL+"getthreardReplies"
    }
    static var postthreadCommentsURL: String {
        return environmentBaseURL+"postthreadComments"
    }
    
    static var threadcommentReplyURL: String {
        return environmentBaseURL+"threadcommentReply"
    }
    
}

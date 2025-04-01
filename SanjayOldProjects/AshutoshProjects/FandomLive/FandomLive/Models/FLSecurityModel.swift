//
//  FLSecurityModel.swift
//  FandomLive
//

import Foundation

// MARK: - FLSecurityModel
@objcMembers class FLSecurityModel: NSObject, Codable {
       let message: String
       let result: [SecurityModel]
       let status: String

       init(message: String, result: [SecurityModel], status: String) {
           self.message = message
           self.result = result
           self.status = status
       }
}

// MARK: - Result
@objcMembers class SecurityModel: NSObject, Codable {
    let securitycampaign: [Securitycampaign]

    init(securitycampaign: [Securitycampaign]) {
        self.securitycampaign = securitycampaign
    }
    
    
}

// MARK: - Securitycampaign
@objcMembers class Securitycampaign: NSObject, Codable {
    let campDescription, campName, campaignType, campaignTypeName: String
    let endDate: String
    let eventID: Int
    let eventName: String
    let minimumInvestment: Int
    let socialLink, startDate: String
    let status: Int
    let countryCurrency, countryFlag: String
    let engage: Int
    let fundGoal, funded: String
    let id: Int
    let image: String
    let isInterest: String
    var isMakedone, islike, pointMade: Int
    let shareURL: String
    let totalFandomLiver: Int

    enum CodingKeys: String, CodingKey {
        case campDescription = "CampDescription"
        case campName = "CampName"
        case campaignType = "CampaignType"
        case campaignTypeName = "CampaignTypeName"
        case endDate = "EndDate"
        case eventID = "EventId"
        case eventName = "EventName"
        case minimumInvestment = "MinimumInvestment"
        case socialLink = "SocialLink"
        case startDate = "StartDate"
        case status = "Status"
        case countryCurrency, countryFlag, engage, fundGoal, funded, id, image, isInterest, isMakedone, islike, pointMade
        case shareURL = "shareUrl"
        case totalFandomLiver
    }

    init(campDescription: String, campName: String, campaignType: String, campaignTypeName: String, endDate: String, eventID: Int, eventName: String, minimumInvestment: Int, socialLink: String, startDate: String, status: Int, countryCurrency: String, countryFlag: String, engage: Int, fundGoal: String, funded: String, id: Int, image: String, isInterest: String, isMakedone: Int, islike: Int, pointMade: Int, shareURL: String, totalFandomLiver: Int) {
        self.campDescription = campDescription
        self.campName = campName
        self.campaignType = campaignType
        self.campaignTypeName = campaignTypeName
        self.endDate = endDate
        self.eventID = eventID
        self.eventName = eventName
        self.minimumInvestment = minimumInvestment
        self.socialLink = socialLink
        self.startDate = startDate
        self.status = status
        self.countryCurrency = countryCurrency
        self.countryFlag = countryFlag
        self.engage = engage
        self.fundGoal = fundGoal
        self.funded = funded
        self.id = id
        self.image = image
        self.isInterest = isInterest
        self.isMakedone = isMakedone
        self.islike = islike
        self.pointMade = pointMade
        self.shareURL = shareURL
        self.totalFandomLiver = totalFandomLiver
    }
}


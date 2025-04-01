//
//  FLRewardModel.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 07/12/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import Foundation

@objcMembers class FLRewardModel: NSObject, Codable {
    let message: String
    let result: [Rewards]
    let status: String

    init(message: String, result: [Rewards], status: String) {
        self.message = message
        self.result = result
        self.status = status
    }
}

// MARK: - Result
@objcMembers class Rewards: NSObject, Codable {
    let rewardcampaign: [Rewardscampaign]?

    init(rewardcampaign: [Rewardscampaign]) {
        self.rewardcampaign = rewardcampaign
    }
}

// MARK: - Rewardcampaign
@objcMembers class Rewardscampaign: NSObject, Codable {
    let endDate, eventName: String
    let id: Int
    let startDate, rewardcampaignDescription: String
    let eventType: Int
    let fandomPoints, fundGoal, funded: String
    let image: String
    var isInterest, isMakedone, islike: Int
    let name: String
    let pointMade: Int
    let shareURL: String
    let status, totalFandomLiver, totalFandomLivers: Int

    enum CodingKeys: String, CodingKey {
        case endDate = "EndDate"
        case eventName = "EventName"
        case id = "Id"
        case startDate = "StartDate"
        case rewardcampaignDescription = "description"
        case eventType, fandomPoints, fundGoal, funded, image, isInterest, isMakedone, islike, name, pointMade
        case shareURL = "shareUrl"
        case status, totalFandomLiver, totalFandomLivers
    }

    init(endDate: String, eventName: String, id: Int, startDate: String, rewardcampaignDescription: String, eventType: Int, fandomPoints: String, fundGoal: String, funded: String, image: String, isInterest: Int, isMakedone: Int, islike: Int, name: String, pointMade: Int, shareURL: String, status: Int, totalFandomLiver: Int, totalFandomLivers: Int) {
        self.endDate = endDate
        self.eventName = eventName
        self.id = id
        self.startDate = startDate
        self.rewardcampaignDescription = rewardcampaignDescription
        self.eventType = eventType
        self.fandomPoints = fandomPoints
        self.fundGoal = fundGoal
        self.funded = funded
        self.image = image
        self.isInterest = isInterest
        self.isMakedone = isMakedone
        self.islike = islike
        self.name = name
        self.pointMade = pointMade
        self.shareURL = shareURL
        self.status = status
        self.totalFandomLiver = totalFandomLiver
        self.totalFandomLivers = totalFandomLivers
    }
}

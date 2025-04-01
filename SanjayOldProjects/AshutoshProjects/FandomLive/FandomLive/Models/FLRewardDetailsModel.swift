//
//  FLRewardDetailsModel.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 12/12/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import Foundation

// MARK: - FLRewardDetailsModel
@objcMembers class FLRewardDetailsModel: NSObject, Codable {
    let message: String
    let result: RewardDetails
    let status: String

    init(message: String, result: RewardDetails, status: String) {
        self.message = message
        self.result = result
        self.status = status
    }
}

// MARK: - Result
@objcMembers class RewardDetails: NSObject, Codable {
    let id: Int
    let category: String
    let categoryID: Int
    let desc, endDate, fandomPoints, fundGoal: String
    let funded: String
    let image: String
    var isMakeDone, islike: Int
    let name: String
    let shareURL: String
    let startDate: String
    let totalFandomLivers, totalPointsMade: Int

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case category
        case categoryID = "categoryId"
        case desc, endDate, fandomPoints, fundGoal, funded, image, isMakeDone, islike, name
        case shareURL = "shareUrl"
        case startDate, totalFandomLivers, totalPointsMade
    }

    init(id: Int, category: String, categoryID: Int, desc: String, endDate: String, fandomPoints: String, fundGoal: String, funded: String, image: String, isMakeDone: Int, islike: Int, name: String, shareURL: String, startDate: String, totalFandomLivers: Int, totalPointsMade: Int) {
        self.id = id
        self.category = category
        self.categoryID = categoryID
        self.desc = desc
        self.endDate = endDate
        self.fandomPoints = fandomPoints
        self.fundGoal = fundGoal
        self.funded = funded
        self.image = image
        self.isMakeDone = isMakeDone
        self.islike = islike
        self.name = name
        self.shareURL = shareURL
        self.startDate = startDate
        self.totalFandomLivers = totalFandomLivers
        self.totalPointsMade = totalPointsMade
    }
}

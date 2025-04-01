//
//  FLPackagesModel.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 13/12/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import Foundation

// MARK: - FLPackagesModel
@objcMembers class FLPackagesModel: NSObject, Codable {
    let message: String
    let result: [Packages]
    let status: String

    init(message: String, result: [Packages], status: String) {
        self.message = message
        self.result = result
        self.status = status
    }
}

// MARK: - Result
@objcMembers class Packages: NSObject, Codable {
    
    let amount, campaignID: Int
    let dateCreate, resultDescription: String
    let rewardPoint: Int
    let userCreate: String
    var isSlected: Int?  =  0
    
    enum CodingKeys: String, CodingKey {
        case amount = "Amount"
        case campaignID = "CampaignId"
        case dateCreate = "DateCreate"
        case resultDescription = "Description"
        case rewardPoint = "RewardPoint"
        case userCreate = "UserCreate"
        case isSlected = "isSlected"
    }

    init(amount: Int, campaignID: Int, dateCreate: String,
         resultDescription: String, rewardPoint: Int, userCreate: String, isSlected:Int?) {
        self.amount = amount
        self.campaignID = campaignID
        self.dateCreate = dateCreate
        self.resultDescription = resultDescription
        self.rewardPoint = rewardPoint
        self.userCreate = userCreate
        self.isSlected = isSlected
    }
    
}


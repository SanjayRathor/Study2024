//
//  FLSecurityDeatlsModel.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 05/01/20.
//  Copyright © 2020 Sanjay Singh Rathor. All rights reserved.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let fLSecurityDeatlsModel = try? newJSONDecoder().decode(FLSecurityDeatlsModel.self, from: jsonData)

import Foundation

// MARK: - FLSecurityDeatlsModel
@objcMembers class FLSecurityDeatailsModel: NSObject, Codable {
    let message: String
    let result: DetailsModel
    let status: String

    init(message: String, result: DetailsModel, status: String) {
        self.message = message
        self.result = result
        self.status = status
    }
}

// MARK: - Result
@objcMembers class DetailsModel: NSObject, Codable {
    let category: String
    let categoryID: Int
    let countryCurrency: String
    let countryFlag: String
    let desc, endDate: String
    let fandomPoints: Int
    let fundGoal, funded: String
    let id: Int
    let image: String
    var isMakeDone, islike, minInvest: Int
    let name, organizerName: String
    let shareURL: String
    let socialLink, startDate: String
    let topicID, totalFandomLivers, totalPointsMade: Int

    enum CodingKeys: String, CodingKey {
        case category
        case categoryID = "categoryId"
        case countryCurrency, countryFlag, desc, endDate, fandomPoints, fundGoal, funded, id, image, isMakeDone, islike, minInvest, name, organizerName
        case shareURL = "shareUrl"
        case socialLink, startDate
        case topicID = "topicId"
        case totalFandomLivers, totalPointsMade
    }

    init(category: String, categoryID: Int, countryCurrency: String, countryFlag: String, desc: String, endDate: String, fandomPoints: Int, fundGoal: String, funded: String, id: Int, image: String, isMakeDone: Int, islike: Int, minInvest: Int, name: String, organizerName: String, shareURL: String, socialLink: String, startDate: String, topicID: Int, totalFandomLivers: Int, totalPointsMade: Int) {
        self.category = category
        self.categoryID = categoryID
        self.countryCurrency = countryCurrency
        self.countryFlag = countryFlag
        self.desc = desc
        self.endDate = endDate
        self.fandomPoints = fandomPoints
        self.fundGoal = fundGoal
        self.funded = funded
        self.id = id
        self.image = image
        self.isMakeDone = isMakeDone
        self.islike = islike
        self.minInvest = minInvest
        self.name = name
        self.organizerName = organizerName
        self.shareURL = shareURL
        self.socialLink = socialLink
        self.startDate = startDate
        self.topicID = topicID
        self.totalFandomLivers = totalFandomLivers
        self.totalPointsMade = totalPointsMade
    }
}


import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let fLMyFavoritesModel = try? newJSONDecoder().decode(FLMyFavoritesModel.self, from: jsonData)

import Foundation

// MARK: - FLMyFavoritesModel
@objcMembers class FLMyFavoritesModel: NSObject, Codable {
    let message: String
    let result: [Favorites]
    let status: String

    init(message: String, result: [Favorites], status: String) {
        self.message = message
        self.result = result
        self.status = status
    }
}

// MARK: - Result
@objcMembers class Favorites: NSObject, Codable {
    let voting: [Voting]?
    let reward: [Reward]?

    init(voting: [Voting]?, reward: [Reward]?) {
        self.voting = voting
        self.reward = reward
    }
}

// MARK: - Reward
@objcMembers class Reward: NSObject, Codable {
    let endDate, eventName: String
    let id: Int
    let startDate, rewardDescription: String
    let eventType: Int
    let fandomPoints, fundGoal, funded: String
    let image: String
    let isInterest, isMakedone, islike: Int
    let name: String
    let pointMade: Int
    let shareURL: String
    let status, totalFandomLiver, totalFandomLivers: Int

    enum CodingKeys: String, CodingKey {
        case endDate = "EndDate"
        case eventName = "EventName"
        case id = "Id"
        case startDate = "StartDate"
        case rewardDescription = "description"
        case eventType, fandomPoints, fundGoal, funded, image, isInterest, isMakedone, islike, name, pointMade
        case shareURL = "shareUrl"
        case status, totalFandomLiver, totalFandomLivers
    }

    init(endDate: String, eventName: String, id: Int, startDate: String, rewardDescription: String, eventType: Int, fandomPoints: String, fundGoal: String, funded: String, image: String, isInterest: Int, isMakedone: Int, islike: Int, name: String, pointMade: Int, shareURL: String, status: Int, totalFandomLiver: Int, totalFandomLivers: Int) {
        self.endDate = endDate
        self.eventName = eventName
        self.id = id
        self.startDate = startDate
        self.rewardDescription = rewardDescription
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

// MARK: - Voting
@objcMembers class Voting: NSObject, Codable {
    let campDescription: String
    let campID: Int
    let campImage: String
    let campName: String
    let campType: Int
    let campTypeName, endDate: String
    let eventID: Int
    let eventName: String
    let featuredCamp: Int
    let startDate: String
    let status, engage: Int
    let fandomPoint: String
    var islike, pointMade: Int
    let shareURL: String

    enum CodingKeys: String, CodingKey {
        case campDescription = "CampDescription"
        case campID = "CampId"
        case campImage = "CampImage"
        case campName = "CampName"
        case campType = "CampType"
        case campTypeName = "CampTypeName"
        case endDate = "EndDate"
        case eventID = "EventId"
        case eventName = "EventName"
        case featuredCamp = "FeaturedCamp"
        case startDate = "StartDate"
        case status = "Status"
        case engage, fandomPoint, islike, pointMade
        case shareURL = "shareUrl"
    }

    init(campDescription: String, campID: Int, campImage: String, campName: String, campType: Int, campTypeName: String, endDate: String, eventID: Int, eventName: String, featuredCamp: Int, startDate: String, status: Int, engage: Int, fandomPoint: String, islike: Int, pointMade: Int, shareURL: String) {
        self.campDescription = campDescription
        self.campID = campID
        self.campImage = campImage
        self.campName = campName
        self.campType = campType
        self.campTypeName = campTypeName
        self.endDate = endDate
        self.eventID = eventID
        self.eventName = eventName
        self.featuredCamp = featuredCamp
        self.startDate = startDate
        self.status = status
        self.engage = engage
        self.fandomPoint = fandomPoint
        self.islike = islike
        self.pointMade = pointMade
        self.shareURL = shareURL
    }
}




//@objcMembers class FLMyFavoritesModel: NSObject, Codable {
//    let message: String
//    let result: [Favorites]
//    let status: String
//
//    init(message: String, result: [Favorites], status: String) {
//        self.message = message
//        self.result = result
//        self.status = status
//    }
//}
//
//// MARK: - Result
//@objcMembers class Favorites: NSObject, Codable {
//    let voting: [Voting]?
//    let reward: String?
//
//    init(voting: [Voting]?, reward: String?) {
//        self.voting = voting
//        self.reward = reward
//    }
//}
//
//// MARK: - Voting
//@objcMembers class Voting: NSObject, Codable {
//
//    let campDescription: String
//    let campID: Int
//    let campImage: String
//    let campName: String
//    let campType: Int
//    let campTypeName, endDate: String
//    let eventID: Int
//    let eventName: String
//    let featuredCamp: Int
//    let startDate: String
//    let status, engage: Int
//    let fandomPoint: String
//    var islike, pointMade: Int
//    let shareURL: String
//
//    enum CodingKeys: String, CodingKey {
//        case campDescription = "CampDescription"
//        case campID = "CampId"
//        case campImage = "CampImage"
//        case campName = "CampName"
//        case campType = "CampType"
//        case campTypeName = "CampTypeName"
//        case endDate = "EndDate"
//        case eventID = "EventId"
//        case eventName = "EventName"
//        case featuredCamp = "FeaturedCamp"
//        case startDate = "StartDate"
//        case status = "Status"
//        case engage, fandomPoint, islike, pointMade
//        case shareURL = "shareUrl"
//    }
//
//    init(campDescription: String, campID: Int, campImage: String, campName: String, campType: Int, campTypeName: String, endDate: String, eventID: Int, eventName: String, featuredCamp: Int, startDate: String, status: Int, engage: Int, fandomPoint: String, islike: Int, pointMade: Int, shareURL: String) {
//        self.campDescription = campDescription
//        self.campID = campID
//        self.campImage = campImage
//        self.campName = campName
//        self.campType = campType
//        self.campTypeName = campTypeName
//        self.endDate = endDate
//        self.eventID = eventID
//        self.eventName = eventName
//        self.featuredCamp = featuredCamp
//        self.startDate = startDate
//        self.status = status
//        self.engage = engage
//        self.fandomPoint = fandomPoint
//        self.islike = islike
//        self.pointMade = pointMade
//        self.shareURL = shareURL
//    }
//}
//




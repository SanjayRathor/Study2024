
import Foundation

// MARK: - FLMyFavoritesModel

  class FLMyFavoritesModel: NSObject, Codable {
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

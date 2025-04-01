//
//  FLMyVotingModel.swift
//  FandomLive
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let fLMyVotingModel = try? newJSONDecoder().decode(FLMyVotingModel.self, from: jsonData)

import Foundation

// MARK: - FLMyVotingModel
@objcMembers class FLMyVotingModel: NSObject, Codable {
    let message: String
    let result: [Items]
    let status: String

    init(message: String, result: [Items], status: String) {
        self.message = message
        self.result = result
        self.status = status
    }
}

// MARK: - Result
@objcMembers class Items: NSObject, Codable {
    let campDescription: String
    let campImage: String
    let campName: String
    let campType: Int
    let campTypeName: String
    let campaignID, cityID, countryID: Int
    let endDate: String
    let eventID: Int
    let eventName, fandomPoint: String
    let firstTeam, followedArtist, howMuchCanPay, mainArtist: Int
    let secondTeam: Int
    let startDate: String
    let stateID, status, engage: Int
    let resultFandomPoint: String
    var islike, pointMade: Int
    let shareURL: String

    enum CodingKeys: String, CodingKey {
        case campDescription = "CampDescription"
        case campImage = "CampImage"
        case campName = "CampName"
        case campType = "CampType"
        case campTypeName = "CampTypeName"
        case campaignID = "CampaignId"
        case cityID = "CityId"
        case countryID = "CountryId"
        case endDate = "EndDate"
        case eventID = "EventId"
        case eventName = "EventName"
        case fandomPoint = "FandomPoint"
        case firstTeam = "FirstTeam"
        case followedArtist = "FollowedArtist"
        case howMuchCanPay = "HowMuchCanPay"
        case mainArtist = "MainArtist"
        case secondTeam = "SecondTeam"
        case startDate = "StartDate"
        case stateID = "StateId"
        case status = "Status"
        case engage
        case resultFandomPoint = "fandomPoint"
        case islike, pointMade
        case shareURL = "shareUrl"
    }

    init(campDescription: String, campImage: String, campName: String, campType: Int, campTypeName: String, campaignID: Int, cityID: Int, countryID: Int, endDate: String, eventID: Int, eventName: String, fandomPoint: String, firstTeam: Int, followedArtist: Int, howMuchCanPay: Int, mainArtist: Int, secondTeam: Int, startDate: String, stateID: Int, status: Int, engage: Int, resultFandomPoint: String, islike: Int, pointMade: Int, shareURL: String) {
        self.campDescription = campDescription
        self.campImage = campImage
        self.campName = campName
        self.campType = campType
        self.campTypeName = campTypeName
        self.campaignID = campaignID
        self.cityID = cityID
        self.countryID = countryID
        self.endDate = endDate
        self.eventID = eventID
        self.eventName = eventName
        self.fandomPoint = fandomPoint
        self.firstTeam = firstTeam
        self.followedArtist = followedArtist
        self.howMuchCanPay = howMuchCanPay
        self.mainArtist = mainArtist
        self.secondTeam = secondTeam
        self.startDate = startDate
        self.stateID = stateID
        self.status = status
        self.engage = engage
        self.resultFandomPoint = resultFandomPoint
        self.islike = islike
        self.pointMade = pointMade
        self.shareURL = shareURL
    }
}

//
//  FLCampaignModels.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 24/10/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let fLCampaignInfo = try? newJSONDecoder().decode(FLCampaignInfo.self, from: jsonData)

import Foundation

// MARK: - FLCampaignInfo
@objcMembers class FLCampaignInfo: NSObject, Codable {
    let message: String
    let result: Result
    let status: String
    
    init(message: String, result: Result, status: String) {
        self.message = message
        self.result = result
        self.status = status
    }
}

// MARK: - Result
@objcMembers class Result: NSObject, Codable {
    let id: Int
    let banner: String
    let category: String
    let categoryID: Int
    let concert: Concert
    let desc, endDate: String
    var fandomPoints, isMakeDone, islike: Int
    let location: [Location]
    let name, startDate: String
    let teams: Teams
    let totalFandomLivers, totalPointsMade, typeID: Int
    let typeName: String
    let shareURL: String
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case banner, category
        case categoryID = "categoryId"
        case concert, desc, endDate, fandomPoints, isMakeDone, islike, location, name, startDate, teams, totalFandomLivers, totalPointsMade
        case typeID = "typeId"
        case typeName
        case shareURL = "shareUrl"
    }
    
    init(id: Int, banner: String, category: String, categoryID: Int, concert: Concert, desc: String, endDate: String, fandomPoints: Int, isMakeDone: Int, islike: Int, location: [Location], name: String, startDate: String, teams: Teams, totalFandomLivers: Int, totalPointsMade: Int, typeID: Int, typeName: String,shareURL: String) {
        self.id = id
        self.banner = banner
        self.category = category
        self.categoryID = categoryID
        self.concert = concert
        self.desc = desc
        self.endDate = endDate
        self.fandomPoints = fandomPoints
        self.isMakeDone = isMakeDone
        self.islike = islike
        self.location = location
        self.name = name
        self.startDate = startDate
        self.teams = teams
        self.totalFandomLivers = totalFandomLivers
        self.totalPointsMade = totalPointsMade
        self.typeID = typeID
        self.typeName = typeName
        self.shareURL = shareURL
    }
}

// MARK: - Concert
@objcMembers class Concert: NSObject, Codable {
    let followed, main: [Followed]
    
    init(followed: [Followed], main: [Followed]) {
        self.followed = followed
        self.main = main
    }
}

// MARK: - Followed
@objcMembers class Followed: NSObject, Codable {
    let id: Int
    let imagePath: String?
    let name: String

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case imagePath = "ImagePath"
        case name = "Name"
    }

    init(id: Int, imagePath: String, name: String) {
        self.id = id
        self.imagePath = imagePath
        self.name = name
    }
}

// MARK: - Location
@objcMembers class Location: NSObject, Codable {
    let city, country, state: [Followed]
    
    init(city: [Followed], country: [Followed], state: [Followed]) {
        self.city = city
        self.country = country
        self.state = state
    }
}

// MARK: - Teams
@objcMembers class Teams: NSObject, Codable {
    let teamA, teamB: [Team]
    
    init(teamA: [Team], teamB: [Team]) {
        self.teamA = teamA
        self.teamB = teamB
    }
}

// MARK: - Team
@objcMembers class Team: NSObject, Codable {
    let id: Int
    let name: String
    let teamLogo: String
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case teamLogo = "TeamLogo"
    }
    
    init(id: Int, name: String, teamLogo: String) {
        self.id = id
        self.name = name
        self.teamLogo = teamLogo
    }
}

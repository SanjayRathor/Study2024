// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let fLSearchResults = try? newJSONDecoder().decode(FLSearchResults.self, from: jsonData)

import Foundation

// MARK: - FLSearchResults
@objcMembers class FLSearchResults: NSObject, Codable {
    
    let message: String
    let result: SearchResult
    let status: String

    init(message: String, result: SearchResult, status: String) {
        self.message = message
        self.result = result
        self.status = status
    }
}

// MARK: - Team
@objcMembers class TeamModel: NSObject, Codable {
    let id: Int
    let image: String
    let name, type: String
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case image, name, type
    }
    
    init(id: Int, image: String, name: String, type: String) {
        self.id = id
        self.image = image
        self.name = name
        self.type = type
    }
}

// MARK: - Result
@objcMembers class SearchResult: NSObject, Codable {
    let artist: [ArtistModel]
    let campaign: [CampaignModel]
    let team: [TeamModel]
    
    init(artist: [ArtistModel], campaign: [CampaignModel], team: [TeamModel]) {
        self.artist = artist
        self.campaign = campaign
        self.team = team
    }
}

// MARK: - Artist
@objcMembers class ArtistModel: NSObject, Codable {
    let artistID: Int?
    let image: String
    let name, type: String
    let id: Int?
    
    enum CodingKeys: String, CodingKey {
        case artistID = "id"
        case image, name, type
        case id = "Id"
    }
    
    init(artistID: Int?, image: String, name: String, type: String, id: Int?) {
        self.artistID = artistID
        self.image = image
        self.name = name
        self.type = type
        self.id = id
    }
}

// MARK: - Campaign
// MARK: - Campaign
@objcMembers class CampaignModel: NSObject, Codable {
    let campaignDescription, endDate: String
    let engage, id: Int
    let image: String
    let name: String
    let pointGenerated: Int
    let startDate, type: String

    enum CodingKeys: String, CodingKey {
        case campaignDescription = "description"
        case endDate, engage, id, image, name, pointGenerated, startDate, type
    }

    init(campaignDescription: String, endDate: String, engage: Int, id: Int, image: String, name: String, pointGenerated: Int, startDate: String, type: String) {
        self.campaignDescription = campaignDescription
        self.endDate = endDate
        self.engage = engage
        self.id = id
        self.image = image
        self.name = name
        self.pointGenerated = pointGenerated
        self.startDate = startDate
        self.type = type
    }
}

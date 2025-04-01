//
//  FLDashBoardModelNew.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 07/12/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//


import Foundation

// MARK: - FLDashBoard
@objcMembers class FLDashBoard: NSObject, Codable {
    let message: String
    let results: Results
    let status: String

    init(message: String, results: Results, status: String) {
        self.message = message
        self.results = results
        self.status = status
    }
}

// MARK: - Results
@objcMembers class Results: NSObject, Codable {
    let banner: [Banner]
    let news: [News]
    let rewardcampaign: [Rewardcampaign]
    let securitycampaign, socialcampaign: [JSONAny]
    let votingcampaign: [Votingcampaign]

    init(banner: [Banner], news: [News], rewardcampaign: [Rewardcampaign], securitycampaign: [JSONAny], socialcampaign: [JSONAny], votingcampaign: [Votingcampaign]) {
        self.banner = banner
        self.news = news
        self.rewardcampaign = rewardcampaign
        self.securitycampaign = securitycampaign
        self.socialcampaign = socialcampaign
        self.votingcampaign = votingcampaign
    }
}

// MARK: - Banner
@objcMembers class Banner: NSObject, Codable {
    let id: Int
    let date, desc: String
    let image: String
    let title: String

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case date, desc, image, title
    }

    init(id: Int, date: String, desc: String, image: String, title: String) {
        self.id = id
        self.date = date
        self.desc = desc
        self.image = image
        self.title = title
    }
}

// MARK: - News
@objcMembers class News: NSObject, Codable {
    let dateCreate: String
    let id: Int
    let imagePath: String
    let newsDesc, newsType, summary, title: String

    enum CodingKeys: String, CodingKey {
        case dateCreate = "DateCreate"
        case id, imagePath, newsDesc, newsType, summary, title
    }

    init(dateCreate: String, id: Int, imagePath: String, newsDesc: String, newsType: String, summary: String, title: String) {
        self.dateCreate = dateCreate
        self.id = id
        self.imagePath = imagePath
        self.newsDesc = newsDesc
        self.newsType = newsType
        self.summary = summary
        self.title = title
    }
}

// MARK: - Rewardcampaign
@objcMembers class Rewardcampaign: NSObject, Codable {
    let endDate, eventName: String
    let fandomPoint, id: Int
    let startDate, rewardcampaignDescription: String
    let eventType: Int
    let isInterest: String
    let isMakedone, islike: Int
    let name: String
    let pointMade: Int
    let shareURL: String
    let totalFandomLiver: Int

    enum CodingKeys: String, CodingKey {
        case endDate = "EndDate"
        case eventName = "EventName"
        case fandomPoint = "FandomPoint"
        case id = "Id"
        case startDate = "StartDate"
        case rewardcampaignDescription = "description"
        case eventType, isInterest, isMakedone, islike, name, pointMade
        case shareURL = "shareUrl"
        case totalFandomLiver
    }

    init(endDate: String, eventName: String, fandomPoint: Int, id: Int, startDate: String, rewardcampaignDescription: String, eventType: Int, isInterest: String, isMakedone: Int, islike: Int, name: String, pointMade: Int, shareURL: String, totalFandomLiver: Int) {
        self.endDate = endDate
        self.eventName = eventName
        self.fandomPoint = fandomPoint
        self.id = id
        self.startDate = startDate
        self.rewardcampaignDescription = rewardcampaignDescription
        self.eventType = eventType
        self.isInterest = isInterest
        self.isMakedone = isMakedone
        self.islike = islike
        self.name = name
        self.pointMade = pointMade
        self.shareURL = shareURL
        self.totalFandomLiver = totalFandomLiver
    }
}

// MARK: - Votingcampaign
@objcMembers class Votingcampaign: NSObject, Codable {
    let artistID, campDescription: String
    let campImage: String
    let campName: String
    let campType: Int
    let campTypeName, cityID, countryID, endDate: String
    let eventID: Int
    let eventName, fandomPoint, firstTeam: String
    let followedArtist: String?
    let id: Int
    let secondTeam, startDate, stateID: String
    let status, engage: Int
    let isInterest: String
    var isMakedone, islike, pointMade: Int
    let shareURL: String
    let totalFandomLiver: Int

    enum CodingKeys: String, CodingKey {
        case artistID = "ArtistId"
        case campDescription = "CampDescription"
        case campImage = "CampImage"
        case campName = "CampName"
        case campType = "CampType"
        case campTypeName = "CampTypeName"
        case cityID = "CityId"
        case countryID = "CountryId"
        case endDate = "EndDate"
        case eventID = "EventId"
        case eventName = "EventName"
        case fandomPoint = "FandomPoint"
        case firstTeam = "FirstTeam"
        case followedArtist = "FollowedArtist"
        case id = "Id"
        case secondTeam = "SecondTeam"
        case startDate = "StartDate"
        case stateID = "StateId"
        case status = "Status"
        case engage, isInterest, isMakedone, islike, pointMade
        case shareURL = "shareUrl"
        case totalFandomLiver
    }

    init(artistID: String, campDescription: String, campImage: String, campName: String, campType: Int, campTypeName: String, cityID: String, countryID: String, endDate: String, eventID: Int, eventName: String, fandomPoint: String, firstTeam: String, followedArtist: String?, id: Int, secondTeam: String, startDate: String, stateID: String, status: Int, engage: Int, isInterest: String, isMakedone: Int, islike: Int, pointMade: Int, shareURL: String, totalFandomLiver: Int) {
        self.artistID = artistID
        self.campDescription = campDescription
        self.campImage = campImage
        self.campName = campName
        self.campType = campType
        self.campTypeName = campTypeName
        self.cityID = cityID
        self.countryID = countryID
        self.endDate = endDate
        self.eventID = eventID
        self.eventName = eventName
        self.fandomPoint = fandomPoint
        self.firstTeam = firstTeam
        self.followedArtist = followedArtist
        self.id = id
        self.secondTeam = secondTeam
        self.startDate = startDate
        self.stateID = stateID
        self.status = status
        self.engage = engage
        self.isInterest = isInterest
        self.isMakedone = isMakedone
        self.islike = islike
        self.pointMade = pointMade
        self.shareURL = shareURL
        self.totalFandomLiver = totalFandomLiver
    }
}

// MARK: - Encode/decode helpers

@objcMembers class JSONNull: NSObject, Codable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    override public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

@objcMembers class JSONAny: NSObject, Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}

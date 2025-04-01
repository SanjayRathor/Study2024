//
//  SLLegalInfo.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 14/01/20.
//  Copyright © 2020 Sanjay Singh Rathor. All rights reserved.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let sLLegalInfo = try? newJSONDecoder().decode(SLLegalInfo.self, from: jsonData)

import Foundation

// MARK: - SLLegalInfo
@objcMembers class SLLegalInfo: NSObject, Codable {
    let message: String
    let result: [SLegalModel]
    let status: String

    init(message: String, result: [SLegalModel], status: String) {
        self.message = message
        self.result = result
        self.status = status
    }
}

// MARK: - Result
@objcMembers class SLegalModel: NSObject, Codable {
      let dateCreate, dateUpdate: String
      let status: Int
      let userCreate: String
      let userUpdate: String?
      let campaignID, existingShares, founders, id: Int
      let incorporatedDate, lastFundingRound, legalCompanyName, legalForm: String
      let organizerID, registrationNo, teamSize, videoID: String
      let youtubeLink: String

    
    enum CodingKeys: String, CodingKey {
        case dateCreate = "DateCreate"
        case dateUpdate = "DateUpdate"
        case status = "Status"
        case userCreate = "UserCreate"
        case userUpdate = "UserUpdate"
        case campaignID = "campaignId"
        case existingShares, founders, id, incorporatedDate, lastFundingRound, legalCompanyName, legalForm
        case organizerID = "organizerId"
        case registrationNo, teamSize
        case videoID = "videoId"
        case youtubeLink
    }
    

    init(dateCreate: String, dateUpdate: String, status: Int, userCreate: String, userUpdate: String?, campaignID: Int, existingShares: Int, founders: Int, id: Int, incorporatedDate: String, lastFundingRound: String, legalCompanyName: String, legalForm: String, organizerID: String, registrationNo: String, teamSize: String, videoID: String, youtubeLink: String) {
        self.dateCreate = dateCreate
        self.dateUpdate = dateUpdate
        self.status = status
        self.userCreate = userCreate
        self.userUpdate = userUpdate
        self.campaignID = campaignID
        self.existingShares = existingShares
        self.founders = founders
        self.id = id
        self.incorporatedDate = incorporatedDate
        self.lastFundingRound = lastFundingRound
        self.legalCompanyName = legalCompanyName
        self.legalForm = legalForm
        self.organizerID = organizerID
        self.registrationNo = registrationNo
        self.teamSize = teamSize
        self.videoID = videoID
        self.youtubeLink = youtubeLink
    }
}

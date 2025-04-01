//
//  SLDocumentInfo.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 16/01/20.
//  Copyright © 2020 Sanjay Singh Rathor. All rights reserved.
//

import Foundation

// MARK: - SLDocumentInfo
@objcMembers class SLDocumentInfo: NSObject, Codable {
    let message: String
    let result: [DocumentInfo]
    let status: String

    init(message: String, result: [DocumentInfo], status: String) {
        self.message = message
        self.result = result
        self.status = status
    }
}

// MARK: - Result
@objcMembers class DocumentInfo: NSObject, Codable {
    let campType, campaignID: Int
    let dateCreate, documentName: String
    let documentPath: String
    let userCreate: String

    enum CodingKeys: String, CodingKey {
        case campType = "CampType"
        case campaignID = "CampaignId"
        case dateCreate = "DateCreate"
        case documentName = "DocumentName"
        case documentPath = "DocumentPath"
        case userCreate = "UserCreate"
    }

    init(campType: Int, campaignID: Int, dateCreate: String, documentName: String, documentPath: String, userCreate: String) {
        self.campType = campType
        self.campaignID = campaignID
        self.dateCreate = dateCreate
        self.documentName = documentName
        self.documentPath = documentPath
        self.userCreate = userCreate
    }
}


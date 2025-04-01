//
//  FLForumListModel.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 19/11/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//
import Foundation

// MARK: - FLForumList
@objcMembers class FLForumList: NSObject, Codable {
    let message: String
    let result: [ForumItem]
    let status: String

    init(message: String, result: [ForumItem], status: String) {
        self.message = message
        self.result = result
        self.status = status
    }
}

// MARK: - Result
@objcMembers class ForumItem: NSObject, Codable {
    let banner: String
    let date, resultDescription: String
    let shareURL: String
    let topicID: Int
    let topicName: String
    var totalLike, totalcomments: Int

    enum CodingKeys: String, CodingKey {
        case banner, date
        case resultDescription = "description"
        case shareURL = "shareUrl"
        case topicID = "topicId"
        case topicName, totalLike, totalcomments
    }

    init(banner: String, date: String, resultDescription: String, shareURL: String, topicID: Int, topicName: String, totalLike: Int, totalcomments: Int) {
        self.banner = banner
        self.date = date
        self.resultDescription = resultDescription
        self.shareURL = shareURL
        self.topicID = topicID
        self.topicName = topicName
        self.totalLike = totalLike
        self.totalcomments = totalcomments
    }
}

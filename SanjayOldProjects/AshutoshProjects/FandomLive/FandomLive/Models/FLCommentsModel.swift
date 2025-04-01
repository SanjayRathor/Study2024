//
//  FLCommentsModel.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 21/11/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import Foundation

// MARK: - FLCommentsModel
@objcMembers class FLCommentsModel: NSObject, Codable {
    let message: String
    let result: [Comments]
    let status: String

    init(message: String, result: [Comments], status: String) {
        self.message = message
        self.result = result
        self.status = status
    }
}

// MARK: - Result
@objcMembers class Comments: NSObject, Codable {
    let comment: String
    let commentID: Int
    let dateTime, image: String
    var isLike, topicID, totalLike, totalReply: Int
    let userID, userName: String
    let commentImage:String?

    enum CodingKeys: String, CodingKey {
        case comment
        case commentID = "commentId"
        case dateTime, image, isLike
        case topicID = "topicId"
        case totalLike, totalReply
        case userID = "userId"
        case userName
        case commentImage
    }

    init(comment: String, commentID: Int, dateTime: String, image: String, isLike: Int, topicID: Int, totalLike: Int, totalReply: Int, userID: String, userName: String, commentImage:String?) {
        self.comment = comment
        self.commentID = commentID
        self.dateTime = dateTime
        self.image = image
        self.isLike = isLike
        self.topicID = topicID
        self.totalLike = totalLike
        self.totalReply = totalReply
        self.userID = userID
        self.userName = userName
        self.commentImage = commentImage
    }
}

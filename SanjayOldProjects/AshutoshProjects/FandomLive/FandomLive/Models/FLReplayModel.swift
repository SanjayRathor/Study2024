//
//  FLReplayModel.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 24/11/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//
import Foundation

// MARK: - FLReplayModel
@objcMembers class FLReplayModel: NSObject, Codable {
    let message: String
    let result: [Replies]
    let status: String

    init(message: String, result: [Replies], status: String) {
        self.message = message
        self.result = result
        self.status = status
    }
}

// MARK: - Result
@objcMembers class Replies: NSObject, Codable {
    let comment: String
    let commentID: Int
    let dateTime, image: String
    var isLike, replyID, totalLike: Int
    let userID, userName: String
    let replyImage: String?

    enum CodingKeys: String, CodingKey {
        case comment
        case commentID = "commentId"
        case dateTime, image, isLike
        case replyID = "replyId"
        case totalLike
        case userID = "userId"
        case userName
        case replyImage
    }

    
    init(comment: String, commentID: Int, dateTime: String, image: String, isLike: Int, replyID: Int, replyImage: String?, totalLike: Int, userID: String, userName: String) {
        self.comment = comment
        self.commentID = commentID
        self.dateTime = dateTime
        self.image = image
        self.isLike = isLike
        self.replyID = replyID
        self.replyImage = replyImage
        self.totalLike = totalLike
        self.userID = userID
        self.userName = userName
    }
}

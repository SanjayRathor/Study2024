//
//  UserInfo.swift

import Foundation

struct UserInfo: Codable {
    let username: String
    let avatarUrl: URL
    
    enum CodingKeys: String, CodingKey {
        case username
        case avatarUrl = "avatar_url"
    }
}

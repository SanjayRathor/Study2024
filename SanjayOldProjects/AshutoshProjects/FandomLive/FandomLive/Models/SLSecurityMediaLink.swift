

import Foundation

// MARK: - SLSecurityMediaLink
@objcMembers class SLSecurityMediaLink: NSObject, Codable {
    let message: String
    let result: [MediaLink]
    let status: String

    init(message: String, result: [MediaLink], status: String) {
        self.message = message
        self.result = result
        self.status = status
    }
}

// MARK: - Result
@objcMembers class MediaLink: NSObject, Codable {
    let contentPath: String
    let contentTitle: String

    enum CodingKeys: String, CodingKey {
        case contentPath = "ContentPath"
        case contentTitle = "ContentTitle"
    }

    init(contentPath: String, contentTitle: String) {
        self.contentPath = contentPath
        self.contentTitle = contentTitle
    }
}


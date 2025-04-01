//
//  SLSecurityImages.swift

import Foundation

// MARK: - SLSecurityImages
@objcMembers class SLSecurityImages: NSObject, Codable {
    let message: String
    let result: [SecurityImages]
    let status: String

    init(message: String, result: [SecurityImages], status: String) {
        self.message = message
        self.result = result
        self.status = status
    }
}

// MARK: - Result
@objcMembers class SecurityImages: NSObject, Codable {
    let imagePath: String

    init(imagePath: String) {
        self.imagePath = imagePath
    }
}


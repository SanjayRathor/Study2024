
import Foundation

// MARK: - FLSecurityUpdatesModel
@objcMembers class FLSecurityUpdatesModel: NSObject, Codable {
    let message: String
    let result: [SecurityUpdate]
    let status: String

    init(message: String, result: [SecurityUpdate], status: String) {
        self.message = message
        self.result = result
        self.status = status
    }
}

// MARK: - Result
@objcMembers class SecurityUpdate: NSObject, Codable {
    let campImage: String
    let campType, campaignID: Int
    let contentTitle, dateCreate, dateUpdate, resultDescription: String
    let userCreate: String
    let totalcomments: Int

    enum CodingKeys: String, CodingKey {
        case campImage = "CampImage"
        case campType = "CampType"
        case campaignID = "CampaignId"
        case contentTitle = "ContentTitle"
        case dateCreate = "DateCreate"
        case dateUpdate = "DateUpdate"
        case resultDescription = "Description"
        case userCreate = "UserCreate"
        case totalcomments
    }

    init(campImage: String, campType: Int, campaignID: Int, contentTitle: String, dateCreate: String, dateUpdate: String, resultDescription: String, userCreate: String, totalcomments: Int) {
        self.campImage = campImage
        self.campType = campType
        self.campaignID = campaignID
        self.contentTitle = contentTitle
        self.dateCreate = dateCreate
        self.dateUpdate = dateUpdate
        self.resultDescription = resultDescription
        self.userCreate = userCreate
        self.totalcomments = totalcomments
    }
}

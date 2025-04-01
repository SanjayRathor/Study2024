// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let sLStatisticsModel = try? newJSONDecoder().decode(SLStatisticsModel.self, from: jsonData)

import Foundation

// MARK: - SLStatisticsModel
@objcMembers class SLStatisticsModel: NSObject, Codable {
    let message: String
    let result: [VStatistics]
    let status: String

    init(message: String, result: [VStatistics], status: String) {
        self.message = message
        self.result = result
        self.status = status
    }
}

// MARK: - Result
@objcMembers class VStatistics: NSObject, Codable {
    let name, userCreate: String
    let flagLogoLink: String
    let peopleCount: Int
    let percentCount: String

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case userCreate = "UserCreate"
        case flagLogoLink, peopleCount, percentCount
    }

    init(name: String, userCreate: String, flagLogoLink: String, peopleCount: Int, percentCount: String) {
        self.name = name
        self.userCreate = userCreate
        self.flagLogoLink = flagLogoLink
        self.peopleCount = peopleCount
        self.percentCount = percentCount
    }
}

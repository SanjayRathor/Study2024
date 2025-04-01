
import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let fLInterests = try? newJSONDecoder().decode(FLInterests.self, from: jsonData)

import Foundation
@objcMembers class FLInterests: NSObject, Codable {
    let message: String
    let result: [Interests]
    let status: String

    init(message: String, result: [Interests], status: String) {
        self.message = message
        self.result = result
        self.status = status
    }
}

// MARK: - Result
@objcMembers class Interests: NSObject, Codable {
    let categoryID: Int
    let categoryName: String
    let interestData: [InterestDatum]

    enum CodingKeys: String, CodingKey {
        case categoryID = "categoryId"
        case categoryName, interestData
    }

    init(categoryID: Int, categoryName: String, interestData: [InterestDatum]) {
        self.categoryID = categoryID
        self.categoryName = categoryName
        self.interestData = interestData
    }
}

// MARK: - InterestDatum
@objcMembers class InterestDatum: NSObject, Codable {
    var id, status: Int
    var image, name: String

    init(id: Int, image: String, name: String, status: Int) {
        self.id = id
        self.image = image
        self.name = name
        self.status = status
    }
}

//
//  BrandSection.swift
//  TamimiEcom
//
//  Created by Sanjay Singh Rathor on 31/08/20.
//  Copyright © 2020  . All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

protocol DashBoardSection {
    var title: String {get}
    var count:Int {get}
    var id:Int {get}
    var sectionType:SectionType {get}
    var cellModels: [FeedItem] {get}
}

enum SectionType {
    case banner
    case brand
    case department
    case seller
}

enum FeedItem {
    case Brand(brand:Brand)
    case Department(department:Department)
    case BestSeller(product:[CategoryDetail])
    case Banner(banner:[Banner])
}

struct BrandSection :DashBoardSection {
    var title: String = ""
    var count = 0
    var id = 0
    var sectionType:SectionType = .brand
    var cellModels: [FeedItem] = []
    var brands: [Brand] = []
    init(_ data: JSON) {
        self.title = data["Name"].stringValue
        self.count = data["count"].intValue
        self.id = data["id"].intValue
        
        guard let jsonArray = data["items"].array, jsonArray.count > 0 else {
            return
        }
        let models = jsonArray.compactMap{ (dictionary) in
            return Brand(dictionary)
        }
        brands.append(contentsOf: models)
        brands.forEach { newsItem in
            cellModels.append(FeedItem.Brand(brand: newsItem))
        }
    }
    
}

struct Brand {
    var id: String = ""
    var parentCategoryId: String = ""
    var name: String = ""
    var isSubCategory: Bool = false
    var status: Bool = false
    var categoryLevel = 0
    var imageUrl: String = ""
    
    init(_ data: JSON) {
        self.id = data["_id"].stringValue
        self.isSubCategory = data["isSubCategory"].boolValue
        self.parentCategoryId = data["parentCategoryId"].stringValue
        self.status = data["status"].boolValue
        self.name = data["name"].stringValue
        self.categoryLevel = data["categoryLevel"].intValue
        let image = data["imageUrl"].stringValue
        self.imageUrl = image.replacingOccurrences(of: " ", with: "%20")
    }
}

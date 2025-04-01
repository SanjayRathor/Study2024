//
//  DepartmentsSection.swift
//  TamimiEcom
//
//  Created by Sanjay Singh Rathor on 31/08/20.
//  Copyright © 2020  . All rights reserved.
//

import Foundation
import SwiftyJSON

struct DepartmentSection :DashBoardSection {
    
    var title: String = ""
    var count = 0
    var id = 0
    var sectionType:SectionType = .department

    var cellModels: [FeedItem] = []
    
    var brands = [Department]()
    
    init(_ data: JSON) {
        self.title = data["Name"].stringValue
        self.count = data["count"].intValue
        self.id = data["id"].intValue
        guard let jsonArray = data["items"].array, jsonArray.count > 0 else {
            return
        }
        
        let model = jsonArray.compactMap{ (dictionary) in
            return Department(dictionary)
        }

        brands.append(contentsOf: model)        
        brands.forEach { newsItem in
            cellModels.append(FeedItem.Department(department: newsItem))
        }
    }
}

struct Department {
    
    var id: String = ""
    var status: Bool = false
    var name: String = ""
    var companyName: String = ""
    var imageUrl: String = ""
    var tmCode: String = ""

    init(_ data: JSON) {
        self.id = data["_id"].stringValue
        self.tmCode = data["tmCode"].stringValue
        self.status = data["status"].boolValue
        self.name = data["categoryName"].stringValue
        self.companyName = data["companyName"].stringValue
        let image = data["imageUrl"].stringValue
        self.imageUrl =  image.replacingOccurrences(of: " ", with: "%20")
    }
}


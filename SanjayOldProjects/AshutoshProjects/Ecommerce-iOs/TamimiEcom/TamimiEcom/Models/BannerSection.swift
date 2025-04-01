//
//  BannerSection.swift
//  TamimiEcom
//
//  Created by Ansh on 03/09/20.
//  Copyright ©  ltd. All rights reserved.
//

import SwiftyJSON

struct BannerSection :DashBoardSection {
    
    var title: String = ""
    var count = 0
    var id = 0
    var cellModels: [FeedItem] = []
    var sectionType:SectionType = .banner

    var banner: [Banner] = []

    init(_ data: JSON) {
        self.title = data["Name"].stringValue
        self.count = data["count"].intValue
        self.id = data["id"].intValue
        
        guard let jsonArray = data["items"].array, jsonArray.count > 0 else {
            return
        }
        
        let models = jsonArray.compactMap{ (dictionary) in
            return Banner(dictionary)
        }
        banner.append(contentsOf: models)
        cellModels.append(FeedItem.Banner(banner: banner))
    }
    
}
struct Banner {
    var id: String = ""
    var title: String = ""
    var imageUrl: String = ""
    var urlPath: String = ""
    var category: String = ""
    init(_ data: JSON) {
        self.id = data["_id"].stringValue
        self.title = data["title"].stringValue
          self.imageUrl = data["banner_image"].stringValue .replacingOccurrences(of: " ", with: "%20")
        self.urlPath = data["urlPath"].stringValue
        self.category = data["category"].stringValue
    }
}

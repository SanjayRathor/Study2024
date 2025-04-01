//
//  AdvertsSection.swift
//  TamimiEcom
//
//  Created by Ansh on 05/09/20.
//  Copyright © 2020  ltd. All rights reserved.
//

import Foundation
import SwiftyJSON

struct AdvertsSection  {
    
    var title: String = ""
    var count = 0
    var id = 0
    var adverts: [Adverts] = []

    init(_ data: JSON) {
        self.title = data["Name"].stringValue
        self.count = data["count"].intValue
        self.id = data["id"].intValue
        
        guard let jsonArray = data["items"].array, jsonArray.count > 0 else {
            return
        }
        
        let models = jsonArray.compactMap{ (dictionary) in
            return Adverts(dictionary)
        }
        adverts.append(contentsOf: models)
    }
    
}
struct Adverts {
    var id: String = ""
    var title: String = ""
    var imageUrl: String = ""
    var urlPath: String = ""
    var category: String = ""
    init(_ data: JSON) {
        self.id = data["_id"].stringValue
        self.title = data["title"].stringValue
        let image = data["banner_image"].stringValue
        self.imageUrl = image.replacingOccurrences(of: " ", with: "%20")
        self.urlPath = data["urlPath"].stringValue
        self.category = data["category"].stringValue

    }
}

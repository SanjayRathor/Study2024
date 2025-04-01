//
//  BestSellerSection.swift
//  TamimiEcom
//
//  Created by Sanjay Singh Rathor on 31/08/20.
//  Copyright © 2020  . All rights reserved.
//

import Foundation
import SwiftyJSON

struct BestSellerSection :DashBoardSection {
    
    var title: String = ""
    var count = 0
    var id = 0
    var sectionType:SectionType = .seller

    var cellModels: [FeedItem] = []
    var product = [CategoryDetail]()
    init(_ data: JSON) {
        self.title = data["Name"].stringValue
        self.count = data["count"].intValue
        self.id = data["id"].intValue
        guard let jsonArray = data["items"].array, jsonArray.count > 0 else {
            return
        }
        for idsDict in jsonArray {
                let categoryModel = CategoryDetail()
            if let selectedQuanity = idsDict["selectedQuanity"].rawValue as? String {
                    categoryModel.count = Int(selectedQuanity) ?? 0
                }else {
                    categoryModel.count = 0
                }
            if let isLiked = idsDict["isLiked"].rawValue as? Bool {
                    categoryModel.isLiked = isLiked
                }
             let productInfoRaw = idsDict["product"]
            if let productInfo  = productInfoRaw.rawValue as? [String:Any] {
                if let _id = productInfo["_id"] as? String  {
                categoryModel.id = _id
                categoryModel.name.update(other: productInfo)
                    product.append(categoryModel)
                }
                }            
        }
        if product.count > 0 {
        cellModels.append(FeedItem.BestSeller(product: product))
        }
    }
    init(dataDict: NSDictionary) {
        self.title = dataDict["Name"] as! String
        self.count = dataDict["count"] as! Int
        self.id = dataDict["id"] as! Int
         let jsonArray = dataDict["items"] as! NSArray
        for ids in jsonArray {
            if let idsDict = ids as? NSDictionary {
                let categoryModel = CategoryDetail()
            if let selectedQuanity = idsDict["selectedQuanity"] as? String {
                    categoryModel.count = Int(selectedQuanity) ?? 0
                }else {
                    categoryModel.count = 0
                }
            if let isLiked = idsDict["isLiked"] as? Bool {
                    categoryModel.isLiked = isLiked
                }
            if let productInfo  = idsDict["product"] as? [String:Any] {
                categoryModel.id = productInfo["_id"] as! String
                categoryModel.name.update(other: productInfo)
                    product.append(categoryModel)
                }
        }
        }
        cellModels.append(FeedItem.BestSeller(product: product))

    }
}


struct Media {
    var mediaType: String = ""
    var id: String = ""
    var imageUrl: String = ""
    
    init(_ data: JSON) {
        self.id = data["_id"].stringValue
        self.mediaType = data["mediaType"].stringValue
        let image = data["url"].stringValue
        self.imageUrl = image.replacingOccurrences(of: " ", with: "%20")
    }
}

struct Variants {
}

struct CategoryIds {
}

struct StoreCodes {
}

struct LikedByUsers {
}




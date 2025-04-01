//
//  Product.swift
//  SanjayDesignPatterns
//
//  Created by Sanjay Rathor on 30/03/25.
//  Copyright © 2025 Sanjay Singh Rathor. All rights reserved.
//

import Foundation

struct Product {
    let id: String
    private(set) var name: String
    private(set) var price: Double
    let description: String
    let category: String
    let imageUrl: String
    let rating: Rating

    init(id: String, name: String, price: Double, description: String, category: String, imageUrl: String, rating: Rating) throws {
           guard !id.isEmpty else { throw ProductError.invalidID }
            guard !name.trimmingCharacters(in: .whitespaces).isEmpty else { throw ProductError.emptyName }
            guard price >= 0 else { throw ProductError.negativePrice }
            guard !category.trimmingCharacters(in: .whitespaces).isEmpty else { throw ProductError.emptyCategory }
            guard let url = URL(string: imageUrl), url.scheme != nil else { throw ProductError.invalidImageURL }

            self.id = id
            self.name = name
            self.price = price
            self.description = description
            self.category = category
            self.imageUrl = imageUrl
            self.rating = rating
        }
    
    // Computed property: Price with tax (Assume 10% tax)
    var priceWithTax: Double {
        return price * 1.10
    }
    
    // Function: Apply Discount
    mutating func applyDiscount(_ percentage: Double) throws {
        guard percentage > 0 && percentage <= 100 else { throw ProductError.invalidDiscount }
        let discountAmount = (price * percentage) / 100
        self.price -= discountAmount
    }
    
    // Function: Change Product Name with Validation
    mutating func rename(newName: String) throws {
        guard !newName.isEmpty else { throw ProductError.invalidName }
        self.name = newName
    }
}

struct Rating {
    let rate: Double
    let count: Int

    init(rate: Double, count: Int) throws {
        guard rate >= 0 && rate <= 5 else { throw ProductError.invalidRating }
        guard count >= 0 else { throw ProductError.invalidRating }
        self.rate = rate
        self.count = count
    }
}

// Error Handling
enum ProductError: Error {
    case invalidName
    case invalidPrice
    case invalidCategory
    case invalidDiscount
    case invalidData
    case invalidID
    case emptyName
    case negativePrice
    case emptyCategory
    case invalidImageURL
    case invalidRating
}

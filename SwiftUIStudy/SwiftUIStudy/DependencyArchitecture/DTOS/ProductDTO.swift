//
//  ProductDTO.swift
//  SanjayDesignPatterns
//
//  Created by Sanjay Rathor on 30/03/25.
//  Copyright © 2025 Sanjay Singh Rathor. All rights reserved.
//

import Foundation

struct ProductDTO: Codable {
    let id: String
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    let rating: RatingDTO
    
    // Convert DTO -> Domain Model
    func toDomain() throws -> Product {
        let rating = try Rating(rate: rating.rate, count: rating.count) // Throwing initializer
        return try Product(
            id: id,
            name: title,
            price: price,
            description: description,
            category: category,
            imageUrl: image,
            rating: rating
        )
    }
    
    // Convert Domain Model -> DTO
    static func fromDomain(_ product: Product) -> ProductDTO {
        return ProductDTO(
            id: product.id,
            title: product.name,
            price: product.price,
            description: product.description,
            category: product.category,
            image: product.imageUrl,
            rating: RatingDTO(rate: product.rating.rate, count: product.rating.count)
        )
    }
}

struct RatingDTO: Codable {
    let rate: Double
    let count: Int
}

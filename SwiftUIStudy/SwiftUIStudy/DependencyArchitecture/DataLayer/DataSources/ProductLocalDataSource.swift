//
//  ProductLocalDataSource.swift
//  SanjayDesignPatterns
//
//  Created by Sanjay Rathor on 31/03/25.
//  Copyright © 2025 Sanjay Singh Rathor. All rights reserved.
//

import UIKit

import CoreData

protocol ProductLocalDataSource {
    func saveProducts(_ products: [ProductDTO]) throws
    func getProducts() throws -> [ProductDTO]
}

class ProductLocalDataSourceImpl: ProductLocalDataSource {
    func getProducts() throws -> [ProductDTO] {
        let jsonData = """
        [
            {
              "id": 1,
              "title": "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops",
              "price": 109.95,
              "description": "Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday",
              "category": "men's clothing",
              "image": "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg",
              "rating": {
                "rate": 3.9,
                "count": 120
              }
            },
            {
              "id": 2,
              "title": "Mens Casual Premium Slim Fit T-Shirts ",
              "price": 22.3,
              "description": "Slim-fitting style, contrast raglan long sleeve, three-button henley placket, light weight & soft fabric for breathable and comfortable wearing. And Solid stitched shirts with round neck made for durability and a great fit for casual fashion wear and diehard baseball fans. The Henley style round neckline includes a three-button placket.",
              "category": "men's clothing",
              "image": "https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg",
              "rating": {
                "rate": 4.1,
                "count": 259
              }
            }
        ]
        """.data(using: .utf8)!
        
        do {
            return try JSONDecoder().decode([ProductDTO].self, from: jsonData)
        } catch {
            throw DataError.decodingError
        }
    }
    
    func saveProducts(_ products: [ProductDTO]) throws {
        print("Save product to local database- \(products)")
    }
}

//
//  ProductRemoteDataSource.swift
//  SanjayDesignPatterns
//
//  Created by Sanjay Rathor on 31/03/25.
//  Copyright © 2025 Sanjay Singh Rathor. All rights reserved.
//

import Foundation

protocol ProductRemoteDataSource {
    func fetchProducts() async throws -> [ProductDTO]
}

class ProductRemoteDataSourceImpl: ProductRemoteDataSource {
    private let apiURL = URL(string: "https://fakestoreapi.com/products")!

    func fetchProducts() async throws -> [ProductDTO] {
        let (data, response) = try await URLSession.shared.data(from: apiURL)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw DataError.networkError
        }

        return try JSONDecoder().decode([ProductDTO].self, from: data)
    }
}

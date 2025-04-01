//
//  ProductRepositoryImpl.swift
//  SanjayDesignPatterns
//
//  Created by Sanjay Rathor on 30/03/25.
//  Copyright © 2025 Sanjay Singh Rathor. All rights reserved.
//

import Foundation

enum DataError: Error {
    case networkError
    case decodingError
    case databaseError
    case notFound
}

class ProductRepositoryImpl: ProductRepository {
    
    private let remoteDataSource: ProductRemoteDataSource
    private let localDataSource: ProductLocalDataSource
    
    init(remoteDataSource: ProductRemoteDataSource, localDataSource: ProductLocalDataSource) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    func getAllProducts() async throws -> [Product] {
        do {
            let productDTOs = try await remoteDataSource.fetchProducts()
            try localDataSource.saveProducts(productDTOs)
            return try productDTOs.map { try $0.toDomain() }
        } catch {
            throw DataError.networkError
        }
    }
    
    func addProduct(_ product: Product) async throws {
        let dto = ProductDTO.fromDomain(product)
        try localDataSource.saveProducts([dto]) 
    }
    
    func deleteProduct(by id: String) async throws {
        var products = try await getAllProducts()
        products.removeAll { $0.id == id }
        let dtos = products.map { ProductDTO.fromDomain($0) }
        try localDataSource.saveProducts(dtos) // Save updated list
    }
}

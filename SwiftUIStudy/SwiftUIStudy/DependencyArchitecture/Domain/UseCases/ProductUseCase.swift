//
//  ProductUseCase.swift
//  SanjayDesignPatterns
//
//  Created by Sanjay Rathor on 30/03/25.
//  Copyright © 2025 Sanjay Singh Rathor. All rights reserved.
//

import Foundation

protocol ProductUseCase {
    func getAllProducts() async throws -> [Product]
    func addProduct(_ product: Product) async throws
    func deleteProduct(by id: String) async throws
}

class ProductUseCaseImp : ProductUseCase {
    
    func addProduct(_ product: Product) async throws {
        try await self.repository.addProduct(product)
    }
    
    func deleteProduct(by id: String) async throws {
        try await self.repository.deleteProduct(by: id)
    }
    
    private let repository: ProductRepository
    
    init(repository: ProductRepository) {
        self.repository = repository
    }
    
    func getAllProducts() async throws -> [Product] {
        do {
            return try await repository.getAllProducts()
        } catch let error as ProductError {
            switch error {
            case .invalidName:
                throw AppError.validationError("Product name is invalid.")
            case .invalidPrice:
                throw AppError.validationError("Product price must be greater than zero.")
            case .invalidCategory:
                throw AppError.validationError("Product category is invalid.")
            default:
                throw AppError.validationError("Invalid product data.")
            }
        } catch let error as DataError {
            switch error {
            case .networkError:
                throw AppError.networkError
            case .databaseError:
                throw AppError.databaseError
            default:
                throw AppError.unknownError
            }
        } catch {
            throw AppError.unknownError
        }
    }
}

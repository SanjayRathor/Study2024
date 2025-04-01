//
//  ProductViewModel.swift
//  SanjayDesignPatterns
//
//  Created by Sanjay Rathor on 30/03/25.
//  Copyright © 2025 Sanjay Singh Rathor. All rights reserved.
//

import UIKit


@Observable
class ProductViewModel: ObservableObject {
    private let productsUseCase: ProductUseCase
    var products: [Product] = []
    var errorMessage: String?

    init(productUseCase: ProductUseCase) {
        self.productsUseCase = productUseCase
    }
   
    @MainActor
    func loadProducts() {
        Task {
            do {
                self.products = try await productsUseCase.getAllProducts()
            } catch let error as AppError {
                handleError(error)
            }
        }
    }

    private func handleError(_ error: AppError) {
        switch error {
        case .validationError(let message):
            errorMessage = message
        case .networkError:
            errorMessage = "Network issue. Please try again."
        case .databaseError:
            errorMessage = "Database error. Please restart the app."
        case .unknownError:
            errorMessage = "An unknown error occurred."
        }
    }
}

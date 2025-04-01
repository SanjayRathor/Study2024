//
//  ProductRepository.swift
//  SanjayDesignPatterns
//
//  Created by Sanjay Rathor on 30/03/25.
//  Copyright © 2025 Sanjay Singh Rathor. All rights reserved.
//

import UIKit

protocol ProductRepository {
    func getAllProducts() async throws -> [Product]
    func addProduct(_ product: Product) async throws
    func deleteProduct(by id: String) async throws
}

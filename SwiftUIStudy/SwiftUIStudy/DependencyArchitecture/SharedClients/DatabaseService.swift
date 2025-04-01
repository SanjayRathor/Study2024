//
//  DatabaseClient.swift
//  SanjayDesignPatterns
//
//  Created by Sanjay Rathor on 30/03/25.
//  Copyright © 2025 Sanjay Singh Rathor. All rights reserved.
//

import UIKit

protocol DatabaseService {
    func getAllUsers() -> [Product]
    func storeProduct(_ product: Product)
}

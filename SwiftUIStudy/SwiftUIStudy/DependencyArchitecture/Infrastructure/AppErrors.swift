//
//  AppErrors.swift
//  SanjayDesignPatterns
//
//  Created by Sanjay Rathor on 31/03/25.
//  Copyright © 2025 Sanjay Singh Rathor. All rights reserved.
//

import Foundation
enum AppError: Error {
    case validationError(String)    // Business logic errors (from `ProductError`)
    case networkError               // API failures (from `DataError`)
    case databaseError              // Core Data issues (from `DataError`)
    case unknownError               // Catch-all case
}

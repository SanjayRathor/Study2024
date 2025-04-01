//
//  TestViewModel.swift
//  SwiftUIStudy
//
//  Created by Sanjay Rathor on 04/03/25.
//

import UIKit

public enum LoadError: Error {
    case notEnoughData
    case tooMuchData
}

public class TestViewModel {
    public var names: [String] = []
    public init(names: [String]) {
        self.names = names
    }
    public func loadNames() async throws {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        names = ["Alice", "Bob", "Charlie"]        
      // throw LoadError.notEnoughData
    }
}



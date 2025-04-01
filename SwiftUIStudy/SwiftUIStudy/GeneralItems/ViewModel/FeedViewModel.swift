//
//  FeedViewModel.swift
//  SwiftUIStudy
//
//  Created by Sanjay Rathor on 06/03/25.
//

import UIKit

public enum FeedState {
    case notLoaded
    case loading
    case loaded([Post])
    case error(Error)
}

// MARK: - Post Model
public struct Post: Identifiable, Codable {
    public let id: UUID
    public let content: String
    public let createdAt: Date
    
    init(id: UUID = UUID(), content: String, createdAt: Date = Date()) {
        self.id = id
        self.content = content
        self.createdAt = createdAt
    }
}



@Observable
public class FeedViewModel {
    public var feedState: FeedState = .notLoaded
    private let network: any Networking

    public init(network: any Networking) {
      self.network = network
    }

    public func fetchPosts() async {
    feedState = .loading
    do {
      let posts = try await network.fetchPosts()
      feedState = .loaded(posts)
    } catch {
      feedState = .error(error)
    }
  }

  func createPost(withContents contents: String) async throws -> Post {
    return try await network.createPost(withContents: contents)
  }
}

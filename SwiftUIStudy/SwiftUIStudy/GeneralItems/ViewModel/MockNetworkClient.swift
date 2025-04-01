//
//  MockNetworkClient.swift
//  SwiftUIStudy
//
//  Created by Sanjay Rathor on 06/03/25.
//

import Foundation
//public class MockNetworkClient: Networking {
//    public init() {
//
//    }
//    public func fetchPosts() async throws -> [Post] {
//
//        return [
//            Post(id: UUID(), content: "This is the first post"),
//            Post(id: UUID(), content: "This is post number two"),
//            Post(id: UUID(), content: "This is post number three")
//        ]
//      }
//
//    public func createPost(withContents contents: String) async throws -> Post {
//      return Post(id: UUID(), content: contents)
//  }
//}

public class MockNetworkClient: Networking {
    public   init(fetchPostsResult: Result<[Post], Error>? = nil) {
       
    }
    public var fetchPostsResult: Result<[Post], Error> = .success([])
    
    public func fetchPosts() async throws -> [Post] {
        return try fetchPostsResult.get()
    }
    
    public  func createPost(withContents contents: String) async throws -> Post {
        return Post(id: UUID(), content: contents)
    }
}

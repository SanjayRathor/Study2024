//
//  NetworkClient.swift
//  SwiftUIStudy
//
//  Created by Sanjay Rathor on 06/03/25.
//

import Foundation

public protocol Networking {
  func fetchPosts() async throws -> [Post]
  func createPost(withContents contents: String) async throws -> Post
}

public class NetworkClient: Networking {
  let urlSession: URLSession
  let baseURL: URL = URL(string: "https://practicalios.dev/")!

  init(urlSession: URLSession) {
    self.urlSession = urlSession
  }

    public func fetchPosts() async throws -> [Post] {
    let url = baseURL.appending(path: "posts")
    let (data, _) = try await urlSession.data(from: url)

    return try JSONDecoder().decode([Post].self, from: data)
  }

    public func createPost(withContents contents: String) async throws -> Post {
    let url = baseURL.appending(path: "create-post")
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    let body = ["contents": contents]
    request.httpBody = try JSONEncoder().encode(body)

    let (data, _) = try await urlSession.data(for: request)

    return try JSONDecoder().decode(Post.self, from: data)
  }
}

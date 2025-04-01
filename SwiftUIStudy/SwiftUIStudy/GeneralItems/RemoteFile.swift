//
//  RemoteFile.swift
//  SwiftUIStudy
//
//  Created by Sanjay Rathor on 08/02/25.
//

import Foundation

extension URLSession {
    static let noCacheSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy
        =
            .reloadIgnoringLocalAndRemoteCacheData
        return URLSession(configuration: config)
    }()
}


struct RemoteFile<T: Decodable> {
    let url: URL
    let type: T.Type
    var contents: T {
        get async throws {
            let (data, _) = try await URLSession.noCacheSession.data(from: url)
            return try JSONDecoder().decode(T.self, from: data)
        }
    }
}

struct Message: Decodable, Identifiable {
    let id: Int
    var user: String
    var text: String
}


struct ChatMessage: Decodable, Identifiable {
    let id: Int
    var from: String
    var message: String
}

struct User: Decodable, Identifiable {
    let id: UUID
    let name: String
    let age: Int
}


func loadData() async {
    async let (userData, _) = URLSession.shared.data(from:URL(string: "https://hws.dev/user-24601.json")!)
    async let (messageData,_) = URLSession.shared.data(from:
                                            URL(string: "https://hws.dev/user-messages.json")!)
    do {
        let decoder = JSONDecoder()
        let user = try await decoder.decode(User.self, from:
                                                 userData)
        let messages = try await decoder.decode([ChatMessage].self,
                                                from: messageData)
        print("User \(user.name) has \(messages.count) message(s).")
    } catch {
        print("Sorry, there was a network problem.")
    }
}

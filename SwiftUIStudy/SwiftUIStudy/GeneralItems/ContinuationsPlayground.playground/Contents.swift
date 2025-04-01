import UIKit

struct Message: Decodable, Identifiable {
    let id: Int
    let from: String
    let message: String
}
/*
 func fetchMessages(completion: @Sendable @escaping ([Message])
 -> Void) {
 let url = URL(string: "https://hws.dev/user-messages.json")!
 URLSession.shared.dataTask(with: url) { data, response, error
 in
 if let data {
 if let messages = try?
 JSONDecoder().decode([Message].self, from: data) {
 completion(messages)
 return
 }
 }
 completion([])
 }.resume()
 }
 
 
 // func refresh() {
 // fetchMessages { message in
 // print("My Message count is \(message.count)")
 // }
 // }
 
 func fetchMessages() async -> [Message] {
 await withCheckedContinuation { continuation in
 fetchMessages { messages in
 continuation.resume(returning: messages)
 }
 }
 }
 
 let messages = await fetchMessages()
 print("Downloaded \(messages.count) messages.")
 
 
 */

func fetchMessages(completion: @Sendable @escaping ([Message])
                   -> Void) {
    let url = URL(string: "https://hws.dev/user-messages.json")!
    URLSession.shared.dataTask(with: url) { data, response, error
        in
        if let data = data {
            if let messages = try?
                JSONDecoder().decode([Message].self, from: data) {
                completion(messages)
                return
            }
        }
        completion([])
    }.resume()
}

enum FetchError: Error {
    case noMessages
}

func fetchMessages() async -> [Message] {
    do {
        return try await withCheckedThrowingContinuation { continuation in
            fetchMessages { messages in
                if messages.isEmpty {
                    continuation.resume(throwing: FetchError.noMessages)
                } else {
                    continuation.resume(returning: messages)
                }
            }
        }
    } catch {
        return [
            
            Message(id: 1, from: "Tom", message: "Welcome to MySpace! I'm your new friend.")
        ]
    }
}
let messages = await fetchMessages()
print("Downloaded \(messages.count) messages.")


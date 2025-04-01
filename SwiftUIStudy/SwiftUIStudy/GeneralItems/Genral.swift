//
//  Genral.swift
//  SwiftUIStudy
//
//  Created by Sanjay Rathor on 08/02/25.
//

import Foundation
import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task() {
            if let data = await fetchNews() {
                print("Downloaded \(data.count) bytes")
            } else {
                print("Download failed.")
            }
            
            if let favorites = try? await fetchFavorites() {
                print("Fetched \(favorites.count) favorites.")
            } else {
                print("Failed to fetch favorites.")
            }
              
        }
    }
}

extension ViewController {
    func fetchNews() async -> Data? {
        do {
            let url = URL(string: "https://hws.dev/news-1.json")!
            let (data,
                 _) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            print("Failed to fetch data")
            return nil
        }
    }
    
    func fetchFavorites() async throws -> [Int] {
        let url = URL(string: "https://hws.dev/user-favorites.json")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Int].self, from: data)
    }
    
    func metoo() async {
        print("kjkjknk")
    }
    
}

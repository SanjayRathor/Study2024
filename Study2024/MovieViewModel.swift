//
//  MovieViewModel.swift
//  Study2024
//
//  Created by Sanjay Singh Rathor on 15/10/23.
//

import UIKit
import Combine
import Foundation

final class MovieViewModel {
    
    /* func fetchURL<T: Codable>(_ url: URL) -> AnyPublisher<T, Error> {
     URLSession.shared.dataTaskPublisher(for: url)
     .tryMap({ result in
     let decoder = JSONDecoder()
     return try decoder.decode(T.self, from: result.data) })
     .eraseToAnyPublisher()
     }*/
    
    //The flatMap operator requires that the publisher it
    //operates on has the same error type as the publishers that it emits.
    //flatMap takes the output of a publisher, transforms that into a
    //new publisher and all values emitted by that new publisher are relayed to subscribers, making it appear as if it’s a single publisher that emits all of these values.
    
    /*  func fetchURL<T: Decodable>(_ url: URL) -> AnyPublisher<T, Error> {
     URLSession.shared.dataTaskPublisher(for: url)
     .mapError({ $0 as Error })
     .flatMap({ result -> AnyPublisher<T, Error> in
     guard let urlResponse = result.response as? HTTPURLResponse, (200...299).contains(urlResponse.statusCode) else {
     fatalError("We'll handle this later")
     }
     return Just(result.data).decode(type: T.self, decoder: JSONDecoder()).eraseToAnyPublisher()
     }).eraseToAnyPublisher()
     }
     */
    
  /*
   func fetchURL<T: Decodable>(_ url: URL) -> AnyPublisher<T, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ result in
                let decoder = JSONDecoder()
                guard let urlResponse = result.response as?
                        HTTPURLResponse, (200...299).contains(urlResponse.statusCode) else {
                    let apiError = try decoder.decode(APIError.self, from: result.data)
                    throw apiError
                }
                return try decoder.decode(T.self, from: result.data) })
            .eraseToAnyPublisher()
    }*/
    
  /*
   func fetchURL<T: Decodable>(_ url: URL) -> AnyPublisher<T, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ result in
                let decoder = JSONDecoder()
                return try decoder.decode(T.self, from: result.data)
                
            })
            .tryCatch({ err in
                print(err)
                return Just(12) .eraseToAnyPublisher()
            })
        
            .eraseToAnyPublisher()
    }*/
    
    
    
    func refreshToken() -> AnyPublisher<Bool, Never> {
        return Just(false).eraseToAnyPublisher()
    }
        
}

struct APIError: Decodable, Error {
    let statusCode: Int
}

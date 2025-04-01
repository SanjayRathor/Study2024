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
        
    
    
    
//    func crash() {
//        enum SimpleError: Error { case error }
//        var numbers = [5, 4, 3, 2, 1, -1, 7, 8, 9, 10]
//        var cancellable = Set<AnyCancellable>()
//
//         numbers.publisher
//           .tryMap { v in
//                if v > 0 {
//                    return v
//                } else {
//                    throw SimpleError.error
//                }
//           } .tryCatch({ err in
//               print("error has occured")
//           })
//           .sink(receiveCompletion: { completion in
//               if case .failure(let err) = completion {
//                   print("Retrieving data failed with error \(err.localizedDescription)")
//               }
//           }, receiveValue: { a in
//               print(a)
//           })
//    }
    
    
}




struct APIError: Decodable, Error {
    let statusCode: Int
}

/*
 func fetch(url: URL) -> AnyPublisher<[Post], Error> {
    Future { promise in
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                promise(.failure(error))
                return
            }
            
            do {
                let posts = try JSONDecoder().decode([Post].self, from: data!)
                promise(.success(posts))
            } catch {
                promise(.failure(error))
            }
        }.resume()
    }.eraseToAnyPublisher()
}

fetch(url: url)
    .sink(receiveCompletion: { completion in
        print(completion)
    }, receiveValue: { value in
        print(value)
    }).store(in: &cancellables)
*/



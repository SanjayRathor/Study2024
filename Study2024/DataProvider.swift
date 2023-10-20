//
//  DataProvider.swift
//  Study2024
//
//  Created by Sanjay Singh Rathor on 15/10/23.
//

import UIKit
import Combine

struct CardModel: Hashable, Decodable {
    let title: String
    let subTitle: String
    let imageName: String
}

//class DataProvider: NSObject {
//
//    let dataSubject = CurrentValueSubject<[CardModel], Never>([])
//    func fetch() {
//        let cards = (0..<20).map { i in
//            CardModel(title: "Title \(i)", subTitle: "Subtitle \(i)", imageName: "image_\(i)")
//        }
//        dataSubject.value = cards
//    }
//}

class DataProvider {
    func fetch() -> AnyPublisher<[CardModel], Never> {
        let cards = (0..<20).map { i in
            CardModel(title: "Title \(i)", subTitle: "Subtitle \(i)",
                      imageName: "image_\(i)")
        }
        return Just(cards).eraseToAnyPublisher()
        
    }
    
    func fetchImage(named imageName: String) -> AnyPublisher<UIImage?, URLError> {
        let url = URL(string: "https://imageserver.com/\(imageName)")!
        return URLSession.shared.dataTaskPublisher(for: url) .map { result in
            return UIImage(data: result.data) }
        .eraseToAnyPublisher()
    }
}




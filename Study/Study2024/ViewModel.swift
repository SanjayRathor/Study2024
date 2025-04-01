//
//  ViewModel.swift
//  Study2024
//
//  Created by Sanjay Singh Rathor on 06/10/23.
//

import UIKit
import Combine

struct WeatherStation {
    public let stationID: String
}
struct User {
    let name: CurrentValueSubject<String, Never>
}

class ViewModel: NSObject {
    var cancellable:AnyCancellable? = nil
    var subscriptions = Set<AnyCancellable>()
    let notiName = Notification.Name("com.publisher.combine")
    let weatherPublisher = PassthroughSubject<WeatherStation, URLError>()
    init(cancellable: AnyCancellable? = nil) {
        self.cancellable = cancellable
        super.init()
        //registerForNotification()
        //justCall()
        ///flatMapPublisher()
        ///mapPublisher()
        simplePublisher()
        loadFeeds()
        
    }
    
    func postNotificsation()  {
        NotificationCenter.default.post(name: notiName, object: nil, userInfo: ["SearchString": "gandupana"])
    }
    
    func registerForNotification() {
        NotificationCenter.default
            .publisher(for: notiName)
            .map({ ($0.userInfo!["SearchString"] as! String) }) // Introducing Map
            .sink { value in // "value" is of type String now
                print(value)
            }
            .store(in: &subscriptions)
    }
    
    
    func justCall() {
        class SomeObject {
            @Published var value = 0
        }
        let object = SomeObject()
        _ = Just("a,sjdhjksdak")
            .sink(
                receiveCompletion: {
                    print("Received completion (another)", $0)
                },
                receiveValue: {
                    print("Received value (another)", $0)
                })
    }
    
    func flatMapPublisher() {
        
        weatherPublisher.flatMap(maxPublishers: .max(1)) {  station -> URLSession.DataTaskPublisher in
            let url = URL(string:"https://jsonplaceholder.typicode.com/posts/\(station.stationID)")!
            return URLSession.shared.dataTaskPublisher(for: url)
        }
        .map(\.data)
        .map({ value in
            String(decoding: value, as: UTF8.self)
        })
        .sink(
            receiveCompletion: { completion in
                // Handle publisher completion (normal or error).
            },
            receiveValue: {value in
                print("\(value)")
            }
        ).store(in: &subscriptions)
        
        weatherPublisher.send(WeatherStation(stationID: "1")) // San Francisco, CA
        weatherPublisher.send(WeatherStation(stationID: "2")) // London, UK
        weatherPublisher.send(WeatherStation(stationID: "3")) // Beijing, CN
        weatherPublisher.send(WeatherStation(stationID: "4")) // Beijing, CN
        weatherPublisher.send(WeatherStation(stationID: "5")) // Beijing, CN
        weatherPublisher.send(WeatherStation(stationID: "6")) // Beijing, CN
        
    }
    
    func mapPublisher() {
        
        weatherPublisher.map { station -> URLSession.DataTaskPublisher in
            let url = URL(string:"https://jsonplaceholder.typicode.com/posts/\(station.stationID)")!
            return URLSession.shared.dataTaskPublisher(for: url)
        }
        .switchToLatest()
        .map(\.data)
        .map({ value in
            String(decoding: value, as: UTF8.self)
        })
        .sink(
            receiveCompletion: { completion in
                // Handle publisher completion (normal or error).
            },
            receiveValue: {value in
                print("\(value)")
            }
        ).store(in: &subscriptions)
        
        weatherPublisher.send(WeatherStation(stationID: "1")) // San Francisco, CA
        weatherPublisher.send(WeatherStation(stationID: "2")) // London, UK
        weatherPublisher.send(WeatherStation(stationID: "3")) // Beijing, CN
        weatherPublisher.send(WeatherStation(stationID: "4")) // Beijing, CN
        weatherPublisher.send(WeatherStation(stationID: "5")) // Beijing, CN
        weatherPublisher.send(WeatherStation(stationID: "6")) // Beijing, CN
    }
    
    
    func simplePublisher() {
        let userSubject = PassthroughSubject<User, Never>()
        userSubject
            .map { $0.name }
            .switchToLatest()
            .sink { print($0) }
            .store(in: &subscriptions)
        
        userSubject
            .flatMap { $0.name }
            .sink { print($0) }
            .store(in: &subscriptions)
        
        let user = User(name: .init("User 1"))
        userSubject.send(user)
        
        /* userSubject
         .flatMap(maxPublishers: .max(1)) { $0.name }
         .sink { print($0) }
         
         let user = User(name: .init("User 1"))
         userSubject.send(user)
         
         let anotherUser = User(name: .init("AnotherUser 1"))
         userSubject.send(anotherUser)
         
         anotherUser.name.send("AnotherUser 2")
         
         user.name.send("User 2")
         */
        
    }
}



extension ViewModel {
    func requestData() -> AnyPublisher<Data, URLError>  {
        let myUrl = URL(string: "https://www.donnywals.com")!
        return URLSession.shared.dataTaskPublisher(for: myUrl)
            .map(\.data)
            .eraseToAnyPublisher()
    }
    
    
    func loadFeeds() {
        var baseURL = URL(string: "https://www.donnywals.com")!
        
        ["/", "/the-blog", "/speaking", "/newsletter"].publisher
            .print()
            .setFailureType(to: URLError.self)
            .flatMap(maxPublishers: .max(1)) { path -> URLSession.DataTaskPublisher in
                let url = baseURL.appendingPathComponent(path)
                return URLSession.shared.dataTaskPublisher(for: url)
            }
            .sink(receiveCompletion: { completion in
                print("Completed with: \(completion)")
            },
            receiveValue: { result in
                print(result)
            }).store(in: &subscriptions)
    }
}

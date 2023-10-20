//
//  ViewController.swift
//  Study2024
//
//  Created by Sanjay Singh Rathor on 23/09/23.
//

import UIKit
import Combine

public struct MyDataClass: Codable {
    let original: String
    let md5: Int
}

class ViewController: UIViewController {
    var subscription1:Any? = nil
    var subscription2:Any? = nil
    var cancellable:Any? = nil

    var session =  URLSession.shared
    let subject = PassthroughSubject<Data, URLError>()
    var viewModel:ViewModel?
    
    let dataProvider =  DataProvider()
    override func viewDidLoad() {
        super.viewDidLoad()
        multicastPublisher()
       //sharePublisher()
       //fetch()
       //multiCast()
        //viewModel = ViewModel()
        //viewModel?.postNotificsation()
        dataProvider.fetch()
            .sink { completion in
                switch completion {
                case .finished:
                    print("Completed")
                case .failure(let err):
                    print("err")
                }
            } receiveValue: { models in
                print("models value \(models)")
        }

        
    }

    func multicastPublisher() {
               
        let multicasted = URLSession.shared
          .dataTaskPublisher(for: URL(string: "https://www.raywenderlich.com")!)
          .map(\.data)
          .multicast(subject: subject)

         subscription1 = multicasted
          .sink(
            receiveCompletion: { _ in },
            receiveValue: { print("subscription1 received: '\($0)'") }
          )
        
        subscription2 = multicasted
          .sink(
            receiveCompletion: { _ in },
            receiveValue: { print("subscription2 received: '\($0)'") }
          )
       //  cancellable = multicasted.connect()
    }
    
    func sharePublisher() {
        let shared = URLSession.shared
          .dataTaskPublisher(for: URL(string: "https://www.raywenderlich.com")!)
          .map(\.data)
         // .print("shared")
          .share()
        print("subscribing first")

         subscription1 = shared.sink(
          receiveCompletion: { _ in },
          receiveValue: { print("subscription1 received: '\($0)'") }
        )
        print("subscribing second")

         subscription2 = shared.sink(
          receiveCompletion: { _ in },
          receiveValue: { print("subscription2 received: '\($0)'") }
        )
    }

 /*
    func fetch() {
        guard let url = URL(string: "http://md5.jsontest.com/?text=example_text") else { return }
        
        subscription = URLSession.shared
          .dataTaskPublisher(for: url)
          .map(\.data)
          .decode(type: MyDataClass.self, decoder: JSONDecoder())
//          .tryMap({ data, _ in
//                  try JSONDecoder().decode(MyDataClass.self, from: data)
//          })
          .sink(receiveCompletion: { completion in
              
            if case .failure(let err) = completion {
              print("Retrieving data failed with error \(err)")
            }
              
          }, receiveValue: { object in
              print("Retrieved object \(object)")
        })
    }
  
  URLSession.shared
  .dataTaskPublisher(for: constrainedRequest) .tryCatch({ error -> URLSession.DataTaskPublisher in
  guard error.networkUnavailableReason == .constrained else { throw error
  }
  return session.dataTaskPublisher(for: normalRequest) })
  .sink(receiveCompletion: { completion in // handle completion
  }, receiveValue: { result in // handle received data
  })
  */
    
    func multiCast() {
        guard let url = URL(string: "http://md5.jsontest.com/?text=example_text") else { return }
        let publisher = session
          .dataTaskPublisher(for: url)
          .map(\.data)
          .multicast { PassthroughSubject<Data, URLError>() }
     
         subscription1 = publisher
          .sink(receiveCompletion: { completion in
            if case .failure(let err) = completion {
              print("Sink1 Retrieving data failed with error \(err)")
            }
          }, receiveValue: { object in
            print("Sink1 Retrieved object \(object)")
        })
        

         subscription2 = publisher
          .sink(receiveCompletion: { completion in
            if case .failure(let err) = completion {
              print("Sink2 Retrieving data failed with error \(err)")
            }
          }, receiveValue: { object in
            print("Sink2 Retrieved object \(object)")
        })

        
    }
}


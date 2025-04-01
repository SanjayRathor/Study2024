import UIKit
import Combine
import Foundation

//Need to implement the rumble
enum TestFailureCondition: Error {
    case invalidServerResponse
    case invalidServerFucked
}

//let myURL = URL(string: "https://postman-echo.com/time/valid?timestamp=2016-10-10")
//struct PostmanEchoTimeStampCheckResponse: Decodable, Hashable {
//    let validmm: Bool
//}

//let remoteDataPublisher = URLSession.shared.dataTaskPublisher(for: myURL!)
//    //.map { $0.data }
//    .tryMap { data, response -> Data in
//              guard let httpResponse = response as? HTTPURLResponse,
//                 httpResponse.statusCode == 200 else {
//                 throw TestFailureCondition.invalidServerResponse
//              }
//
//              throw TestFailureCondition.invalidServerResponse
//           }
//
//
//      .mapError({ (err) in
//             return TestFailureCondition.invalidServerFucked
//     })
//    .decode(type: PostmanEchoTimeStampCheckResponse.self, decoder: JSONDecoder())
//
//
//let cancellableSink = remoteDataPublisher
//    .sink(receiveCompletion: { completion in
//       // print(".sink() received the completion", String(describing: completion))
//
//        switch completion {
//        case .finished:
//            break
//        case .failure(let anError):
//            print("received error: ", anError)
//        }
//    },
//      receiveValue: { someValue in
//        print(".sink() received \(someValue)")
//
//    })

struct IPInfo: Codable {
    // matching the data structure returned from ip.jsontest.com
    var ipweee: String
}

/*
let myUR2L = URL(string: "http://ip.jsontest.com")
let remoteDataPublisher = URLSession.shared.dataTaskPublisher(for: myUR2L!)
.delay(for: 10, scheduler: backgroundQueue)
    .map({ (inputTuple) -> Data in
        return inputTuple.data
    })
    .decode(type: IPInfo.self, decoder: JSONDecoder())
    .catch { err in
        
        return Just(IPInfo(ipweee: "8.8.8.8"))
}
    
.sink(receiveCompletion: { completion in
    switch completion {
    case .finished:
        break
    case .failure(let anError):
        print("received error: ", anError)
    }
},
      receiveValue: { someValue in
        print(".sink() received \(someValue)")
        
})

*/

//let myEmptyPublisher = Empty<String, Never>()
//    .sink { (value) in
//        print(value)
//}
//let cancellable = Timer.publish(every: 1.0, on: RunLoop.main, in: .common)
//    .autoconnect()
//.sink { receivedTimeStamp in
//  print("passed through: ", receivedTimeStamp)
//}
//
//let timerPublisher = Timer.publish(every: 1.0, on: RunLoop.main, in: .default)
//let cancellableSink = timerPublisher
//.sink { receivedTimeStamp in
//print("passed through: ", receivedTimeStamp) }
//  // no values until the following is invoked elsewhere/later:
//let cancellablePublisher = timerPublisher.connect()
//

import Combine
import Foundation

enum ServiceError: Error {
    case url(URLError?)
    case decode
    case unknown(Error)
}

struct Item: Codable {
    let id: Int
    let title: String
    let completed: Bool
}

let urlRequest: URLRequest? = {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "jsonplaceholder.typicode.com"
    components.path = "/todos/1"
    
    guard let url = components.url else { return nil }
    
    var urlRequest = URLRequest(url: url)
    urlRequest.timeoutInterval = 5.0
    return urlRequest
}()

func get() -> AnyPublisher<Item, ServiceError> {
    guard let request = urlRequest else {
        fatalError("request not available")
    }
    
    return URLSession.shared
        .dataTaskPublisher(for: request) // ((Data, URLResponse), URLError)
        .map { $0.data } // (Data, URLError)
        .decode(type: Item.self, decoder: JSONDecoder()) // (Item, Error)
        .mapError { error -> ServiceError in
            switch error {
            case is DecodingError: return ServiceError.decode
            case is URLError: return ServiceError.url(error as? URLError)
            default: return ServiceError.unknown(error)
            }
    }
    .retry(1)
    .eraseToAnyPublisher()
}

/*:
 Marking request
 */

get()
    .receive(on: RunLoop.main)
    .sink(receiveCompletion: { completion in
        switch completion {
        case .finished: print("🏁 finished")
        case .failure(let error): print("❗️ failure: \(error)")
        }
    }, receiveValue: { value in
        print("✅ value: \(value)")
    })


get()
//.scanFuture
let q = DispatchQueue(label: "adasdasd")
let publisher = [1,2,3,4,5,6].publisher
  .reduce(10, { prevVal, newValueFromPublisher -> Int in
    return prevVal + newValueFromPublisher }
)
  //.collect(.byTime(q, 20.0))
    .sink { value  in
        print(value)
}

//let t = Timer.publish(every: 0.4, on: .main, in: .default)
//    .scan(0) {prev,_ in prev+1}
//    .collect(.byTime(DispatchQueue.main, .seconds(1)))
//    .sink(receiveCompletion: {print($0)}) {print($0)}
//let cancellable = t.connect()
//    .delay(3)
//





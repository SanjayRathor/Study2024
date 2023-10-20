import UIKit
import Combine

func notifications() {
    
    let myNotification = Notification.Name("MyNotification")
    let publisher = NotificationCenter.default
        .publisher(for: myNotification, object: nil)
    let subscription = publisher
    subscription.sink { notification in
        ///print("notification")
    }
    
    subscription.sink { completion in
        ///print("completion")
    } receiveValue: { notification in
        ///print("receiveValue")
    }
    publisher.center.post(name: myNotification, object: nil)
}

notifications()



/*
 func assigning() {
 class SomeObject {
 var value: String = "" {
 didSet {
 print(value)
 }
 }
 }
 
 let object = SomeObject()
 let publisher = ["Hello", "world!"].publisher
 _ = publisher
 .assign(to: \.value, on: object)
 }
 assigning()
 
 func assigning() {
 
 class SomeObject {
 @Published var value = 0
 }
 
 let object = SomeObject()
 object.$value
 .sink {
 print($0)
 }
 
 (0..<10).publisher
 .assign(to: &object.$value)
 }
 assigning()
 
 
 final class IntSubscriber: Subscriber {
 
 typealias Input = Int
 typealias Failure = Never
 
 func receive(subscription: Subscription) {
 print("Received Subscription")
 subscription.request(.max(3))
 }
 
 func receive(_ input: Int) -> Subscribers.Demand {
 print("Received value", input)
 return .max(4)
 }
 
 func receive(completion: Subscribers.Completion<Never>) {
 print("Received completion", completion)
 }
 }
 //let publisher = (1...6).publisher
 //let subscriber = IntSubscriber()
 //publisher.subscribe(subscriber)
 
 func futureIncrement( integer: Int, afterDelay delay: TimeInterval) -> Future<Int, Never> {
 Future<Int, Never> { promise in
 DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
 promise(.success(integer + 1))
 }
 }
 }
 
 let future = futureIncrement(integer: 1, afterDelay: 3)
 future
 .sink(receiveCompletion: { print($0) },
 receiveValue: { print($0) })
 
 enum MyError: Error {
 case test
 }
 
 final class StringSubscriber: Subscriber {
 typealias Input = String
 typealias Failure = MyError
 
 func receive(subscription: Subscription) {
 subscription.request(.max(2))
 }
 
 func receive(_ input: String) -> Subscribers.Demand {
 print("Received value", input)
 return input == "World" ? .max(1) : .none
 }
 
 func receive(completion: Subscribers.Completion<MyError>) {
 print("Received completion", completion)
 }
 }
 
 let subscriber = StringSubscriber()
 let subject = PassthroughSubject<String, MyError>()
 subject.subscribe(subscriber)
 
 let subscription = subject
 .sink(
 receiveCompletion: { completion in
 print("Received-2 completion (sink)", completion)
 },
 receiveValue: { value in
 print("Received-2 value (sink)", value)
 }
 )
 
 subject.send("1")
 subscription.cancel()
 subject.send("Still there?")
 subject.send(completion: .finished)
 subject.send("How about another one?")
 
 
 var subscriptions = Set<AnyCancellable>()
 let subject = CurrentValueSubject<Int, Never>(0)
 
 
 subject
 .print()
 .sink(receiveValue: { print($0) })
 .store(in: &subscriptions)
 
 
 subject.send(1)
 subject.send(completion: .finished)
 subject.send(2)
 
 
 ///Dynamically adjusting demand
 ///
 final class IntSubscriber: Subscriber {
 typealias Input = Int
 typealias Failure = Never
 
 func receive(subscription: Subscription) {
 subscription.request(.max(1))
 }
 
 func receive(_ input: Int) -> Subscribers.Demand {
 print("Received value", input)
 switch input {
 case 1:
 return .max(2)
 case 3:
 return .max(1)
 default:
 return .none
 }
 }
 
 func receive(completion: Subscribers.Completion<Never>) {
 print("Received completion", completion)
 }
 }
 //1. The newmaxis4(originalmaxof 1+ newmaxof2).
 //2. The new max is 4 (previous 3 + new 1).
 //3. max remains 4 (previous 4 + new 0).
 
 
 let subscriber = IntSubscriber()
 let subject = PassthroughSubject<Int, Never>()
 
 subject.subscribe(subscriber)
 
 
 subject.send(1)
 subject.send(2)
 subject.send(3)
 subject.send(4)
 subject.send(5)
 subject.send(6)
 
 
 let subject = PassthroughSubject<Int, Never>()
 let publisher = subject.eraseToAnyPublisher()
 publisher
 .sink(receiveValue: { print($0) })
 subject.send(1)
 
 //Operators are publishers
 [2, 3, 4, 5, 6].publisher
 // .collect(1)
 .tryMap{ try $0*5}
 .sink(receiveCompletion: { print($0)
 },
 receiveValue: {
 
 print($0) })
 
 
 
 ["A", nil, "C"].publisher
 .eraseToAnyPublisher()
 .replaceNil(with: "-") // 2
 .sink(receiveValue: { print($0) }) // 3
 
 
 
 let words = "hey hey there! want to listen to mister mister ? to listen"
 .components(separatedBy: " ")
 .publisher
 words
 .removeDuplicates()
 .sink(receiveValue: { print($0) })
 
 
 struct Person {
 let id: Int
 let name: String
 }
 
 let people = [
 (123, "Shai Mishali"),
 (777, "Marin Todorov"),
 (214, "Florent Pillet")
 ]
 .map(Person.init)
 .publisher
 .contains(where: { $0.id == 800 })
 .sink(receiveValue: { contains in
 print(contains ? "Criteria matches!"
 : "Couldn't find a match for the criteria")
 })
 
 
 func fetch() {
 guard let url = URL(string: "http://md5.jsontest.com/?text=example_text") else { return }
 
 let subscription = URLSession.shared
 .dataTaskPublisher(for: url)
 .sink(receiveCompletion: { completion in
 
 if case .failure(let err) = completion {
 print("Retrieving data failed with error \(err)")
 }
 }, receiveValue: { data, response in
 print("Retrieved data of size \(data.count), response = \(response)")
 })
 }
 
 fetch()
 
 let subscription = Timer
 .publish(every: 1.0, on: .main, in: .common)
 .autoconnect()
 .scan(0) { counter, _ in counter + 1 }
 .sink { counter in
 print("Counter is \(counter)")
 }
 
 // 1
 class TestObject: NSObject {
 // 2
 @objc dynamic var integerProperty: Int = 0
 }
 let obj = TestObject()
 // 3
 let subscription = obj.publisher(for: \.integerProperty)
 .sink {
 print("integerProperty changes to \($0)")
 }
 // 4
 obj.integerProperty = 100
 obj.integerProperty = 200
 
 @objc dynamic var stringProperty: String = ""
 @objc dynamic var arrayProperty: [Float] = []
 
 Observation options
 • .initial emits the initial value.
 • .prior emits both the previous and the new value when a change occurs.
 • .old and .new are unused in this publisher, they both do nothing (just let the new value through).
 If you don‘t want the initial value, you can simply write:
 obj.publisher(for: \.stringProperty, options: [])
 
 let subscription = obj.publisher(for: \.integerProperty,
 options: [.prior])
 
 integerProperty changes to 0
 integerProperty changes to 100
 integerProperty changes to 100
 integerProperty changes to 200
 
 class MonitorObject: ObservableObject {
 @Published var someProperty = false
 @Published var someOtherProperty = ""
 }
 let object = MonitorObject()
 let subscription = object.objectWillChange.sink {
 print("object will change")
 }
 object.someProperty = true
 object.someOtherProperty = "Hello world"
 
 Unfortunately, you can‘t know which property actually changed. This is designed to work very well with SwiftUI which coalesces events to streamline screen updates.
 
 
 ///Combine offers two operators for you to manage resources: The share() operator and the multicast(_:) operator.
 
 let shared = URLSession.shared
 .dataTaskPublisher(for: URL(string: "https://www.raywenderlich.com")!)
 .map(\.data)
 .print("shared")
 //.share()
 print("subscribing first")
 
 let subscription1 = shared.sink(
 receiveCompletion: { _ in },
 receiveValue: { print("subscription1 received: '\($0)'") }
 )
 print("subscribing second")
 
 let subscription2 = shared.sink(
 receiveCompletion: { _ in },
 receiveValue: { print("subscription2 received: '\($0)'") }
 )
 
 
 func performSomeWork() throws -> Int {
 print("Performing some work and returning a result")
 return 5
 }
 
 let future = Future<Int, Error> { fulfill in
 do {
 let result = try performSomeWork()
 fulfill(.success(result))
 } catch {
 fulfill(.failure(error))
 }
 }
 print("Subscribing to future...")
 
 let subscription1 = future
 .sink(
 receiveCompletion: { _ in print("subscription1 completed") },
 receiveValue: { print("subscription1 received: '\($0)'") }
 )
 
 let subscription2 = future
 .sink(
 receiveCompletion: { _ in print("subscription2 completed") },
 receiveValue: { print("subscription2 received: '\($0)'") }
 )
 
 
 class Person {
 let id = UUID()
 var name = "Unknown"
 }
 
 let person = Person()
 print("1", person.name)
 Just("Shai")
 .setFailureType(to: )
 .assign(to: \.name, on: person) // 4
 //.setFailureType(to: Error.self)
 
 
 let imageView = UIImageView()
 let notFoundImage: UIImage? = UIImage()
 let imageURLPublisher = PassthroughSubject<URL, RequestError>()
 let cancellable = imageURLPublisher.flatMap { requestURL in
 return URLSession.shared.dataTaskPublisher(for: requestURL)
 .mapError { error -> RequestError in
 return RequestError.sessionError(error: error)
 }
 }.map { (result) -> UIImage? in
 return UIImage(data: result.data)
 }
 .replaceError(with: notFoundImage)
 .assign(to: \.image, on: imageView)
 extension NSNotification.Name {
 static let fetchedData = Self(rawValue: "fetchedData")
 }
 */

struct Coordinate {
    var x:Int
    var y:Int
}
var subscriptions = Set<AnyCancellable>()

func display() {
    /* let publisher = PassthroughSubject<Coordinate, Never>()
     
     publisher
     .map(\.x, \.y)
     .sink(receiveValue: { x, y in
     print( "The coordinate at (\(x), \(y)) is in quadrant")
     })
     .store(in: &subscriptions)
     
     publisher.send(Coordinate(x: 10, y: -8))
     publisher.send(Coordinate(x: 0, y: 5))
     
     
     Just("Directory name that does not exist")
     .tryMap { try
     FileManager.default.contentsOfDirectory(atPath: $0) }
     .sink(receiveCompletion: { print($0) },
     receiveValue: { print($0) })
     .store(in: &subscriptions)
     */
    
    
    /* publisher.flatMap(maxPublishers: .max(2), publisher2)
     .sink { completion in
     print("\n\(completion)")
     } receiveValue: { value in
     print("\(value)")
     }
     
     ["A", nil, "C"].publisher
     .eraseToAnyPublisher()
     .replaceNil(with: "-") // 2
     .sink(receiveValue: { print($0) }) // 3
     .store(in: &subscriptions)
     
     let intPublisher = [1, 2, 3].publisher
     .scan(10) { latest, current in
     print("latest - \(latest)")
     print("current - \(current)")
     return latest + current
     }
     .sink { value in
     // print("\(value)")
     }
     */
    
    //    let intPublisher = [[1, 2],[ 3],[ 3],[ 3],[ 3],[ 3],[ 3],[ 3]].publisher
    //        .flatMap(maxPublishers: .max(1), { items in
    //            items.publisher
    //                .
    //        })
    //        .sink { value in
    //             print("\(value)")
    //         }
}

//display()

func flatPublisher() {
    /* let userSubject = PassthroughSubject<User, Never>()
     
     userSubject
     .map { $0.name }
     .switchToLatest()
     //        .flatMap(maxPublishers: .max(1)) { $0.name }
     .sink { print($0) }
     
     let user = User(name: .init("User 1"))
     userSubject.send(user)
     
     
     let anotherUser = User(name: .init("AnotherUser 1"))
     userSubject.send(anotherUser)
     
     let anotherUser2 = User(name: .init("AnotherUser 3"))
     userSubject.send(anotherUser2)
     
     
     //    (0..<10).flatMap({ _ in
     //        let user = User(name: .init("User 1"))
     //        userSubject.send(user)
     //    })
     */
    
    
    let weatherPublisher = PassthroughSubject<WeatherStation, URLError>()
    weatherPublisher.flatMap { station -> URLSession.DataTaskPublisher in
        let url = URL(string:"https://weatherapi.example.com/stations/\(station.stationID)/observations/latest")!
        return URLSession.shared.dataTaskPublisher(for: url)
    }
    .sink(
        receiveCompletion: { completion in
            // Handle publisher completion (normal or error).
        },
        receiveValue: {value in
            print("\(value)")
        }
    )
    
    
    weatherPublisher.send(WeatherStation(stationID: "KSFO")) // San Francisco, CA
    weatherPublisher.send(WeatherStation(stationID: "EGLC")) // London, UK
    weatherPublisher.send(WeatherStation(stationID: "ZBBB")) // Beijing, CN
    
}

public struct WeatherStation {
    public let stationID: String
}

struct User {
    let name: CurrentValueSubject<String, Never>
}
//var subscriptions = Set<AnyCancellable>()

flatPublisher()



//enum MyError: Error {
//    case outOfBounds
//}
//[1, 2, 3].publisher .tryMap({ int in
//    guard int < 3 else {
//        throw MyError.outOfBounds
//    }
//    return int * 2 })
//.sink(receiveCompletion: { completion in
//    print(completion)
//}, receiveValue: { val in print(val)
//})

/*
 @propertyWrapper
 struct Wrapper<T> {
 var wrappedValue: T
 var projectedValue: Wrapper<T> { return self }
 func foo() { print("Foo") }
 }
 
 struct HasWrapper {
 @Wrapper var x: Int
 
 
 func foo() {
 print(x) // `wrappedValue`
 print(_x) // wrapper type itself
 print($x) // `projectedValue`
 }
 
 }
 ///We can access the wrapper type by adding an underscore to the variable name:
 let a = HasWrapper(x: 10)
 a.foo()
 print(a.$x)
 
 var cancellables = Set<AnyCancellable>()
 
 let left = CurrentValueSubject<Int, Never>(0)
 let right = CurrentValueSubject<Int, Never>(0)
 
 //.zip(<#T##other: Publisher##Publisher#>)
 left.merge(with:right)
 .sink(receiveValue: { value in
 print("Print:- \(value)")
 }).store(in: &cancellables)
 
 
 
 var cancellables = Set<AnyCancellable>()
 let left = CurrentValueSubject<Int, Never>(0)
 let right = CurrentValueSubject<Int, Never>(0)
 
 let combined = left.combineLatest(right).sink(receiveValue: {
 val in
 print(val, "combined")
 }).store(in: &cancellables)
 
 left.value = 1
 left.value = 2
 left.value = 3
 right.value = 1
 //right.value = 2
 //right.value = 2
 */
//func createFuture() -> Future<Int, Never> {
//    return Future { promise in
//        promise(.success(Int.random(in: (1...100)))) }
//}
//
//func createDeferredFuture() -> Deferred<Future<Int, Never>> {
//    return Deferred {
//          return Future { promise in promise(.success(Int.random(in: (1..<Int.max))))
//    }
//   }
//}
/////The publisher will not perform work until it has subscribers
/////If you subscribe to the same instance of this publisher more than once, the work will be repeated
//
//createFuture()

var cancellables = Set<AnyCancellable>()
let publisher = [1, 2, 3].publisher
let subject = PassthroughSubject<Int, Never>()

subject
    .sink(receiveValue: { receivedInt in
        print("subject", receivedInt)
    })
    .store(in: &cancellables)

publisher.subscribe(subject)
publisher.subscribe(subject)
.store(in: &cancellables)



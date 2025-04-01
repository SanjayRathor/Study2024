import Combine
import SwiftUI
import PlaygroundSupport


//[1, 2, 3] .publisher
//    .map { $0}
//    .sink { print($0) }

/*
 struct User {
 let name: CurrentValueSubject<String, Never>
 }
 
 let userSubject = PassthroughSubject<User, Never>()
 
 //userSubject
 //    .flatMap(maxPublishers: .max(1))  { $0.name } // 🛑 Oops, compilation error here
 //    .sink { print($0) }
 
 userSubject
 .map { $0.name }
 .switchToLatest()
 .sink { print($0) }
 
 let user = User(name: .init("User 1"))
 userSubject.send(user)
 
 let anotherUser = User(name: .init("AnotherUser 1"))
 userSubject.send(anotherUser)
 
 anotherUser.name.send("AnotherUser 2")
 user.name.send("User 2")
 
 let anotherUser22 = User(name: .init("AnotherUser asdads"))
 userSubject.send(anotherUser22)
 
 public struct Chatter {
 public let name: String
 public let message: CurrentValueSubject<String, Never>
 public init(name: String, message: String) {
 self.name = name
 self.message = CurrentValueSubject(message)
 }
 }
 
 // 1
 let charlotte = Chatter(name: "Charlotte", message: "Hi, I'm Charlotte!")
 let james = Chatter(name: "James", message: "Hi, I'm James!")
 // 2
 let chat = CurrentValueSubject<Chatter, Never>(charlotte)
 // 3
 chat
 // 6
 .flatMap(maxPublishers:.max(2) ) { $0.message }
 // 7
 .sink(receiveValue: { print($0) })
 
 // 4
 charlotte.message.value = "Charlotte: How's it going?"
 // 5
 chat.value = james
 
 james.message.value = "James: Doing great. You?"
 charlotte.message.value = "Charlotte: I'm doing fine thanks."
 
 
 // 8
 let morgan = Chatter(name: "Morgan",
 message: "Hey guys, what are you up to?")
 // 9
 chat.value = morgan
 // 10
 charlotte.message.value = "Did you hear something?"
 
 
 // 1
 ["A", nil, "C"].publisher
 .replaceNil(with: "-")
 .compactMap{$0}
 .collect(20)
 // 2
 .sink(receiveValue: { print($0) }) // 3
 
 
 let empty = Empty<Int, Never>()
 // 2
 empty
 .sink(receiveCompletion: { print($0) },
 receiveValue: { print($0) })
 
 
 
 
 //Filtering Operators
 let numbers = (1...10).publisher
 // 2
 numbers.filter { $0.isMultiple(of: 3) }
 .removeDuplicates()
 .sink(receiveValue: { n in
 print("\(n) is a multiple of 3!")
 })
 
 
 let adnkja =  ["a", "1.24", "3", "def", "45", "0.23"]
 
 print(adnkja.map{Float($0)})
 print(adnkja.compactMap{Float($0)})
 
 
 // 1
 let numbers = (1...10_000).publisher
 // 2
 numbers
 .ignoreOutput()
 .sink(receiveCompletion: { print("Completed with: \($0)") },
 receiveValue: { print($0) })
 
 // 1
 let numbers = (1...9).publisher
 // 2
 numbers
 .print("numbers")
 .last(where: { $0 % 2 == 0 })
 .sink(receiveCompletion: { print("Completed with: \($0)") },
 receiveValue: { print($0) })
 
 */
/*
 let numbers = PassthroughSubject<Int, Never>()
 numbers
 .last(where: { $0 % 2 == 0 })
 .sink(receiveCompletion: {
 print("Completed with: \($0)")
 
 },
 receiveValue: { print($0) }
 )
 numbers.send(1)
 numbers.send(2)
 numbers.send(3)
 numbers.send(4)
 numbers.send(5)
 numbers.send(completion: .finished)
 
 //let numbersFilter = (1...10)
 //numbersFilter.filter {
 //    print("YYYYYYYYY")
 //    return $0 % 5 != 0
 //}
 
 let numbers = (2...10).publisher
 // 2
 numbers
 //.dropFirst(8)
 
 // .drop(while: { $0 % 5 != 0 })
 .drop(while: {
 print("x")
 return $0 % 2 == 0
 })
 .sink(receiveValue: {
 print($0) })
 
 
 let isReady = PassthroughSubject<Void, Never>()
 isReady
 .sink(receiveValue: {
 print($0)
 }
 )
 
 
 let taps = PassthroughSubject<Int, Never>()
 // 2
 taps
 .drop(untilOutputFrom: isReady)
 .sink(receiveValue: {
 print($0)
 }
 )
 // 3
 (1...5).forEach { n in
 taps.send(n)
 if n == 3 {
 isReady.send()
 }
 }
 
 
 let numbers = (1...1000).publisher
 // 2
 numbers
 //.prefix(1)
 .prefix(while: { $0 < 3 })
 //.last()
 //.first(where: { $0 < 3 })
 .sink(receiveCompletion: { print("Completed with: \($0)") },
 receiveValue: { print($0) })
 //Use prefix(2) to allow the emission of only the first two values. As soon as two values are emitted, the publisher completes.
 
 //prefix(untilOutputFrom:)
 let isReady = PassthroughSubject<Void, Never>()
 let taps = PassthroughSubject<Int, Never>()
 // 2
 taps
 .prefix(untilOutputFrom: isReady)
 .sink(receiveCompletion: { print("Completed with: \($0)") },
 receiveValue: { print($0) })
 // 3
 (1...5).forEach { n in taps.send(n)
 if n == 2 {
 isReady.send() }
 }
 
 
 let publisher = [3, 4].publisher
 // 2
 publisher
 .prepend(1, 2)
 .sink(receiveValue: { print($0) })
 
 
 let publisher = [5, 6, 7].publisher
 // 2
 publisher
 //.prepend([3, 4])
 //.prepend(Set(1...2))
 .prepend(stride(from: 6, to: 20, by: 2))///छलांग
 .sink(receiveValue: { print($0) })
 
 
 let publisher1 = [3, 4].publisher
 let publisher2 = [1, 2].publisher
 // 2
 publisher1
 .prepend(publisher2)
 .sink(receiveValue: { print($0) })
 
 
 
 let publisher1 = [3, 4].publisher
 let publisher2 = PassthroughSubject<Int, Never>()
 // 2
 publisher1
 .prepend(publisher2)
 .sink(receiveValue:
 { print($0) })
 
 // 3
 publisher2.send(1)
 publisher2.send(2)
 
 //how can Combine know the prepended publisher, publisher2, has finished emitting values? It doesn’t, because it has emitted values but no completion event. For that reason, a prepended publisher must complete so Combine knows it has finished prepending and can continue to the primary publisher.
 publisher2.send(completion:.finished)
 
 let publisher = [1].publisher
 // 2
 publisher
 .append(2, 3)
 .append(4)
 .sink(receiveValue: { print($0) })
 
 
 let publisher = PassthroughSubject<Int, Never>()
 publisher
 .append(3, 4)
 .append(5)
 .sink(receiveValue: { print($0) })
 
 // 2
 publisher.send(1)
 publisher.send(2)
 publisher.send(completion:.finished)
 
 
 let publisher1 = [1, 2].publisher
 let publisher2 = [3, 4].publisher
 // 2
 publisher1
 .append(publisher2)
 .sink(receiveValue: { print($0) })
 
 
 let publisher1 = PassthroughSubject<Int, Never>()
 let publisher2 = PassthroughSubject<Int, Never>()
 let publisher3 = PassthroughSubject<Int, Never>()
 
 
 // 2
 let publishers = PassthroughSubject<PassthroughSubject<Int,
 Never>, Never>()
 
 
 
 publishers .switchToLatest()
 .sink(receiveCompletion: {
 _ in print("Completed!")
 
 },
 receiveValue: { print($0) })
 publishers.send(publisher1)
 publisher1.send(1)
 publisher1.send(2)
 // 5
 publishers.send(publisher2)
 publisher1.send(3)
 publisher2.send(4)
 publisher2.send(5)
 // 6
 publishers.send(publisher3)
 publisher2.send(6)
 publisher3.send(7)
 publisher3.send(8)
 publisher3.send(9)
 // 7
 publisher3.send(completion:.finished)
 publishers.send(completion:.finished)
 
 
 
 // 1
 let publisher1 = PassthroughSubject<Int, Never>()
 let publisher2 = PassthroughSubject<Int, Never>()
 // 2
 publisher1
 .merge(with: publisher2)
 .sink(receiveCompletion: { _ in print("Completed") },
 receiveValue: { print($0) })
 // 3
 publisher1.send(1)
 publisher1.send(2)
 publisher2.send(3)
 publisher1.send(4)
 publisher2.send(5)
 // 4
 publisher1.send(completion: .finished)
 publisher2.send(completion: .finished)
 
 // 1
 let publisher1 = PassthroughSubject<Int, Never>()
 let publisher2 = PassthroughSubject<String, Never>()
 // 2
 publisher1
 .combineLatest(publisher2)
 .sink(receiveCompletion: { _ in print("Completed") },
 receiveValue: { print("P1: \($0), P2: \($1)") })
 // 3
 
 // 3
 publisher1.send(1)
 publisher1.send(2)
 publisher2.send("a")
 publisher2.send("b")
 publisher1.send(3)
 publisher2.send("c")
 // 4
 publisher1.send(completion: .finished)
 publisher2.send(completion: .finished)
 
 
 // 4
 publisher1.send(completion: .finished)
 publisher2.send(completion: .finished)
 ///You might notice that the 1 emitted from publisher1 is never pushed through combineLatest. That’s because combineLatest only combines once every publisher emits at least one element. Here, that condition is true only after "a" emits, at which point the latest emitted value from publisher1 is 2. That’s why the first emission is (2, "a").
 
 
 let publisher1 = PassthroughSubject<Int, Never>()
 let publisher2 = PassthroughSubject<String, Never>()
 // 2
 publisher1 .zip(publisher2)
 .sink(receiveCompletion: { _ in print("Completed") },
 receiveValue: { print("P1: \($0), P2: \($1)") })
 
 publisher1.send(1)
 publisher1.send(2)
 publisher2.send("a")
 publisher2.send("b")
 publisher1.send(3)
 publisher2.send("c")
 publisher2.send("d")
 // 4
 publisher1.send(completion: .finished)
 publisher2.send(completion: .finished)
 
 // 1
 
 
 // 1
 let publisher = [1, -50, 246, 0].publisher
 // 2
 publisher
 .print("publisher")
 .min()
 .sink(receiveValue: { print("Lowest value is \($0)") })
 
 
 let publisher = ["A", "F", "Z", "E"].publisher
 // 2
 publisher
 .print("publisher")
 .max()
 .sink(receiveValue: { print("Highest value is \($0)") })
 
 
 let publisher = ["A", "B", "C"].publisher
 // 2
 //publisher
 .print("publisher")
 .first()
 .sink(receiveValue: { print("First value is \($0)") })
 
 
 // 1
 let publisher = ["J", "O", "H", "N"].publisher
 // 2
 //publisher
 //.print("publisher")
 .first(where: { "Hello World".contains($0) })
 .sink(receiveValue: { print("First matching value is \($0)")
 })
 
 let publisher = ["A", "B", "C"].publisher
 // 2
 publisher
 .output(at: 4)
 .sink(receiveValue: { print("Value at index 1 is \($0)") })
 
 
 // 1
 let publisher = ["A", "B", "C", "D", "E"].publisher
 // 2
 publisher
 .output(in: 1...3) .sink(receiveCompletion: { print($0) },
 receiveValue: { print("Value in range: \($0)") })
 
 
 
 let publisher = ["A", "B", "C"].publisher
 // 2
 publisher
 .print("publisher")
 .count()
 .sink(receiveValue: { print("I have \($0) items") })
 
 let letter = "D"
 let publisher = ["A", "B", "C", "D", "E"].publisher
 
 // 2
 //publisher
 //.print("publisher")
 .contains(letter)
 .sink(receiveValue: { contains in
 // 3
 print(contains ? "Publisher emitted \(letter)!"
 : "Publisher never emitted \(letter)!")
 })
 
 
 let publisher = [2,4,6].publisher
 // 2
 publisher
 .print("publisher")
 .allSatisfy { $0 % 2 == 0 }
 .sink(receiveValue:
 { allEven in
 print(allEven ? "All numbers are even" : "Something is odd...")
 })
 
 let publisher = ["Hel", "lo", " ", "Wor", "ld", "!"].publisher
 publisher
 .print("publisher")
 .reduce("xxx") { accumulator, value in
 // 2
 accumulator + value
 }
 .sink(receiveValue: { print("Reduced into: \($0)") })
 */

//
//var error501 = (errorCode: 501, description: "Not Implemented")
//print(error501.0)
//func dispaly(name:String, chircut lastName:String) {
//    print(name)
//}
//var (a, b, c) = (1, 2, 3)
//dispaly(name: "adasd", chircut:"abdajkdbasbdkjabsda")

//extension Int {
//    func add () -> {
//        return "Hello"
//    }
//}
//
//1.add()

//protocol base {
//    func askdkas()
//}
//
//extension base {
//    func askdkas() {
//        print("protocol")
//    }
//}
//
//class  derived: base {
//    func askdkas() {
//        print("derived")
//    }
//}
//
//let dks:base = derived()
//
//func someFunctionThatTakesAClosure(closure: () -> Void) {
//    // function body goes here
//}

//dks.askdkas()

func someSimpleFunction(closure:(String)->(Int)) {
    print("Function Called")
    closure("adasdas")
    
}

//someSimpleFunction(someClosure: {_ in
//    return 100
//})
//
//func addd(clusr:ada){
//
//    print(clusr)
//}
//
//addd(clusr: someSimpleFunction)
//

//Closure Expression Syntax
//Closure expression syntax has the following general form:
//
//{ (parameters) -> return type in
//    statements
//}


//let simpleClosure:(String) -> (String) = { name in
//
//    let greeting = "Hello, World! " + "Program"
//    return greeting
//}
//
////let result = simpleClosure("Hello, World")
////print(result)
//
//
//func jjjj(clouser:(String)->String) ->String {
//    return clouser("alsdlamsldlasdl")
//    //print(ajhd)
//}
//
//let result = jjjj(clouser: simpleClosure)
//print(result)
//


//
//func postJSONResponse(path: String, completionHandler:(_ response: String) -> String) {
//
//    completionHandler("ldkasndkansdknaksd")
//}
//
//postJSONResponse(path: "adasda") { (value) in
//   return "asdasda"
//}
//

//Publishing network data to multiple subscribers
/*
 let url = URL(string: "https://www.raywenderlich.com")!
 let publisher = URLSession.shared.dataTaskPublisher(for: url)
 .map(\.data)
 .multicast { PassthroughSubject<Data, URLError>() }
 
 // 2
 let subscription1 = publisher .sink(receiveCompletion: { completion in
 if case .failure(let err) = completion {
 print("Sink1 Retrieving data failed with error \(err)")
 }
 }, receiveValue: { object in
 print("Sink1 Retrieved object \(object)")
 })
 // 3
 let subscription2 = publisher .sink(receiveCompletion: { completion in
 if case .failure(let err) = completion {
 print("Sink2 Retrieving data failed with error \(err)")
 }
 }, receiveValue: { object in
 print("Sink2 Retrieved object \(object)")
 })
 
 let subscription = publisher.connect()
 */


//let runLoop = RunLoop.main
////runLoop.schedule(after: .init(Date(timeIntervalSinceNow: 3.0)))
//let subscription = runLoop.schedule( after: runLoop.now,
//interval: .seconds(1),
//tolerance: .milliseconds(100)
//){
//  print("Timer fired")
//}

//let publisher = Timer.publish(every: 1.0, on: .main, in: .common)
/*
 Note: Running this code on a Dispatch queue other than DispatchQueue.main may lead to unpredictable results. The Dispatch framework manages its threads without using run loops. Since a run loop requires one of its run methods to be called to process events, you would never see the timer fire on any queue other than the main one. Stay safe and target RunLoop.main for your Timers.
 */
// let publisher = Timer.publish(every: 1.0, on: .main, in: .common)
//    .autoconnect()
//    .scan(0) { counter, _ in counter + 1 }
//    .sink { counter in
//     print("Counter is \(counter)")
//   }

/*
 let queue = DispatchQueue.main // 1
 let source = PassthroughSubject<Int, Never>()
 var counter = 0
 
 let cancellable = queue.schedule( after: queue.now, interval: .seconds(1)) {
 print("Timer emitteddadasd")
 source.send(counter)
 counter += 1
 }
 
 let subscription = source.sink {
 print("Timer emitted \($0)")
 }
 
 
 
 let queue = OperationQueue()
 queue.publisher(for: \.operationCount)
 .sink { (value) in
 print("Outstanding operations in queue: \(value)")
 }
 
 queue.addOperation {
 print("Outstanding operations")
 }
 
 
 ///Using dynamic tells Swift to always refer to Objective-C dynamic dispatch. This is required for things like Key-Value Observing to work correctly. When the Swift function is called, it refers to the Objective-C runtime to dynamically dispatch the call.
 
 class TestObject: NSObject {
 // 2
 @objc dynamic var integerProperty: Int = 0
 @objc dynamic var stringProperty: String = ""
 @objc dynamic var arrayProperty: [Float] = []
 
 }
 let obj = TestObject()
 // 3
 let subscription = obj.publisher(for: \.integerProperty) .sink {
 print("integerProperty changes to \($0)")
 }
 // 4
 obj.integerProperty = 100
 obj.integerProperty = 200
 
 let subscription2 = obj.publisher(for: \.stringProperty)
 .sink {
 print("stringProperty changes to \($0)")
 }
 
 
 
 let subscription3 = obj.publisher(for: \.arrayProperty)
 .sink {
 print("arrayProperty changes to \($0)")
 }
 
 
 obj.stringProperty = "Hello"
 obj.arrayProperty = [1.0]
 obj.stringProperty = "World"
 obj.arrayProperty = [1.0, 2.0]
 
 */
// struct PureSwift {
//  let a: (Int, Bool)
//}
//
//dynamic var structProperty: PureSwift = .init(a: (0,false))
/*
 class MyClass {
 var anInt: Int = 0 {
 didSet {
 print("anInt was set to: \(anInt)", terminator: "; ")
 }
 }
 }
 
 var myObject = MyClass()
 let myRange = (0...2)
 cancellable = myRange.publisher
 .assign(to: \.anInt, on: myObject)
 
 class MonitorObject: ObservableObject {
 @Published var someProperty = false
 @Published var someOtherProperty = ""
 }
 
 let object = MonitorObject()
 let subscription = object.objectWillChange
 .sink {
 print("object will change")
 }
 object.someProperty = true
 object.someOtherProperty = "Hello world"
 
 
 let shared = URLSession.shared
 .dataTaskPublisher(for: URL(string: "https://www.raywenderlich.com")!)
 .map(\.data)
 .print("shared")
 .multicast(subject: <#_#>)
 
 print("subscribing first")
 
 let subscription1 = shared
 .sink( receiveCompletion: { _ in },
 receiveValue: {
 print("subscription1 received: '\($0)'")
 })
 
 DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
 print("subscribing second")
 let subscription2 = shared.sink(
 receiveCompletion: { print("subscription2 completion \($0)")
 },
 receiveValue: { print("subscription2 received: '\($0)'") }
 ) }
 
 */

//// 1
//let subject = PassthroughSubject<Data, URLError>() // 2
//// 2
//let multicasted = URLSession.shared .dataTaskPublisher(for: URL(string: "https://www.raywenderlich.com")!)
//    .map(\.data)
//    .print("shared")
//    .multicast(subject: subject)
//// 3
//let subscription1 = multicasted .sink(
//receiveCompletion: { _ in },
//    receiveValue: { print("subscription1 received: '\($0)'") }
//  )
//
//
//let subscription2 = multicasted .sink(
//receiveCompletion: { _ in },
//    receiveValue: { print("subscription2 received: '\($0)'") }
//  )
//multicasted.connect()
//subject.send(Data())
//
//
//
//
//
//
//
//
//
//
//let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
//let posts = URLSession.shared.dataTaskPublisher(for: url)
//    .map { $0.data }
//    //.decode(type: [Post].self, decoder: JSONDecoder())
//    //.replaceError(with: [])
//    .print()
//    .share()
//posts
//    .sink(receiveValue: {
//        print("subscription1 value: \($0)") })
//
//posts
//    .sink(receiveValue: {
//        print("subscription2 value: \($0)") })
//
//
/*
 let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
 let postsSubject = PassThroughSubject<[Post], Never>()
 let posts = URLSession.shared.dataTaskPublisher(for: url)
 .map { $0.data }
 .decode(type: [Post].self, decoder: JSONDecoder())
 .replaceError(with: [])
 .print()
 .multicast(subject: postsSubject)
 posts
 .sink(receiveValue: {
 print("subscription1 value: \($0)") })
 
 DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
 posts
 .sink(receiveValue: { print("subscription2 value: \($0)") })
 
 }
 posts
 .connect()
 */

//Remove the `postsSubject` property and replace the `multicast(subject:)` operator by `makeConnectable()`
//let notificationName = Notification.Name(rawValue: "NotificationName")
/*
 let centerd = NotificationCenter.default.publisher(for: notificationName)
 .sink(receiveCompletion: { (completion) in
 print(completion)
 }) { (value) in
 print(value.name)
 }
 
 let center = NotificationCenter.default
 center.post(name: notificationName, object: nil)
 */

///custom  subscriber

/*
 let publisherww = (1...6).publisher
 final class CSubscriber: Subscriber {
 
 
 func receive(subscription: Subscription) {
 subscription.request(.max(3))
 }
 
 func receive(_ input: Int) -> Subscribers.Demand {
 print("Received value", input)
 return Subscribers.Demand.none
 }
 
 func receive(completion: Subscribers.Completion<Never>) {
 print("Completion")
 }
 
 typealias Input = Int
 typealias Failure = Never
 
 }
 
 let subs = CSubscriber()
 publisherww.subscribe(subs)
 */

//let publisher = Future<String, Never> { (promise) in
//    return  promise(.success("sanjay"))
//}
//
//
//publisher.sink { (value) in
//    print(value)
//}

///Subject
/*
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

let subscribe = StringSubscriber()

//Create the  subject
let subject = PassthroughSubject<String, MyError>()
subject.subscribe(subscribe)

let subscription = subject .sink(
    receiveCompletion: { completion in
      print("Received completion (sink)", completion)
    },
    receiveValue: { value in
      print("Received value (sink)", value)
    }
)


subject.send("SANJAY")
subject.send(completion: .failure(.test))
*/

//enum MyError: Error {
//    case test
//}
//let numbers = [1,2,3,4,5,6].publisher
//    .tryMap {
//        throw MyError.test
//
//}
//
//
//let subscription = numbers .sink(
//    receiveCompletion: { completion in
//      print("Received completion (sink)", completion)
//    },
//    receiveValue: { value in
//      print("Received value=>", value)
//    }
//)

//enum ServiceError: Error {
//    case url(URLError?)
//    case decode
//    case unknown(Error)
//}
//
//struct Item: Codable {
//    let id: Int
//    let title: String
//    let completed: Bool
//}
//
//let url = URL.init(string: "https://jsonplaceholder.typicode.com/todos/1")
//let dataPublisher = URLSession.shared.dataTaskPublisher(for: url!)
//                   //.print("Publisher")
//
//                     .map { $0.data }
//                     .decode(type: Item.self, decoder: JSONDecoder())
//                     .mapError { error -> ServiceError in
//                         switch error {
//                         case is DecodingError: return ServiceError.decode
//                         case is URLError: return ServiceError.url(error as? URLError)
//                         default: return ServiceError.unknown(error)
//                        }
//                      }
//                    .retry(10)
//
//
//
//
////.receive(on: RunLoop.main)
//.sink(receiveCompletion: { completion in
//    switch completion {
//    case .finished: print("🏁 finished")
//    case .failure(let error): print("❗️ failure: \(error)")
//    }
//}, receiveValue: { value in
//    print("✅ value: \(value)")
//})

//struct ParseError: Error {}
//func romanNumeral(from:Int) throws -> String {
//    let romanNumeralDict: [Int : String] =
//        [1:"I", 2:"II", 3:"III", 4:"IV", 5:"V"]
//
//    guard let numeral = romanNumeralDict[from] else {
//        throw ParseError()
//    }
//    return numeral
//}
//let numbers = [5, 4, 3, 2, 1, 0]
//  numbers.publisher
//    .tryMap {  do {
//              try romanNumeral(from: $0)
//        }
//
//  }
//    .sink(
//        receiveCompletion: { print ("completion: \($0)") },
//        receiveValue: { print ("\($0)", terminator: " ") }
//     )
//


 class MonitorObject: ObservableObject {
   @Published var someProperty = false
   @Published var someOtherProperty = ""
 }
MonitorObject().objectWillChange.sink(receiveValue: <#T##((Void) -> Void)##((Void) -> Void)##(Void) -> Void#>)

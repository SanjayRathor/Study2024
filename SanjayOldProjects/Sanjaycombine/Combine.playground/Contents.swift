import Combine
import SwiftUI
import PlaygroundSupport

/*
 enum ExampleFailure: Error {
 case oneCase
 }
 
 let resolvedFailureAsPublisher = Future<Bool, Error> {
 promise in
 promise(.failure(ExampleFailure.oneCase))
 }.eraseToAnyPublisher()
 
 let abd = Just.init("Sanajy")
 .receive(on: RunLoop.main)
 .map { _ in
 return "jasdbbasdba"
 }
 .sink { (value) in
 print(value)
 }
 
 let resolvedSuccessAsPublisher = Future<Bool, Error> { promise in
 promise(.success(true))
 
 }.eraseToAnyPublisher()
 
 
 
 let publisher = (1...6).publisher
 // 2
 final class IntSubscriber: Subscriber {
 // 3
 typealias Input = Int
 typealias Failure = Never
 // 4
 func receive(subscription: Subscription) {
 subscription.request(.max(3)) }
 // 5
 func receive(_ input: Int) -> Subscribers.Demand {
 print("Received value", input)
 return .none
 
 }
 // 6
 func receive(completion: Subscribers.Completion<Never>) {
 print("Received completion", completion)
 }
 }
 
 let subscriber = IntSubscriber()
 publisher.subscribe(subscriber)
 
 func futureIncrement( integer: Int, afterDelay delay: TimeInterval) -> Future<Int, Never> {
 
 Future<Int, Never> { promise in
 DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
 promise(.success(integer + 1))
 
 }
 }
 }
 
 // 1
 let future = futureIncrement(integer: 1, afterDelay: 3)
 // 2
 future.sink(receiveCompletion: {
 print($0)
 
 },
 receiveValue: { print($0) })
 
 
 //let subject =  Just("alksdjklsalkd kad kaksdkadkakdbka")
 //let subject =  PassthroughSubject<String, Never>()
 let subject =   CurrentValueSubject<String, Never>("bbbbbbbbbbbbbbbbbbbb")
 let subsribe = subject
 .sink { (value) in
 print(value)
 }
 
 subject.send("lkadsknk ADkadk kd akdkjadj")
 
 let _publisher = Just("Indian hindi movie")
 _publisher.subscribe(subject)
 
 
 
 
 
 enum Errors:Error {
 case funcyError
 }
 
 
 let subject = Future<String, Errors> { promise in
 // promise(.failure(.funcyError))
 promise(.success("aldladlnalnadaksdnaksd kasd kakdj bajbd jabda dbjkabdk akdkad"))
 
 }
 
 let subsribe = subject
 .receive(on: DispatchQueue.main) // Move to the main thread
 .sink(receiveCompletion: { completion in
 switch completion {
 case .failure(let error): (print(error))
 case .finished: (print(completion) )
 }
 }, receiveValue: { _ in })
 
 
 func createFuture() -> Future<Int, Never> {
 return Future { promise in
 promise(.success(42))
 }
 }
 
 createFuture().sink(receiveValue: { value in
 print(value)
 })
 let future = Future<Int, Never> { promise in
 promise(.success(1))
 }
 
 future.sink(receiveCompletion: { print($0) },
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
 
 let subscription1 = subject .sink(
 receiveCompletion: { completion in
 print("Received completion (sink)", completion)
 },
 receiveValue: { value in
 print("Received value (sink)", value)
 }
 )
 //subject.send("Hello")
 //subject.send("World")
 
 subscription1.cancel()
 
 subject.send("Helloaddada")
 
 subject.send(completion: .failure(MyError.test))
 subject.send(completion: .finished)
 subject.send("How about another one?")
 */

final class IntSubscriber: Subscriber {
    
    typealias Input = Int
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
        subscription.request(.max(2))
    }
    
    func receive(_ input: Int) -> Subscribers.Demand {
        print("Received value", input)
        
        switch input {
        case 1:
            return .max(2) // 1 case 3:
            return .max(1) // 2 default:
            return .none // 3 }
        default:
            return .none
        }
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        print("Received completion", completion)
    }
}
let subscriber = IntSubscriber()
let subject = PassthroughSubject<Int, Never>()
subject.subscribe(subscriber)

//
//let subscription1 = subject .sink(
//    receiveCompletion: { completion in
//        print("Received completion (sink)", completion)
//},
//    receiveValue: { value in
//        print("Received value (sink)", value)
//}
//)


//subject.send(1)
//subject.send(2)
//subject.send(3)
//subject.send(4)
//subject.send(5)
//subject.send(6)


/*
 ["A", "B", "C", "D", "E"].publisher
 .collect(2)
 .sink(receiveCompletion: { print($0) },
 receiveValue: { print($0) }
 )
 
 
 let formatter = NumberFormatter()
 formatter.numberStyle = .spellOut
 // 2
 [123, 4, 56].publisher // 3
 .map {
 formatter.string(for: NSNumber(integerLiteral: $0)) ?? "" }
 .sink(receiveValue:
 {
 print($0) }
 )
 
 
 Just("Directory name that does not exist")
 .tryMap {
 try FileManager.default.contentsOfDirectory(atPath: $0)
 }
 .sink(receiveCompletion: {
 print("prijnt------", $0)
 },
 receiveValue: {
 print("11111111111------",$0) }
 )*/

public struct Chatter {
    public let name: String
    public let message: CurrentValueSubject<String, Never>
    
    public init(name: String, message: String) {
        self.name = name
        self.message = CurrentValueSubject(message)
    }
}

 let charlotte = Chatter(name: "Charlotte", message: "Hi, I'm Charlotte!")
 let james = Chatter(name: "James", message: "Hi, I'm James!")

 let chatSubject = CurrentValueSubject<Chatter, Never>(charlotte)

  chatSubject
    .flatMap { $0.message }
    .sink(receiveValue: { print($0) })

  // 4
  charlotte.message.value = "Charlotte: How's it going?"

  // 5
  chatSubject.value = james

 // james.message.value = "James: Doing great. You?"
  //charlotte.message.value = "Charlotte: I'm doing fine thanks."

  // 8
  //let morgan = Chatter(name: "Morgan",
    //                   message: "Hey guys, what are you up to?")
  
  // 9
  //chat.value = morgan

  // 10
  //charlotte.message.value = "Did you hear something?"

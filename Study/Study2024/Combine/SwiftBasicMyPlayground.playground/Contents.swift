import UIKit
import Combine
/*
 @propertyWrapper
 struct BasicWrapper {
 var string: String
 init(wrappedValue: String) {
 self.string = wrappedValue
 }
 var wrappedValue: String {
 get {
 string.trimmingCharacters(in: .whitespacesAndNewlines) + "sdfsdfsdf"
 }
 set(newValue) {
 string = newValue
 }
 }
 }
 
 class DemoStruct {
 @BasicWrapper var value = "demo => "
 func dis() {
 print(value)
 }
 
 func say(@BasicWrapper what: String) { print(what)
 }
 
 }
 
 let adn = DemoStruct()
 
 adn.dis()
 */

//func fetchURL(_ url: URL) -> AnyPublisher<[MyDataClass], Error> {
//    URLSession.shared.dataTaskPublisher(for: url)
//        .map(\.data)
//        .decode(type: MyDataClass.self, decoder: JSONDecoder())
//        .eraseToAnyPublisher()
//}


func getData() {
//    guard let url = URL(string: "http://md5.jsontest.com/?text=example_text") else { return }
//    fetchURL(url)
//        .sink { completion in
//            
//        } receiveValue: { models in
//            
//        }
}





//[2, 3, 4, 5, 6].publisher
//    .map({$0 * 2})
//    .switchToLatest()
//.sink(receiveCompletion: {
//    print($0)
//},
//receiveValue: {
//   print($0) }
//)
//
//

enum SimpleError: Error { case error }
var numbers = [5, 4, 3, 2, 1, -1, 7, 8, 9, 10]
var cancellable = Set<AnyCancellable>()

 numbers.publisher
   .tryMap { v in
        if v > 0 {
            return v
        } else {
            throw SimpleError.error
        }
}
   .sink(receiveCompletion: { a in
       print ("Completion: \(a).")
   }, receiveValue: { a in
       print(a)
   })

//  .tryCatch { error in
//      throw SimpleError.error
//      //Just(0)
//      // Send a final value before completing normally.
//      // Alternatively, throw a new error to terminate the stream.
//}
//  .sink(receiveCompletion: {
//
//      print ("Completion: \($0).")
//
//  }, receiveValue: {
//      print ("Received \($0).")
//  })

  
enum MyError: Error {
    case ohNo
}

extension MyError {
    public static func ~= (lhs: Self, rhs: Error) -> Bool {
        guard let selfError = rhs as? Self else { return false }
        return selfError == lhs
    }
}

var subscriptions = Set<AnyCancellable>()

/*
 func doAn()->AnyPublisher<String, MyError> {
    Just("Hello")
        .mapError(to: MyError.self)
        .tryMap({ value in
            throw MyError.ohNo
        })
        .eraseToAnyPublisher()
}

Just("Hello")
    .setFailureType(to: MyError.self)
    .tryMap({ _ in  
        throw MyError.ohNo
    })
    .sink(
      receiveCompletion: { completion in
        switch completion {
        case .failure(_):
          print("Finished with Oh No!")
        case .finished:
          print("Finished successfully!")
        }
      },
      receiveValue: { value in
        print("Got value: \(value)")
      }
    )
    .store(in: &subscriptions)


*/

//struct CallableExample {
//func greetings(name: String) {
//        print("Hello!",name)
//    }
//}
//
//let greeting = CallableExample()
//greeting.greetings(name: "Hello")

//@dynamicCallable
//struct CallableExample {
//    func dynamicallyCall(withKeywordArguments args: KeyValuePairs<String, String>) {
//        for (_, value) in args {
//            print("Hello!",value)
//        }
//    }
//}
//
//
//let greeting = CallableExample()
//
//greeting(someValue: "How are you?")    // output- "Hello!How are you?"
//greeting(someValue: "I am fine")    // output- "Hello!I am fine"


@dynamicMemberLookup
struct Person {
    subscript(dynamicMember member: String) -> String {
        let properties = ["name": "Taylor Swift", "city": "Nashville"]
        return properties[member, default: ""]
    }
}

let taylor = Person()
print(taylor.name)
print(taylor.city)
print(taylor.favoriteIceCream)

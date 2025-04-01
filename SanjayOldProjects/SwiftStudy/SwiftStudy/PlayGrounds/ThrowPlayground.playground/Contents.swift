//: Playground - noun: a place where people can play

import UIKit

enum PasswordError: Error {
    case Empty
    case Short
    case Obvious
}

/*func functionA() {
    do {
        try functionB()
    } catch {
        print("Error!")
    }
}

func functionB() throws {
   try functionC()
}

func functionC() throws {
    throw PasswordError.Short
}

functionA()*/

enum Failure: Error
{
    case BadNetwork(message: String)
    case Broken
}

let loacal:()->String = { ()->String in
    return("jdbs sjdjsdfksdjk")
}

func fetchRemote() throws -> String {
    throw Failure.BadNetwork(message: "Firewall blocked port.")
}

func fetchLocal() -> String {
    return "Taylor"
}

//func fetchUserData(closure:() throws -> String) {
//    
//    do {
//        let userData = try closure()
//        print("User data received: \(userData)")
//    } catch Failure.BadNetwork(let message) {
//        print(message)
//    } catch {
//        print("Fetch error")
//    }
//}

func fetchUserData(closure: () throws -> String) rethrows {
    let userData = try closure()
    print("User data received: \(userData)")
}

//now only requires try/catch to be used when the closure you pass in throws. So, when you use fetchUserData(fetchLocal) the compiler can see try/catch isn't necessary, but when you use fetchUserData(fetchRemote) Swift will ensure you catch errors correctly.

do {
    try fetchUserData(closure: fetchLocal)
} catch Failure.BadNetwork(let message) {
    print(message)

} catch {
    print("Fetch error")
}


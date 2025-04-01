//: Playground - noun: a place where people can play

import UIKit

//1- @escaping, @noEscaping
//2- Function passing
//3- Simple creation 
//Returning some values 

typealias completionBlock = (Int, Int) -> Int

//Simple diclartion  of closure
//var multiplyClosure: (Int, Int) -> Int
//multiplyClosure = { (a: Int, b: Int) -> Int in
//    return a * b
//}
//print(multiplyClosure(48,48))

/*
//Passing closure to function as a argument
func operationOnNumbers(num1:Int, num2:Int, operation:completionBlock) ->Int {
    return operation(num1, num2)
}
print(operationOnNumbers(num1: 10,num2: 10, operation: multiplyClosure))
*/

//Inline Diclartion of clouser
func operateOnNumbers(a: Int,  b: Int,
                      operation: (Int, Int) -> Int) -> Void {
  operation(a, b)
}

operateOnNumbers(a:4, b:2, operation: { (a: Int, b: Int) -> Int in
    
    print("dddsd")
    return a + b
})

func performNetworkRequest(url:String, clouser: (Bool)->Void)->Void {
    clouser(true)
}

performNetworkRequest(url:"Sanjay", clouser:{(status:Bool)  in
    print(status)
})

func sayHello(to person:String, closure: (String) -> Void) {
    closure(person)
}

sayHello(to: "Wilson", closure: { (person: String) -> Void in
    print("Hello " + person) // outputs Hello Wilson
})

let  emptyClouser = {
    print("Empty")
}

func display (name:String, clouser:()->Void ) {
    clouser()
}
display(name:"SSSS", clouser: emptyClouser)




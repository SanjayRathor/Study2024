//: Playground - noun: a place where people can play

import UIKit

//var items:[String?] = ["sds"]
//var jedd = items[0...3]
//

//var dictonaytrings:Dictionary< String : String> = ["name":"sanjay", "class":"mca", "pin":"226005"]
//
//print(dictonaytrings)
//
//for (keye,values) in dictonaytrings {
//    print(keye)
//}

//var arrayOfIntsAsStrings:[String] = ["103", "2", "1", "50", "55", "98"]
////  When it comes to removing items, there are two interesting ways of removing the last item: removeLast() and popLast(). They both remove the final item in an array and return it to you, but popLast() is optional whereas removeLast() is not. Think that through for a moment: dogs.removeLast() must return an instance of the Dog struct. What happens if the array is empty? Well, the answer is "bad things" – your app will crash.
//
//
//print(arrayOfIntsAsStrings.removeLast())
//print(arrayOfIntsAsStrings)
//print(arrayOfIntsAsStrings.popLast())
//print(arrayOfIntsAsStrings)

//let integre:String? = "100"
//let integre3:String? = "100"

//struct Place {
//    let name: String
//    let rollNumber: Int
//}
//let place1 = Place(name: "z", rollNumber: 100)
//let place2 = Place(name: "a", rollNumber: 140)
//let place3 = Place(name: "c", rollNumber: 150)
//let place4 = Place(name: "b", rollNumber: 120)
//let place5 = Place(name: "a", rollNumber: 123)
//
//extension Place:Equatable {
//    
//}
//
//func == (lhs: Place, rhs: Place) -> Bool {
//    return (lhs.name == rhs.name && lhs.rollNumber == rhs.rollNumber)
//}
//
//let array = [place1, place2, place3, place4, place5]
//let sorted  = array.sorted { (first:Place, second:Place) -> Bool in
//    return first.rollNumber < second.rollNumber
//}
//print(sorted)
//
//

//== sign always unwraps optional where as >= < need to unwrap
//if integre == integre3 {
//    print("DONE")
//}
//let arrayOfIntsAsStrings:[String?] = ["x", "a", "z", "b", "c", "d", nil]
//let sorted = arrayOfIntsAsStrings .sorted { (first:String?, second:String?) -> Bool in
//    
//    return first?.compare(second!) == ComparisonResult.orderedDescending
//    
//    //return first < second
//}
//print(sorted)

//let arrayOfIntsAsStrings:[String] = ["103", "2", "1", "50", "55", "98"]
//
//for user in arrayOfIntsAsStrings {
//    print(user)
//}
//
//let sorted = arrayOfIntsAsStrings .sorted { (first:String, second:String) -> Bool in
//     //return first.compare(second) == ComparisonResult.orderedDescending
//    
//    return Int(first)! < Int(second)!
//}
//
//print(sorted)

//let numbers = [5, 3, 1, 9, 5, 2, 7, 8]
////let sorted = numbers.sorted()
//let sorted = numbers.sorted { (first, second) -> Bool in
//    
//    if first = second == ComparisonResult.orderedAscending {
//        return false
//    }
//    return true
//}

//let sorted = numbers.sorted {
//    if $0 >= $1 {
//        return false
//    }
//    return true
//}
//print(sorted)
//var myArray:[String] = [String](repeating: "My String", count: 10)
//for name in myArray {
// print(myArray)
//}

//myArray += ["Raj"]
//for user in myArray {
//    print(user)
//}
//print(myArray)

//
//print(nameArray .count)

//let tuple1:(String?, String?) = (name:"sanjay", password:"226003")
//let tuple2:(String?, String?) = (name:"sanjay1", password:"226004")
//let tuple3:(String?, String?) = (name:"sanjay2", password:"226005")
//
//let attay = [tuple1, tuple2, tuple3]
//for case ("sanjay"?, let password?) in attay {
//    print(password)
//}

//let myarray:[String?] = ["Sanjay", "Sanjay1", "Sanjay2", "Sanjay3", "Sanjay4", "Sanjay5", "Sanjay6", nil]
//for case let names? in myarray {
//    print(names)
//}
//
//for  case ("sanjay")? in myarray {
//    print("domne")
//}
//for case let names? in myarray where names == "Sanjay3"{
//    print(names)
//}


//let someInteger:Int? = 42
//if case 0...100 = someInteger {
//    print ("matched")
//}
//if let c = someInteger , (0...100) ~= (someInteger!){
//    print ("matchede")
//}

//if case let value? = someInteger {
//    print (value)
//}

//There should be always a initialier variable for pattern matching
//let someInteger:Int = 42
//if case let someIntegere = someInteger , (0...100).contains(someIntegere) {
//  print("this is a valid number of favorited Taylor Swift Songs")
//}

//In Switch /Simple/For Loops/Options/Non Optionals
/*
 let address = (name:"sanjay", street:"L4", pin:"201301")
 switch address {
 case ("sanjay", "L4", "201301"):
 print(" all matched")
 case ("sanjay", "L4", "201301"):
 print(" 2 matched")
 
 default:
 print("did not match")
 }*/
/*
 let address :(String?, String?, String?) = (name:"sanjay", street:"L4", pin:"201301")
 switch address {
 case ("sanjay"?, "L4"?, "201301"?):
 print(" all matched")
 
 default:
 print("did not match")
 }*/

/*
 let address :(String?, String?, String?) = (name:"sanjay", street:"L4", pin:"2013014")
 switch address {
 case (_, _, let pincode?) where pincode == "2013014":
 print(pincode)
 
 default:
 print("did not match")
 }*/

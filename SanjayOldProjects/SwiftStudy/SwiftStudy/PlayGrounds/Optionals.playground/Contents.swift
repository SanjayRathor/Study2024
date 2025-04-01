//: Playground - noun: a place where people can play

import UIKit

var array:[String?] = ["sanjay", "manoj", nil, "suresh", nil]



for switchname in array {
    
    switch switchname {
    case let name? :
        print("name is \(name)")
    default:
        print("Nothing")
    }
}

for username in array where username != nil {
    print(username!)
}

for case let user? in array {
    print(user)
}


//var errorCodeString:String? = "404"

//var errorCodeString: String?
//errorCodeString = "404"
//if let theError = errorCodeString, let errorCodeInteger = Int(theError), errorCodeInteger == errorCodeStringe
//{
//        print("\(theError): \(errorCodeInteger)")
//}

/*
 var str:String? = "sanjay"
var str2:String?
str2?.append("Manoj")
str = "zcscdfs"

if str == str2 {
    print("YES")
}

if  let tempStr = str2, let s = str2 {
    print(tempStr)
}

let ageInteger: Int? = 30
print(ageInteger!+1)
 */


 


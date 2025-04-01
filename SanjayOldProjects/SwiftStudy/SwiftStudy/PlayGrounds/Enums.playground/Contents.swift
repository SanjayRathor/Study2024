//: Playground - noun: a place where people can play

import UIKit

//Simple/pattern matching/function inside it/return enum/getting value/inside switch/enum strings/enum with parameters

enum student:String {
    
    case name = "Sanjay"
    case classname = "Sanjay2"
    case subject = "Sanjay3"

    func history() -> student  {
        return .name
    }
}

let enumObj = student.name
print(enumObj.history().rawValue)


/*
 enum student:String {
    case name = "Sanjay"
    case classname = "Sanjay2"
    case subject = "Sanjay3"
}
func dispayEnum() ->student {
    let studentva = student.name
    return studentva
}
print(dispayEnum().rawValue)
 */

/*
 enum student:String {
    case name = "Sanjay"
    case classname = "Sanjay2"
    case subject = "Sanjay3"
}

let abc = student.name
switch abc {
case .name:
    print(student.name.rawValue)
default:
    print("nothing")
    
}*/

/*
 enum student {
    case name(studentName:String)
    case classname
    case subject
}

let abc = student.name(studentName:"sanjaye")
switch abc {
case .name(let studentNamed) where  studentNamed == "sanjay" :
    print(studentNamed)
case .name(let studentNamed) where  studentNamed == "sanjaye" :
    print(studentNamed)

default:
    print("nothing")
    
}*/

/*enum student {
    case name
    case classname
    case subject
}

let abc = student.name
switch abc {
case .name:
    print("all thing ")
default:
    print("nothing")
}*/


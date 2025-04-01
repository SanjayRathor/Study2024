import UIKit
/*
 class  Person {
 
 var name:String?
 var pincode:String?
 var address:String?
 
 func displayAddress() -> Void {
 print(name! + " " + pincode! + " " + address!)
 }
 
 init(name:String, pincode:String, address:String) {
 self.name = name
 self.pincode = pincode
 self.address = address
 }
 
 convenience init(pincode:String) {
 self.init(name:"aa", pincode:"bbb", address:"ccc")
 self.pincode = pincode
 }
 
 }*/

//1- Property override
//function overloading
//Function ovveriding
//Initialization
//Two phase initialization

class Person {
    
  public var name:String?
    
  internal func displayAddress() -> Void {
        print(name!)
    }
    
//    func displayAddress(address:String) -> Void {
//        print(address)
//    }
    
    init(userName:String) {
        self.name = userName
    }
    
    static func completeAddress()->Void {
        print("here you can print the complete address ")
    }
    
    class func completeClassAddress()->Void {
        print("here you can print the completeClassAddress  address ")
    }
}

class Student : Person {
    
    let pin:String
    init(pin:String) {
        
        self.pin = pin
        super.init(userName: "sanajy")
    }
    override class func completeClassAddress()->Void {
        print("here you can print the completeClassAddress  address Student")
    }
    
//   override func displayAddress() -> Void {
//        print(pin)
//    }
}

print(Student.completeClassAddress())

let users = Student (pin: "226005")
print(users .displayAddress())





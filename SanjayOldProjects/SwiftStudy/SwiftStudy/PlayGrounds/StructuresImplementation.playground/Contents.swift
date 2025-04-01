//: Playground - noun: a place where people can play

import UIKit

struct  User {
    
    var name:String?
    var pincode:String?
    
    func displayAddress() -> Void {
        print(name! + " " + pincode!)
    }
}

let users = User ( name:"Sanjay", pincode:"226005")

//Valid in here not valid in class 

struct Town {
    var population = 5_422
    var numberOfStoplights = 4
    
    mutating func changePopulation(by amount: Int) {
        population += amount
    }

}

struct userInfo {
    
    var userName :String?
    var address:String?
    var pin:String?
    var amount:Int?
    
   // all the strored properties must be initialized. If these are the optiononals then
   // then these are initialize with nil otherwise must be in  the init methods
    init(name:String, addresse:String) {
        self.userName = name
        self.address = addresse
    }
    
    init(name:String, addresse:String, pincode:String) {
        self.userName = name
        self.address = addresse
        self.pin = pincode
        amount=100
    }
    
    
    mutating func calculate(by population:Int) ->Int {
        amount! += population
        return amount!
    }
    
   // Structs can only have designated initializers, structs cannot have convenience initializers.
}

extension userInfo: Equatable {
}

 func ==(lhs: userInfo, rhs: userInfo) -> Bool {
    return lhs.pin == rhs.pin
}

let structObj = userInfo (name:"sanjay", addresse:"L-4", pincode:"226005")
var structObj1 = userInfo (name:"sanjay", addresse:"L-4", pincode:"226005")

if structObj == structObj1 {
   print(structObj1 .calculate(by: 100))
}




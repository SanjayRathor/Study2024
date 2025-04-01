//: Playground - noun: a place where people can play

import UIKit

enum MechineType {
    case MechineTypeAutomatic
    case MechineTypeMannual
}

/*
protocol Vechicle {
    
    var type:String {get}
    func vechileName() -> Void
}

protocol HeavyVechicle:Vechicle {
    func heavyVechicle() -> Void
}
protocol LightVechicle:Vechicle {
    func lightVechicle() -> Void
}


class Scooter:LightVechicle {
    internal func lightVechicle() {
         print("lightVechicle")
    }

    internal var type: String = "SSS"

    internal func vechileName() -> Void {
        print("Scooter")
    }
}

class Bike :LightVechicle {
    internal func lightVechicle() {
         print("lightVechicle")
    }
    internal var type: String = "SSSSSS"
    internal func vechileName() -> Void {
        print("Bike")
    }
    
    func display() -> Void {
        print("display")
    }
    func display(name:String) -> Void {
        print("display")
    }
}

let vechile:LightVechicle = Bike()
vechile.vechileName()
vechile.lightVechicle()
 */

//generic constraints
//protocol Vechicle {
//    
//    associatedtype VechicleType
//    func vechileName() -> VechicleType
//}
//
//class Scooter:Vechicle {
//    
//    typealias VechicleType = String
//    internal func vechileName() -> VechicleType {
//        return("Scooter")
//    }
//}
//
//class Bike :Vechicle {
//    
//    typealias VechicleType = Void
//    internal func vechileName() -> VechicleType {
//        print("Bike")
//    }
//}
//
//let vechile:Vechicle = Bike()
//vechile.vechileName()





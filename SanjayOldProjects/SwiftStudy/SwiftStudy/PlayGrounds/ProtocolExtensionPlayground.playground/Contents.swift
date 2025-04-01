//: Playground - noun: a place where people can play

import UIKit

protocol Vechile {
    func vechileName() -> String
}

extension Vechile where Self: Bike {
    func vechileName() -> String {
        return "Bacse Vechile"
    }
}


class Bike :Vechile {
    
    func vechileName() -> String {
        return "Bike"
    }
}

let vechile:Vechile = Bike()
print(vechile.vechileName())








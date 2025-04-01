//: Playground - noun: a place where people can play

import UIKit

protocol Food {

}
class Grass: Food {
}
protocol Animal {
    associatedtype SuitableFood  // declares some associated type is
    func eat(food: SuitableFood)
}

extension Animal {
    func eat() { print("I only eat \(SuitableFood.self)") }
}

struct Cow { }
extension Cow: Animal {
    
    typealias SuitableFood = Grass // declares that for Cow, that type is
    func eat(food: Grass) {
        print("---I eat only grass")
    }
}


func runBarnyardWithResidentsGenerically<A: Animal>(residents: [A])
{
    for animal in residents {
        animal.eat()
        print("") }
}
runBarnyardWithResidentsGenerically(residents: [Cow()])

//It is a placeholder of abstract type
//You cannot define a variable, constant, property, function argument, or function return type as a PAT type!
//You can only use them as generic constraints.
//It means that you can write a generic type or generic function, where the type parameter is constrained to adopt the PAT.

// let animal:Animal = Cow()


//protocol Animal {
//    associatedtype Food
//    func eat(food: Food)
//}
//
//extension Animal {
//    func eat(food: Food) {
//        print("gandu extension")
//    }
//}
//
//struct Cow: Animal {
//    typealias Food = Int
//    
//    func eat(food: Int) {
//        print("Eating integer")
//    }
//}
//
//struct Chicken: Animal {
//    typealias Food = String
//    func eat(food: String) {
//        print("Eating String")
//    }
//}
//
//let cow:Animal = Cow()
//cow.eat(food:12) //
//
//let chicken = Chicken()
//chicken.eat(food:"Gandu pana ")
//
//


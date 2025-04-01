//: Playground - noun: a place where people can play
/*
 class GameManager {
 // 1
 static let defaultManager = GameManager()
 var gameScore = 0
 var saveState = 0
 // 2
 private init() {}
 }
 */
import UIKit

class Properties {
    
    //stored properties
   private(set) var nameInt :Int?
    init(nameInt:Int) {
        self.nameInt = nameInt
    }
    
    //computed properties
   var emiCalculation:Int {
        return nameInt!*200
    }
    //Read/write property 
    
    var bankCalcultaion:Int {
        
        get {
            return 3000;
        }
        set (newValue){
            self.nameInt = newValue
        }
    }
   //Lazy Properties 
    
   lazy var calculatePIValues:Int = {
        return 2000
    }()

    lazy var calculatePIValuesd:Int = self.displayCalculatePIValues()
        
    func displayCalculatePIValues() -> Int {
        return 4000
    }
    
    
}

let object = Properties(nameInt:2000)
//print(object.emiCalculation)
object.bankCalcultaion = 10
print(object.calculatePIValuesd)






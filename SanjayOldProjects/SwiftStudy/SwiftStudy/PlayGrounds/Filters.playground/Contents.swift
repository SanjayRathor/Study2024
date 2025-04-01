//: Playground - noun: a place where people can play
import UIKit

let scores:[Int] = [1, 2, 3, 4, 5]
let scores1 = ["1", "2", "3", "4", "5"]

let result = scores.reduce(10, + )
print(result)

scores.reduce(10) { $0 + $1}
print(result)

let resulte = zip(scores, scores1)

for user in resulte {
  print(user)
}

//NOTE : THE VALUE 10 TAKEN OUT OF ITS OPTIONAL CONATINER, MULTIPLIED BY 1 AND PLACE BACK INTO OPTIONAL. IF IT HAD BEEN NILL THEN IT RETURNS NILL
//let i:Int? = 10
//let j = i.map { $0*2}
//print(j)

//let arrayOfarray:[String?] = ["14","e","69"]
//print(arrayOfarray)

//If  you  want to perform the conversion then first need to  unraped it
//Falt map return vaue. removes/stripped out  optionality where as map retains it
//let arrayOfarraye = arrayOfarray.flatMap {
//    return $0
//}
//let arrayOfarraye = arrayOfarray.flatMap {
//     Int($0!)
//}
//print(arrayOfarraye)

//Multple operation on array

//let mapArray = [10, 20, 60, 5,]
//let result =  mapArray.map { (element:Int) -> Int in
//    return element*20
//}
//
//print(result)
//func  addvalue(name:Int) -> Int {
//    return name*100
//}
//let mapArray = [10, 20, 60, 5,]
//let result =  mapArray.map { addvalue(name: $0)
//}
//print(result)

//let mapdictonary = ["value1": 10, "value2":20, "value4":60, "value5":5,]
//let result = mapdictonary.map {
//  $1*100
//    
//}
//print(result)


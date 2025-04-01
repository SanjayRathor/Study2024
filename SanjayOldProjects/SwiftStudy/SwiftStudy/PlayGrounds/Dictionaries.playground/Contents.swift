//: Playground - noun: a place where people can play

import UIKit

//var dict1: Dictionary<String, Double> = [:]
//var dict2 = Dictionary<String, Double>(dictionaryLiteral: "da": 2.0)
//var dict3: [String:Double] = [:]
//var dict4 = [String:Double]()

var movieRatings:[String :Int?] = ["Donnie": 4, "Chungking": nil]
//print("I have rated \(movieRatings.count) movies.")

//for case let (kyes, values?) in movieRatings {
//    print(values)
//}
//print(movieRatings.removeValue(forKey: "Donnie"))
//
//movieRatings["Donnie"] = .none
//print(movieRatings)
let watchedMovies = movieRatings.values
print(watchedMovies)
//: Playground - noun: a place where people can play

import UIKit


func display(name:String? = "sanjay") ->Void {
  guard let local = name, local == "sanjay" else {
        return
  }
  print(local)
}



display(name:"sanjay")

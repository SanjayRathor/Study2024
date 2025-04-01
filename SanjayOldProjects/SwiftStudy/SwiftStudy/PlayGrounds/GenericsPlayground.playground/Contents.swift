//: Playground - noun: a place where people can play

import UIKit

protocol Numeric {
    static func +(lhs: Self, rhs: Self) -> Self
}



extension Float: Numeric {
}
extension Double: Numeric {
}
extension Int: Numeric {
}

func squareSomething<LMK: Numeric>(value: LMK) -> LMK {
    return value + value
}


print(squareSomething(value: 40.34))

struct deque<T> {
    var array = [T]()
    mutating func pushBack(obj: T) {
        array.append(obj)
    }
    mutating func pushFront(obj: T) {
        array.insert(obj, at: 0)
    }
    mutating func popBack() -> T? {
        return array.popLast()
    }
    mutating func popFront() -> T? {
        if array.isEmpty {
            return nil
        } else {
            return array.removeFirst()
        }
    } }


var testDeque = deque<Int>()
testDeque.pushBack(obj: 5)
testDeque.pushFront(obj: 2)



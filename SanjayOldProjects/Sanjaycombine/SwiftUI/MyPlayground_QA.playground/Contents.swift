import UIKit

func someFunction() -> String {
    defer {
        print("defer")
    }
    return "Hello"
}
print(someFunction())

var employeeSalary = 20
func updateEmployeeSalary() {
    employeeSalary = 70
    defer { employeeSalary = 30 }
    defer { employeeSalary = 40 }
    defer { employeeSalary = 50 }
    employeeSalary = 50
}
updateEmployeeSalary()
print(employeeSalary)

//var a: String = "a"
//var b: String! = "b"
//var c: String? = "rrc"
//a = c // 1
//b = c // 2
//c = b // 3

//print(c)
class WhiteHouse {
    weak var pentagon: Pentagon?
    
    deinit {
        print("White House deinitialized")
    }
}
class Pentagon {
    weak var whiteHouse: WhiteHouse?
    
    deinit {
        print("Pentagon deinitialized")
    }
}
var a = WhiteHouse()
a.pentagon = Pentagon()

//weak var b = Pentagon()
////b?.whiteHouse = a
//class Kondana<T:Equatable> {
//    var dictDataHolder = [String:T]()
//    func add(value:T?,using key:String) -> T? {
//         self.dictDataHolder[key] = value
//         return value
//    }
//}
//var fortOne = Kondana<String>()
//let value = fortOne.
//print(value)
var motive = "Sip"
let userMotive = { [motive] in
    print(motive)
}
motive = "Lump Sum"
print(userMotive())
var crew = ["Captain": "Malcolm", "Doctor": "Simon"]
crew = [:]
print(crew.count)


let number = 5

switch number {
case 0..<5:
    print("First group")
case 0...5:
    print("Third group")
    fallthrough
case 5...10:
    print("Second group")
    
default:
    print("Fourth group")
}


let numbers = [1, 2, 3].map { [$0, $0] }
print(numbers)
let point = (556, 0)
switch point {
case (let x, 0):
    print("X was \(x)")
case (0, let y):
    print("Y was \(y)")
case let (x, y):
    print("X was \(x) and Y was \(y)")
}


//let valueTypedd:String! = "sakdlas"
//print(valueTypedd)
func doDomeThing(valueTypedd:String) {
    print(valueTypedd)
}

let temperature = 100
switch (temperature)
{
case 0...49 :
    print("Cold and even")
    fallthrough
case 2000...2049 :
    print("Warm and even")
case 0...49 :
    print("Hot and even")
    
default:
    print("Temperature out of range or odd")
}

protocol abd {
    init(name:String)
}

extension abd {
    init(name:String) {
        self.init(name: "aalskdnlansdlnkalnadlanklsd")
    }
}

class abdc:abd {
    required init(name:String) {
        print("adadad")
    }
    
    required init() {
        print("adadfffffffffffad")
    }
    
}

struct abcde {
    var name:String = ""
    var name2:String = ""
    init(nameis :String) {
        self.name = nameis
    }
}
abcde(nameis: "lklas")

@propertyWrapper
struct Address {
    private(set) var cityname: String = ""
    var projectedValue: Address { self }
    var wrappedValue: String {
        get { cityname }
        set { cityname = newValue.uppercased() }
    }
    
    init(wrappedValue: String) {
        self.wrappedValue = wrappedValue
    }
    
    func foo() { print("Foo") }
}

struct Contact {
    @Address var name: String
    @Address var city: String
    
    //Here _name is an instance of Wrapper, hence we can call foo().
    func foo() {
        print(name) // wrappedValue
        print(_name) // wrapper type itself
        print($name) // projectedValue
    }
  
}
var contact = Contact.init(name: "adad", city: "asdasdad")
contact.$name.foo()
//a.$x.foo()

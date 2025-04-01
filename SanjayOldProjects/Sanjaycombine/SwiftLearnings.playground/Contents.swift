import UIKit

//
////Tuples
////let coordinates = (x:2, y:3, z:4)
////print(coordinates.y)
////let (x3, y3, _) = coordinates
////
//// var switchState = true
//// switchState.toggle()
//
////switch coordinates {
////case let (x, y,z) where x % 2 == 0:
////  print("Even")
////default:
////  print("Odd")
////}
//
///*
// for index in stride(from: 10, to: 22, by: 4) {
// print(index)
// }
// // prints 10, 14, 18
// for index in stride(from: 10, through: 22, by: 4) {
// print(index)
// }
// // prints 10, 14, 18, and 22
// */
//
////Sentinel values
////A value that represents a special condition such as the absence of a value is known as a sentinel value
////var errorCode = 0
///////In the success case, you represent the lack of an error with a zero. That means 0 is a
///////sentinel value.
////
//////Nil coalescing
/////// in the case of nil, you’ll use a default value.
////var optionalInt: Int? = 10
////var mustHaveResult = optionalInt ?? 0
////
//////Closure basics
//////“If closures are functions without names,
////var multiplyClosure: (Int, Int) -> Int
////
////class Level {
////    var unlocked: Int = 0 {
////        didSet {
////            print("old value is \(oldValue)")
////        }
////        willSet {
////            print("new value is \(newValue)")
////
////        }
////    }
////}
////
////// keep in mind that the willSet and didSet observers are not called when a property is set during initialization;
////Level().unlocked = 100
//
//@dynamicMemberLookup
//class Person {
//    let name: String
//    let age: Int
//    init(name: String, age: Int) { self.name = name
//        self.age = age }
//}
//
//extension Person {
//    subscript(dynamicMember key: String) -> String? {
//        switch key {
//        case "name1":
//            return name
//        case "age":
//            return "\(age)"
//        default:
//            return nil
//        } }
//    
//    subscript(key: String) -> String? {
//        switch key {
//        case "name1":
//            return name
//        case "age":
//            return "\(age)"
//        default:
//            return nil
//        } }
//}
//
//let me = Person(name: "Cosmin", age: 33)
////print(me["name1"])
////print(me.name1)
//
///// me["name"]
////me["age"]
////me["gender"]
////The subscript is read-only, so its entire body is a getter — you don’t need to explicitly state that with the get keyword.
///// let title = \Tutorial.title
////let tutorialTitle = tutorial[keyPath: title]
//
//let groupSizes = [1, 5, 4, 6, 2, 1, 3, nil]
//for case .some(let value)  in groupSizes where value%2 == 0 {
//    //print("Found an individual") // 2 times
//}
//
////if case (_, 0, 0) = coordinate {
////print("On the x-axis") // Printed! }
////
//// if case (let x, 0, 0) = coordinate {
////print("On the x-axis at \(x)") // Printed: 1 }
//// for case let name? in names {
////  print(name) // 4 times
////}
//
////“Is” type-casting pattern
//
//class Base {
//    
//}
//
//class Derived:Base {
//    
//}
//
//
////let base = Derived()
////
////if base is Derived {
////    print("Base")
////}
////
////let response: [Any] = [15, "George", 2.0]
////for element in response {
//// switch element {
//// case is String:
////   print("Found a string") // 1 time
//// default: break
////  }
////}
//
////class Tutorial {
////    var title = "sanjay"
////    var name = "sanjay"
////   //lazy var description: () -> String = { [unowned self] in
////   //"\(self.title) by \(self.name)" }
////
////    lazy var description: () -> String = { [weak self] in
////    "\(self?.title) by \(self?.name)" }
////
////
////    deinit {
////        print("DeAlloc")
////    }
////
////}
////
////let abd = Tutorial()
////abd.description()
////
//
////var counter = 0
////var f = {
////    [counter] in
////    print(counter)
////}
////
////counter = 1
////f()
////struct Bar {
////    private var _x = 0
////    var x: Int {
////        get { _x }
////        set {
////            _x = newValue
////            print("New value is \(newValue)")
////        }
////    }
////}
////
////var bar = Bar()
////bar.x = 1
//
////@propertyWrapper
////class Capitalized {
////    var wrappedValue: String {
////        didSet {
////            wrappedValue = wrappedValue.capitalized
////        }
////    }
////
////    init(wrappedValue: String) {
////        self.wrappedValue = wrappedValue.capitalized
////        print("adadassss")
////    }
////}
////
////struct User {
////    @Capitalized var firstName: String
////    @Capitalized var lastName: String
////}
////
////
////let user = User.init(firstName: "Sanjay", lastName: "rathor")
////
////
////@propertyWrapper
////struct Storage<T> {
////    var key:String = ""
////    let defaultValue:T
////
////    init(key:String, defaultValue:T) {
////        self.key = key
////        self.defaultValue = defaultValue
////    }
////
////    var wrappedValue:T {
////        get {
////            UserDefaults.standard.value(forKey: key) as? T ?? defaultValue
////        }
////        set {
////            print(newValue)
////            UserDefaults.standard.setValue(newValue, forKey: key)
////        }
////    }
////}
////
////
////struct AppData {
////    @Storage var userName:String// (key: "username_key", defaultValue:"Sanjay")
////    @Storage var isLoggedIn:Bool
////}
////
////let user =  AppData.init(userName: Storage.init(key: "username_key", defaultValue: "Sanjay"), isLoggedIn: <#Storage<Bool>#>)
//// print(user.name)
////
//
////class Blog {
////    let url: URL
////    var owner: Blogger?
////    init(url: URL) {
////        self.url = url
////    }
////
////    deinit {
////        print("Blog is being deinitialized")
////    }
////}
////
////class Blogger {
////    var blog: Blog?
////    deinit {
////        print("Blogger is being deinitialized")
////    }
////}
////
////
////
////var blog: Blog? = Blog(url: URL(string: "www.avanderlee.com")!)
////var blogger: Blogger? = Blogger()
////
////blog!.owner = blogger
////blogger!.blog = blog
////
////blog = nil
////blogger = nil
//
//
////class MyProperty {
////    lazy var name:String = {
////        return "Sanjay Singh Rathor"
////    }()
////
////}
////
////print(MyProperty().name)
//
///*
// let twostraws = (name: "twostraws", password: "fr0st1es")
// let bilbo = (name: "bilbo", password: "bagg1n5")
// let taylor = (name: "taylor", password: "fr0st1es")
// let users = [twostraws, bilbo, taylor]
// 
// for user in users {
// print(user.name)
// }
// 
// for case ("twostraws", "fr0st1es") in users {
// print("User twostraws has the password fr0st1es")
// }
// 
// for case (let name, let password) in users {
// print("User \(name) has the password \(password)")
// }
// 
// for case let (name, password) in users {
// print("User \(name) has the password \(password)")
// }
// 
// for case let (name, "fr0st1es") in users {
// print("User \(name) has the password \"fr0st1es\"")
// }
// 
// 
// let name: String? = "twostraws"
// let password: String? = "fr0st1es"
// 
// switch (name, password) {
// case let (userName?, _):
// print("Hello, \(userName)")
// 
// case let (.some(name), .some(_)):
// print("Hello, \(name)")
// case let (.some(_), .none):
// print("Please enter a password.") default:
// print("Who are you?")
// 
// }
// let data: [Any?] = ["Bill", nil, 69, "Ted"]
// for case let .some(datum) in data {
// print(datum)
// }
// //if case 0 ..< 18 = age {
// //if 0 ..< 18 ~= age {
// //if (0 ..< 18).contains(age)
// let view: AnyObject = UIButton()
// 
// 
// 
// @dynamicMemberLookup
// struct DynamicStruct {
// let dictionary = ["someDynamicMember": 325,
// "someOtherMember": 787]
// subscript(dynamicMember member: String) -> Int {
// switch  member {
// case "Name":
// return 1111
// default:
// return 1112
// }
// 
// return dictionary[member] ?? 1054
// }
// }
// let s = DynamicStruct()
// 
// 
// // Use dynamic member lookup.
// let dynamic = s.someDynamicMember
// print(dynamic)
// // Prints "325"
// 
// // Call the underlying subscript directly.
// let equivalent = s[dynamicMember: "someDynamicMember"]
// print(dynamic == equivalent)
// // Prints "true"
// */
//@propertyWrapper
//struct SomeWrapper {
//    var wrappedValue: Int
//    var someValue: Double
//    init() {
//        self.wrappedValue = 100
//        self.someValue = 12.3
//    }
//    init(wrappedValue: Int) {
//        self.wrappedValue = wrappedValue
//        self.someValue = 45.6
//        print(self.wrappedValue);
//        print(self.someValue);
//        
//    }
//    init(wrappedValue value: Int, custom: Double) {
//        self.wrappedValue = value
//        self.someValue = custom
//        print(self.wrappedValue);
//        print(self.someValue);
//        
//    }
//}
//
//struct SomeStruct {
//    // Uses init()
//    // @SomeWrapper var a: Int
//    //
//    //    // Uses init(wrappedValue:)
//    //    @SomeWrapper var b = 10
//    
//    // Both use init(wrappedValue:custom:)
//    //     @SomeWrapper(custom: 98.7) var c
//    // @SomeWrapper(wrappedValue: 30, custom: 98.7)// var d
//}
//
////SomeStruct()
////
////
////@propertyWrapper
////struct Wrapper {
////   var wrappedValue: Int
////   func foo() { print("Foo") }
////}
////
////struct HasWrapper {
////    @Wrapper var x = 0
////    //func foo() { _x.foo() }
//////    func foo() {
//////        print(x) // `wrappedValue`
//////        print(_x) // wrapper type itself
//////        print($x) // `projectedValue`
//////    }
////}
////
////
////
////struct HasWrapperWithInitialValue {
////    @Wrapper var x = 0 // 1
////    @Wrapper(wrappedValue: 110)var y  // 2
////    func foo() {
////          print(y)
////    }
////
////}
////
//////The compiler implicitly uses init(wrappedValue:) to initialize x with 0.
//////struct HasWrapperWithInitialValue {
//// //   @Wrapper var x = 0 // 1
////  //  @Wrapper(wrappedValue: 0) var y // 2
////
////HasWrapperWithInitialValue().foo()
////@propertyWrapper
////struct Uppercased {
////    private var text: String
////    var wrappedValue: String {
////        get { text.uppercased() }
////        set { text = newValue }
////    }
////    init(wrappedValue: String)  {
////        self.text = wrappedValue
////    }
////}
////
////struct User {
////    //Assiging the defaut value.. username  is the proeprty that  will be accessed from outside
////    ///@Uppercased(wrappedValue: "Sanjay") var username: String
////    @Uppercased var username: String = "adsas"
////}
////
////var user = User()
////user.username =  "alfianlo"
////print(user.username) // ALFIANLO
////@propertyWrapper
////struct Ranged<T: Comparable> {
////    private var minimum: T
////    private var maximum: T
////    private var value: T
////    var wrappedValue: T {
////        get { value }
////        set {
////            if newValue > maximum {
////                value = maximum
////            } else if newValue < minimum {
////                value = minimum
////            } else {
////                value = newValue
////            }
////        }
////    }
////    init(wrappedValue: T, minimum: T, maximum: T) {
////        self.minimum = minimum
////        self.maximum = maximum
////        self.value = wrappedValue
////        self.wrappedValue = wrappedValue
////
////        print("asdasd")
////    }
////}
////
////struct Form {
////    @Ranged(wrappedValue: 0, minimum: 65, maximum: 200) var age
////    //@Ranged(minimum: 17, maximum: 65) var age: Int = 0
////}
////
////var form = Form()
////form.age = 100 // 65
////form.age = 2 // 17
//
///*
// @propertyWrapper struct WhiteSpacesTrimmed {
// var projectedValue: String
// var wrappedValue: String {
// didSet {
// print("propertyWrapper didSet")
// self.projectedValue = wrappedValue
// wrappedValue = wrappedValue.trimmingCharacters(in: .whitespaces)
// }
// }
// 
// init(wrappedValue:String) {
// print("propertyWrapper didSetccccc")
// self.projectedValue = wrappedValue
// self.wrappedValue = wrappedValue.trimmingCharacters(in: .whitespaces)
// }
// 
// }
// 
// class TestClass5 {
// @WhiteSpacesTrimmed var test = "       test"
// }
// 
// print("projected Values")
// var testClass5 = TestClass5()
// 
// testClass5.$test = "a.dmlasdlanlksdlaskdnalkndkl"
// print(testClass5.test) //"test"
// print(testClass5.$test) //"       test"
// let array = ContiguousArray<Int>(1...1000000)
// */
//
//let words = ["1989", "Fearless", "Red"]
//let input = "My favorite album is Fearless"
//words.contains(where: input.contains)
////input.contains("1989")
//
//
////enum myErr:Error {
////    case errr
////}
////
////func functionA() throws -> String {
////    let name:String? = nil
////    throw myErr.errr
////
////}
////
////
////do {
////      print(try functionA())
////   } catch let errrssd {
////       print(errrssd)
////
////}
////enum Failure: Error {
////    case badNetwork(message: String)
////    case broken
////}
////
////func fetchRemote() throws -> String {
////    throw Failure.badNetwork(message: "Firewall blocked port.")
////}
////
////func fetchLocal() -> String { // this won't throw
////    return "Taylor"
////}
////
//////func fetchUserData(using closure: () throws -> String) {
//////    do {
//////        let userData = try closure()
//////        print("User data received: \(userData)")
//////
//////       }
//////    catch Failure.badNetwork(let message){
//////        print(message)
//////    }
//////    catch {
//////        print("Fetch error")
//////    }
//////}
////
////    func fetchUserData(using closure: () throws -> String) rethrows {
////        let userData = try closure()
////        print("User data received: \(userData)")
////    }
////
////    do {
////          try fetchUserData(using: fetchLocal)
////       } catch Failure.badNetwork(let message) { print(message)
////
////     } catch {
////        print("Fetch error")
////    }
////
//////fetchUserData(using: fetchLocal)
//////fetchUserData(using: fetchRemote)
//
//extension String: Error { }
//
//
//func authentication() throws {
//    throw "Sucess"
//}
//
////func authenticateUser(method: (String) throws -> Bool) throws
////func authenticateBiometrically(_ user: String) throws -> Bool {
////    //    throw "Failed"
////    try authentication()
////    return true
////}
//
//func authenticateByPassword(_ user: String) -> Bool {
//    //throw "Failed"
//    return true
//}
//
//func authenticateUser(method: (String) throws -> Bool) rethrows {
//    try method("twostraws")
//    print("Success!")
//}
//
//
////try authenticateUser(method: authenticateByPassword)
//try authenticateUser(method: authenticateByPassword)
//
//do {
//    try authenticateUser(method: authenticateByPassword)
//} catch {
//    print("D'oh!")
//}
//
////If closer or contained  method throws only then there is need for try catch otherwise no need to add try catch
////ow Xcode will give you a warning: the catch block later on is unreachable because authenticateUser will never throw errors. But if you were to call it using authenticateBiometrically then you would need the do/catch blocks – Swift is able to evaluate the flow of our code much better, which means we need to write less code.
//// This is regular function
//
//func nonThrowingCompletion()  {
//    print("completed !!")
//}
//
//// This is a function throwing an error
//func throwingCompletion() throws {
//    throw "Some Error"
//}
//
///* By using Rethrows, this is a method that
// accepts both params types  (throwing and non throwing) */
//func doSomething(completion: () throws -> Void ) rethrows {
//    print("Doing something ...")
//    try completion()
//}
//
//// Here when using the regular function as parameter no need to "try"
//doSomething(completion:nonThrowingCompletion)
//
//// Here we can see that its possible to use it also for the throwing method
//try doSomething(completion:nonThrowingCompletion)
//do {
//    try doSomething(completion:nonThrowingCompletion)
//} catch  {
//    print("Catched : \(error)")
//}
//
//
//
//@dynamicMemberLookup
//struct Person1 {
//    subscript(dynamicMember member: String) -> String {
//        let properties = ["name": "Taylor Swift", "city": "Nashville"]
//        return properties[member, default: ""]
//    }
//    
//    subscript(member: String) -> String? {
//        let properties = ["name": "Taylor Swift", "city": "Nashville"]
//        return properties[member, default: ""]
//    }
//}
//let person = Person1()
//print(person["name"])
//print(person.city)
//print(person.nameOfPet)
////Subscripts are used to access information from a collection, sequence and a list in Classes, Structures and Enumerations without using a method.
//
//@frozen
//enum NewEnum:Int {
//    case first = 1
//    case second = 2
//    case third =  3
//    case forth =  4
//    
//}
//
////func show(label:NewEnum) {
////
////    switch label {
////    case .first:
////        print("first")
////
////    case .second:
////    print("second")
////     fallthrough
////   @unknown default:
////      print("unknown")
////
////    }
////
////}
//
////@unknown default://
////If each case is not handled individually, it will create warning in your enum and will not throw error, thus making it compactible for new enum cases.
////@unknown default is similar to usual default state and thus it matches any values. It is required to mention all the cases. If any new case is introduced, it will highlight them a warning sign instead of throwing an error. default will not show any warning if any case is missed. The main difference is given in below example,
//
//
////show(label: .second)
//
//
//
//protocol ListItemDisplayable {
//    var name: String { get }
//}
//
//
////var listItem: ListItemDisplayable = Shoe(name: "a shoe")
//
//struct Shoe: ListItemDisplayable {
//    let name: String
//}
//
//struct Shorts: ListItemDisplayable {
//    let name: String
//}
//
//var mixedList: [ListItemDisplayable] = [Shoe(name: "a shoe"),
//                                        Shorts(name: "a pair of shorts")]
////https://medium.com/@navdeepsingh_2336/generics-in-swift-13e792249cad
////https://heartbeat.fritz.ai/understanding-method-dispatch-in-swift-684801e718bc
//
//
//
////func addition<T:Numeric>(a: T, b: T) -> T {
////    return a + b
////}
////
////let result = addition(a: 42.0, b: 99.0)
////print(result)
////
////
//
//protocol FullName {
//    var firstName: String {get }
//    init (firstName: String)
//    
//}
//
//
//class Name: FullName {
//    required init(firstName: String) {
//        
//    }
//    
//    var firstName: String {
//        return "adasd"
//    }
//    
//    
//    
//}
//
//
//
//var clouser:(String)->Void = { value in
//    print(value)
//}
//
//
//clouser("adalaflkfkn")
//
//
//
//struct Book {
//    var title = ""
//    var author = ""
//}
//
//protocol Storage {
//    associatedtype Item
//    func store(item: Item)
//    func retrieve(index: Int) -> Item
//}
//
//class Trunk<Item>: Storage {
//    var items:[Item] = [Item]()
//    
//    func store(item: Item) {
//        items.append(item)
//    }
//    
//    func retrieve(index: Int) -> Item {
//        return items[index]
//    }
//}
//
//let bookTrunk = Trunk<Book>()
//bookTrunk.store(item: Book(title: "1984", author: "George Orwell"))
//bookTrunk.store(item: Book(title: "Brave New World", author: "Aldous Huxley"))
//print(bookTrunk.retrieve(index: 1).title)
//
//
////var fullName:String = {
////       print("Sanjay Singh rathor")
////       return ""
////   }()
//
//
////var fullNameSt:String? = "Sanjay Singh rathor"
////var jdjdjd = fullNameSt!
//// print(fullNameSt!)
////func realStringExpecter(_ s:String) {
////     print(s)
////}
////
////var stringMaybe : String! = "howdy"
////var dshva = stringMaybe
////realStringExpecter(dshva!)
//////print(stringMaybe)
//
//
////var dshva = stringMaybe
////print(dshva)
////realStringExpecter(dshva) // no problem
//
///// implicitly unwrapped Optional is still an Optional.It’s just a convenience. By declaring something as an implicitly unwrapped Optional, you are asking the compiler, if you happen to use this value where the wrapped type is expected, to forgive you and to unwrap the value for you. implicit unwrapping does not propagate by assignment.
//
//
//
////class abc {
////    func callme() {
////        print("MyController")
////    }
////}
////
////class MyController  {
////    var view: abc!
////    func add() {
////        print(view.callme())
////    }
////
////}
////
//
//func optionalExpecter(_ s:String!) {
//    // print(s)
//}
//let stringMaybe : String? = "howdy"
//let stringMaybe1 : String? = stringMaybe
//print(stringMaybe1)
//
//optionalExpecter(stringMaybe)
//
//
//
//
//enum MyError {
//    case number(Int)
//    case message(String)
//    case fatal
//    
//}
//let err : MyError = .number(4)
//print(err.self)
//enum Filter : String, CaseIterable {
//    case albums = "Albums"
//    case playlists = "Playlists"
//    case podcasts = "Podcasts"
//    case books = "Audiobooks"
//    init(_ ix:Int) {
//        self = Filter.allCases[ix]
//        
//    }
//}
//
//struct Digit {
//    
//    var number : Int
//    init(_ n:Int) {
//        self.number = n
//    }
//    
//    mutating func change() {
//        self.number  = 100
//    }
//}
//
////But in reality, when you apparently mutate an instance of a value type,
////you are actually replacing that instance with a different instance.
////var dx = Digit(123)
////dx.change()
////dx.number = 42
//
//var d : Digit = Digit(123) { // Digit is a struct
//    didSet {
//        print("d was set") }
//}
//d.change()
////d.number = 42 // "d was set"
//
////That explains why it is impossible to mutate a value type instance
/////if the reference to that instance is declared with let:
////let d = Digit(123) // Digit is a struct
////d.number = 42 // compile error
//
////Under the hood, this change would require us to replace the Digit instance pointed to by d with another Digit instance — and we can’t do that, because it would mean assigning into d, which is exactly what the let declaration forbids.
/////That also explains why an instance method of a struct or enum that sets a property of the instance must be marked explicitly with the mut ating keyword. Such a method can potentially replace this object with another, so the reference to the object must be var, not let.
//
////  func digitChanger(_ dog:Digit) { // Digit is a struct
////    dog.number = 42 // compile error
////}
//
//
//
//
////The chief restriction here is that an override property cannot be a stored property. More specifically:
//
////class Dog  {
////
////    var name:String
////
////    var fullName:String {
////
////        get {
////            return "kknAJKDSkabsdk"
////        }
////
//////        set {
//////            fullName = newValue
//////        }
////    }
////
////    init(_ uerName:String) {
////        self.name = uerName
////    }
////
////}
////
////class NoisyDog : Dog {
////    ///— If the superclass property is stored, the subclass’s computed property override must have both a getter and a setter.
////    override var name:String  {
////        set {
////            name = newValue
////        }
////        get {
////            return "asdknaksd"
////        }
////    }
////}
////
////
/////The chief difference between static and class methods, from the programmer’s point of view, is that a static method cannot be overridden; it is as if static were a synonym for class final. Cannot override static property
////class methods can be overridden as class or as static A subclass inherits whatDogsSay, and can override it, either as a class method or as a static method:
//
////class Dog {
////    static func whatDogsSay() -> String {
////        return "woof"
////
////    }
////
////    func bark() {
////        print(Dog.whatDogsSay())
////    }
////}
////
////class NoisyDog : Dog {
////
////   override static func whatDogsSay() -> String {
////        return "woof"
////
////    }
////}
////NoisyDog.whatDogsSay()
////
//////class DogX {
//////    static var whatDogsSay = "asdasd"
//////}
//////
//////class NoisyDogX : DogX {
//////    override static var whatDogsSay: String  {
//////        get {
//////            return "asdkasdb"
//////        }
//////        set {
//////
//////        }
//////    }
//////
//////}
//////
//////NoisyDogX.whatDogsSay
//
//
////The require d designation reassures the compiler; every subclass of Dog must inherit or reimplement init(name:), so it’s legal to call init(nam e:) message on a type reference that might refer to Dog or some subclass of Dog.
////because Self, like self, obeys polymorphism.
////class Dog {
////    var name : String
////    required init(name:String) { // * required
////         self.name = name
////    }
////    class func makeAndName() -> Self  {//Dog
////        let d = Self(name:"Fido")
////        return d
////    }
////}
////
////class NoisyDog : Dog {
////
////}
//
////let de = Dog.makeAndName() // d is a Dog named Fi
////let d2 = NoisyDog.makeAndName() // d2 is a NoisyDog named Fido
////In some situations, you may want to treat an object type as a value. That is legal. An object type is itself an object
//
//class Dog {
//    required init() {
//    }
//    
//    func show() {
//        print("jhkajdkjajksdkasdkj dkasdjkakjsdkjadsjkabdj kajdkajsdbkjbadjbdj")
//    }
//}
//
//func createINstance(instance:Dog.Type) -> Dog {
//    let d =  instance.init()
//    d.show()
//    return d
//}
//
//createINstance(instance: Dog.self)
/////protocol
/////defines a blueprint of methods, properties, and other requirements that suit a particular task or piece of functionality.
////
////protocol Fighter {
////    associatedtype Enemy : Fighter
////}
////
////struct Soldier : Fighter {
////    typealias Enemy = Archer
////}
////
////struct Archer : Fighter {
////    typealias Enemy = Soldier
////}
////
////struct Camp<T:Fighter> {
////  var spy : T.Enemy?
////
////}
////
////var c = Camp<Soldier>()
////c.spy = Soldier() // compile error
///// an associated type which is constrained to a generic protocol that also has an associated type.
//
/////Generic protocol with Self
/////In a protocol body, use of the keyword Self turns the protocol into a generic. Self here is a placeholder meaning the type of the adopter. Here’s a Flier protocol that declares a method that takes a Self parameter:
//
//protocol Generic {
//    
//}
//
//protocol Flier {
//    associatedtype Other : Generic
//    func flockTogetherWith(_ f:Other)
//    
//}
//
//
////struct Bird : Flier, Generic {
////
////    func flockTogetherWith(_ f: Flier) {
////        print("flockTogetherWith")
////    }
////
////}
//
//
////Bird().flockTogetherWith("asdsa")
//
//func implicitOptionals(name:String) {
//    print(name)
//}
//
//var stringMaybee : String? = "implicitOptionals"
//print(stringMaybee!.uppercased())
//
////var stringMaybee2:String = stringMaybee
////
//////print(stringMaybee2)
////implicitOptionals(name: stringMaybee)
//
//
/////An implicitly unwrapped Optional is an Optional, but the compiler permits some special magic associated with it: its value can be used directly where the wrapped type is expected
//
////The for-case example is very similar to using the where statement where it is designed to eliminate the need for an if statement within a loop to filter the results.for case let ("Red Sox", year) in worldSeriesWinners {
// //    print(year)
/////}
//let myNumbers: [Int?] = [1, 2, nil, 4, 5, nil, 6]
//for case let .some(num) in myNumbers where num < 3 {
//     print(num)
//}
//enum Identifier {
//     case Name(String)
//     case Number(Int)
//     case NoIdentifier
//}
//var playerIdentifier = Identifier.Number(2)
//if case let .Number(num) = playerIdentifier {
//     print("Player's number is \(num)")
//   }
//
////var playerIdentifier = Identifier.Number(2)
//if case let .Number(num) = playerIdentifier, num == 2 {
//    print("Player is either XanderBogarts or Derek Jeter")
//}
//
//
////func dispay(name:String...) {
////    for s in name {
////        print(s)
////    }
////}
/////dispay(name: "adasd", "adsaddasdasdas")
//
////Define-and-Call
///*
// lazy var prog : UIProgressView = {
// let p = UIProgressView(progressViewStyle: .default) p.alpha = 0.7
// p.trackTintColor = UIColor.clear p.progressTintColor = UIColor.black
// p.frame =
// CGRect(x:0, y:0, width:self.view.bounds.size.width, height:20) // legal
// p.progress = 1.0
// return p
// }()
// 
// extension List where T: Numeric { func sum () -> T {
// return items.reduce (0, +) }
// }
// 
// 
// */

class NetworkClient {
    
    static func checkStatus(jsonDict:[String:Any]) -> Bool {
        var statusBool = false
        if jsonDict["Success"] is Bool {
            statusBool = jsonDict["Success"] as? Bool ?? false
        }
        else if jsonDict["Success"] is String {
            let status = jsonDict["Success"] as? String ?? "true"
            statusBool = (status == "true") ? true : false
        }
        else {
            let statusInt = jsonDict["Success"] as? Int ?? 0
            if statusInt == 1 {
                statusBool = true
            }
        }
        return statusBool
    }
}

func jsonDict(text: String) -> [String:Any]? {
    if let data = text.data(using: .utf8) {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            return json
        } catch {
            print("Something went wrong")
        }
    }
    return nil
}

var json = "{ \"cmd\" : \"421\", \"Success\" : false}"
///var response =  ["Success": true, "cmd": 420] as [String : Any]
if let json = jsonDict(text: json) {
    let value =  NetworkClient.checkStatus(jsonDict: json)
    print(value)
}

 


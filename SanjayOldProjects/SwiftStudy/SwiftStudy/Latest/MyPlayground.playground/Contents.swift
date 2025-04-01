import UIKit

@propertyWrapper
struct Truncate {
    private var _value: String = ""
    private let maximumLength: Int
    
    var projectedValue: Bool = false // 1
    var wrappedValue: String {
        set {
            _value = truncate(string: newValue)
        }
        
        get {
            return _value
        }
    }
    
    init(wrappedValue: String, maximumLength: Int = 10) {
        self.maximumLength = maximumLength
        _value = truncate(string: wrappedValue)
    }
    
    private mutating func truncate(string: String) -> String {
        if string.count > maximumLength {
            projectedValue = true // 2
            return string.prefix(maximumLength) + "..."
        } else {
            projectedValue = false // 3
            return string
        }
    }
}
struct Custom {
//    @Truncate var body:String
//    init(rating: String) {
//        self.body = rating
//    }
    @Truncate(maximumLength: 100) var body: String = "Hello, SwiftUI!"
    ///private var _body: Truncate = Truncate(wrappedValue: "Hello, SwiftUI!")
    ///var body: String { /* access via _body.wrappedValue */ }
    func show() {
        print(_body.wrappedValue)
    }
//       private var _body = Truncate()
//       var body: String {
//           get {
//               return _body.wrappedValue
//
//           }
//           set {
//               _body.wrappedValue = newValue
//           }
//       }
//
//    Implemented as
//    public var $body: Bool {
//      get { return _body.projectedValue }
//      set { _body.projectedValue = newValue }
//    }
}

var data = Custom()
data.body = "asldkmlkamsdlkalkdklandkanksd"
print(data.body)
data.show()
data.$body = false
print(data.$body) // 2



var arrayOne = [1,2,3,4,5,6,7,8,9]
var arrayOne2 = arrayOne.filter{$0 > 5 ? true : false}



var scores1 = [100, 81, 95]
var scores2 = [100, 98, 95]
let diff2 = scores2.difference(from: scores1)
var newArray = scores2.applying(diff2) ?? []
print(newArray)


class simple {
    var name:String = ""
}

let abc = simple()

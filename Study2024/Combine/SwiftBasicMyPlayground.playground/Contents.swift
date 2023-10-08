import UIKit

@propertyWrapper
struct BasicWrapper {
    var string: String
    init(wrappedValue: String) {
        self.string = wrappedValue
    }
    var wrappedValue: String {
        get {
            string.trimmingCharacters(in: .whitespacesAndNewlines) + "sdfsdfsdf"
        }
        set(newValue) {
            string = newValue
        }
    }
}

class DemoStruct {
    @BasicWrapper var value = "demo => "
    func dis() {
        print(value)
    }
    
    func say(@BasicWrapper what: String) { print(what)
    }
    
}

let adn = DemoStruct()

adn.dis()

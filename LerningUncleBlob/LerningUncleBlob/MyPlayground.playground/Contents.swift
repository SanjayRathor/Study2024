import UIKit

protocol Abc {
    func dispaly()
    ///func dispalyAdd()
}

extension Abc {
    func dispalyAdd() {
        self.dispaly()
    }
}

class Admdmd: Abc {
    func dispaly() {
        print("dispaly")
    }
}

let ajdh = Admdmd()
ajdh.dispalyAdd()


//  TamimiEcom
//
//  Created by Sanjay Singh Rathor on 08/08/20.
//  Copyright © 2020  . All rights reserved.
//

import UIKit

let KEY_SAVE_LANGUAGE       = "KEY_SAVE_LANGUAGE"

enum LanguageName: String {
    // Add any language you want
    case english = "en"
}

class LanguageManager: NSObject {
    static let shared = LanguageManager()
    private var languageBundle: Bundle!
    var languageIdentifier = ""
    
    func setLanguage(_ name: LanguageName) {
        let path = Bundle.main.path(forResource: name.rawValue, ofType: ".lproj")!
        let bundle = Bundle(path: path)!
        languageBundle = bundle
        switch name {
        case .english:
            languageIdentifier = "en"
        }
    }
    
    static func get(_ key: String) -> String {
        return NSLocalizedString(key, bundle: LanguageManager.shared.languageBundle, comment: "")
    }
}

extension String {
    var localized: String {
        let lang = UserDefaults.standard.string(forKey: KEY_SAVE_LANGUAGE)
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle.init(path: path!)
        return bundle!.localizedString(forKey: self, value: "", table: nil)
    }
    
    func toDouble() -> Double {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        //        formatter.locale = locale
        formatter.usesGroupingSeparator = true
        if let result = formatter.number(from: self)?.doubleValue {
            return result
        } else {
            return 0
        }
    }
}


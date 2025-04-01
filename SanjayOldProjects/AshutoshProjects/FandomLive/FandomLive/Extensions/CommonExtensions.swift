//
//  Common.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 06/10/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit

public struct Errors {
    /*public static var unknownError: NSError {
     return gennerate(with: -9999, domain: Constants.networkingDomain, message: "Unknown error")
     }
     public static var responseError: NSError {
     return gennerate(with: -1, domain: Constants.networkingDomain, message: "Unsuspect response value")
     }*/
    static func gennerate(with code: Int, domain: String, message: String) -> NSError {
        return NSError(domain: domain, code: code, userInfo: [NSLocalizedDescriptionKey: message])
    }
}


// hide keyboards in view controllers
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension Date {
    func differenceInDaysWithDate(date: Date) -> Int {
        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: self)
        let date2 = calendar.startOfDay(for: date)
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        return (components.day ?? 0 > 0 ? components.day : 0)  ?? 0
    }
    
    static func isCurrentDateIsFuture(eventDate:String) -> Bool {
        
        let timeEnd = Date(timeInterval: eventDate.toDate(format: "yyyy-MM-dd HH:mm:ss").timeIntervalSince(Date()), since: Date())
        let timeNow = Date()
        if timeEnd.compare(timeNow) == ComparisonResult.orderedDescending {
            return true
        }
      return false
    }
    
}

extension DateFormatter {
    static var endDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.autoupdatingCurrent
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }
}

extension UIView {
    func addShadow(color: UIColor = UIColor.gray, cornerRadius: CGFloat) {
        self.backgroundColor = UIColor.white
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 1.0
        self.backgroundColor = .white
        self.layer.cornerRadius = cornerRadius
    }
}


extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: 1)
    }

    class var eventDeActiveColor: UIColor { return UIColor(red: 172, green: 172, blue: 172) }
    class var eventActiveColor: UIColor { return UIColor(red: 0, green: 144, blue: 255) }
    
    class var eventOnGoingColor: UIColor { return UIColor(red: 34, green: 157, blue: 29) }
    class var eventCompletedColor: UIColor { return UIColor(red: 254, green: 25, blue: 25) }
    class var appthemeColor: UIColor { return UIColor(red: 227, green: 25, blue: 126) }
    
    class func hexColorStr (_ hexStr : NSString, alpha : CGFloat) -> UIColor {
       var hexStr = hexStr, alpha = alpha
       hexStr = hexStr.replacingOccurrences(of: "#", with: "") as NSString
       let scanner = Scanner(string: hexStr as String)
       var color: UInt32 = 0
       if scanner.scanHexInt32(&color) {
           let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
           let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
           let b = CGFloat(color & 0x0000FF) / 255.0
           return UIColor(red:r,green:g,blue:b,alpha:alpha)
       } else {
           print("invalid hex string")
           return UIColor.white;
       }
   }

}


// store colors on user defaults
extension UserDefaults {
    func potter_colorForKey(key: String) -> UIColor? {
        var color: UIColor?
        if let colorData = data(forKey: key) {
            color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor
        }
        return color
    }
    
    func potter_setColor(color: UIColor?, forKey key: String) {
        var colorData: NSData?
        if let color = color {
            colorData = NSKeyedArchiver.archivedData(withRootObject: color) as NSData?
        }
        set(colorData, forKey: key)
    }
}
extension Dictionary where Key == String, Value == Any {
    mutating func append(anotherDict:[String:Any]) {
        for (key, value) in anotherDict {
            self.updateValue(value, forKey: key)
        }
    }
}
extension String {
    var boolValue: Bool {
        return NSString(string: self).boolValue
    }
    
}

extension String{
    func toDate(format : String) -> Date{
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)!
    }
}


@IBDesignable class PaddingLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 16.0
    @IBInspectable var rightInset: CGFloat = 16.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}


extension String {
    var htmlToAttributedString: NSMutableAttributedString? {
        guard let data = data(using: .utf8) else { return NSMutableAttributedString() }
        do {
            return try NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSMutableAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}


extension UIButton {
    func setGradientImage(for state:UIControl.State)  {
       let gradientLayer = CAGradientLayer()
       let sizeLength = UIScreen.main.bounds.size.height * 2
       let navBarFrame = CGRect(x: 0, y: 0, width: sizeLength, height: 64)
       gradientLayer.frame = navBarFrame
       gradientLayer.colors = [kGradintStartColor.cgColor, kGradintEndColor.cgColor]
       gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
       gradientLayer.endPoint = CGPoint(x: 0.7, y: 0.5)

       UIGraphicsBeginImageContext(gradientLayer.frame.size)
       gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
       let outputImage = UIGraphicsGetImageFromCurrentImageContext()
       UIGraphicsEndImageContext()
        self.setBackgroundImage(outputImage!, for:state)
        self.setBackgroundImage(outputImage!, for:.highlighted)
        self.setBackgroundImage(outputImage!, for:.focused)
        
   }
}

extension UIViewController  {

    func compressImage( image: UIImage) -> UIImage {

        var actualHeight = Float(image.size.height)
        var actualWidth = Float(image.size.width)
        let maxHeight = Float(200.0)
        let maxWidth = Float(200.0)
        var imageRatio = Float(actualWidth/actualHeight)
        let maxRatio = Float(maxWidth/maxHeight)
        let compressionQuality = Float( 0.5 )  // 50 percent compression
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imageRatio < maxRatio {
                //adjust width according to maxHeight
                imageRatio = maxHeight / actualHeight
                actualWidth = imageRatio * actualWidth
                actualHeight = maxHeight
            } else if imageRatio > maxRatio {
                imageRatio = maxWidth / actualWidth
                actualHeight = imageRatio * actualHeight
                actualWidth = maxWidth

            } else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }

        }

        let rect = CGRect(x: 0, y: 0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let compressedImage =  UIGraphicsGetImageFromCurrentImageContext()
        let compressedImageData  = compressedImage!.jpegData(compressionQuality: CGFloat(compressionQuality))
        UIGraphicsEndImageContext()
        return UIImage(data: compressedImageData!)!
    }

}

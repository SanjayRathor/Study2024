//
//  HelperMethods.swift
//  dsdd
//
//

import Foundation
import UIKit
import Toast_Swift

func validateEmail(_ email:String)->Bool
{
    let emailRegex="[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,7}"
    let emailTest=NSPredicate(format:"SELF MATCHES %@", emailRegex)
    return emailTest.evaluate(with:email)
}
 func alert(_ title : String, message : String, view:UIViewController) {
    view.view.makeToast(message, duration: 3.0, position: .bottom)
//return
//    let alert = UIAlertController(title:title, message:  message, preferredStyle: UIAlertController.Style.alert)
//    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//    view.present(alert, animated: true, completion: nil)
}
func showMessage(title: String, message: String, okButton: String, cancelButton: String, controller: UIViewController, okHandler: (() -> Void)?, cancelHandler: @escaping (() -> Void)) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    
    let dismissAction = UIAlertAction(title: okButton, style: UIAlertAction.Style.default) { (action) -> Void in
        if okHandler != nil {
            okHandler!()
        }
    }
    let cancelAction = UIAlertAction(title: cancelButton, style: UIAlertAction.Style.default) {
        (action) -> Void in
        cancelHandler()
    }
    
    alertController.addAction(dismissAction)
    if cancelButton != "" {
    alertController.addAction(cancelAction)
    }
    controller.present(alertController, animated: true, completion: nil)
}
func showAlertMessage(title: String, message: String, okButton: String, controller: UIViewController, okHandler: (() -> Void)?){
    let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    let dismissAction = UIAlertAction(title: okButton, style: UIAlertAction.Style.default) { (action) -> Void in
        if okHandler != nil {
            okHandler!()
        }
    }
    alertController.addAction(dismissAction)
    controller.present(alertController, animated: true, completion: nil)

}
func getTheTimedDiff(firstPress:Double) -> Bool {
    if firstPress <= 0.0 {
        return false
    }
    let secondPress = NSDate().timeIntervalSince1970


    let diffInSeconds = secondPress - firstPress //total time difference in seconds

    let hours = diffInSeconds/60/60 //hours=diff in seconds / 60 sec per min / 60 min per hour

    if hours <= 72.0 {
        return true
    } else {
        return false
    }
}
extension String{
    var trimWhiteSpace: String{
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    var htmlStripped : String{
        let tagFree = self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        return tagFree.replacingOccurrences(of: "&[^;]+;", with: "", options: String.CompareOptions.regularExpression, range: nil)
    }
    
}

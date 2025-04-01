//
//  PasswordViewController.swift
//  Jaee2
//
//  Created by Abdulaziz  Almohsen on 6/28/17.
//  Copyright © 2017 Jaee. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NotificationBannerSwift

class PasswordViewController: UIViewController {

    @IBOutlet weak var currentpass: UITextField!
    
    @IBOutlet weak var newpass: UITextField!
    
    @IBOutlet weak var confirmnew: UITextField!
    
    
    
    
    let banner1 = NotificationBanner(title: "تمت العملية بنجاح", subtitle: "تم تغير كلمة المرور بنجاح", style: .success)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func changeTapped(_ sender: Any) {
        
        
        if (newpass.text?.characters.count)! < 6 || (confirmnew.text?.characters.count)! < 6 || currentpass.text == "" || newpass.text == "" || confirmnew.text == ""
        {
            //Swhos the error if the password is invalid, as an example is using an alert view but you can show it anyway you want
            let alert = UIAlertController(title: "تغير كلمه المرور", message: "يجب تطابق كلمه السر الجديده مع بعض وتتكون من ٦ ارفام او احرف او اكثر", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else {
        
            
            
            let param = ["current":"\(currentpass.text!)",
                "new_pass":"\(newpass.text!)",
                "confirm_pass":"\(confirmnew.text!)",
                "driver_id":"\(UserDataSingleton.sharedDataContainer.user_id!)"]
            let urlStr = "http://jaeeapp.com/api/password"
            let url = URL(string: urlStr)
            
            
            let user = "apiuser"
            let password = "ApiAuthPass2017"
            
            
            
            var headers: HTTPHeaders = [
                "Authorization": "Basic YXBpdXNlcjpBcGlBdXRoUGFzczIwMTchQCM="
            ]
            
            
            Alamofire.request(url!, method: .post, parameters: param,encoding: URLEncoding.default, headers: headers).responseJSON { response in
                print(response.result.debugDescription)

                if let value: AnyObject = response.result.value as AnyObject? {
                    //Handle the results as JSON
                    
                    
                    let usertoken = JSON(value)
                    
                    if usertoken == ["تم تغيير كلمة المرور بنجاح"] {
                        self.banner1.show()

                        
                    } else {
                        let alert = UIAlertView()
                        alert.title = " لم تتم العملية بنجاح !"
                        alert.message = "لم يتم تغيير كلمة المرور بنجاح ، الرجاء التاكد من بيناتك"
                        alert.addButton(withTitle: "تاكد")
                        alert.show()
                    }
                    
                    switch response.result {
                    case .success: break
                        
                        
                    case .failure(let error): break
                        
                    }
                }
            }
        }
        
        
    }
}
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return false to ignore.
    {
        textField.resignFirstResponder()
        return true
    }
    
    
    

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
    //
    
    
}


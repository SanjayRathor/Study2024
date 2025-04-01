//
//  LoginViewController.swift
//  Jaee2
//
//  Created by Abdulaziz  Almohsen on 6/26/17.
//  Copyright © 2017 Jaee. All rights reserved.
//

import UIKit
import Foundation
import PasswordTextField
import TextFieldEffects
import Alamofire
import SwiftyJSON
import FormTextField
//import SkyFloatingLabelTextField

class RegisterViewController: UIViewController , UITextFieldDelegate{
    
    @IBOutlet weak var nametxt : UITextField!
    
    
    @IBOutlet weak var loginbtn: UIButton!
    
    @IBOutlet weak var mobiletxt: UITextField!

    @IBOutlet weak var passwordtxt: PasswordTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.mobiletxt.keyboardType = UIKeyboardType.numberPad
        self.mobiletxt.keyboardAppearance = .dark

    
    }

    @IBAction func registerTapped(_ sender: Any) {
     
        
        
        
        if (mobiletxt.text?.isEmpty)! == true || (nametxt.text?.isEmpty)! == true || (mobiletxt.text?.characters.count)! < 9 || (passwordtxt.text?.characters.count)! < 6 || passwordtxt.text?.isEmpty == true {
            
            let alert = UIAlertController(title: " معلومات ناقصة ", message:"الرجاء ادخال معلومات صحيحة. تآكد ان كلمة المرور تحتوى علي اكثر من ٦ ارقام او احروف", preferredStyle: .alert)
            let action = UIAlertAction(title: "اوك :) ", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)

        } else {
        
        let param = ["mobile":"\(mobiletxt.text!)",
              "password":"\(passwordtxt.text!)",
            "name":"\(nametxt.text!)"
        ]
        let urlStr = "http://jaeeapp.com/api/client/register"
        let url = URL(string: urlStr)
        
        
        let user = "apiuser"
        let password = "ApiAuthPass2017"
        
        
        
        var headers: HTTPHeaders = [
            "Authorization": "Basic YXBpdXNlcjpBcGlBdXRoUGFzczIwMTchQCM="
        ]
        
        
        Alamofire.request(url!, method: .post, parameters: param,encoding: URLEncoding.default, headers: headers).responseJSON { response in
            if let value: AnyObject = response.result.value as AnyObject? {
                //Handle the results as JSON
                
                let usertoken = JSON(value)
                print(usertoken)
                if usertoken["error"].string == "فشل في محاولة الإرسال. رقم الخطأ: 15" ||  usertoken["error"].string == "يوجد حساب مسجل مسبقا بنفس رقم الجوال" {
                    
                    
                    
                    print("cant register")
                    let alert = UIAlertController(title: " خطاء عند التسجيل  ", message:"يوجد حساب مسجل مسبقا بنفس رقم الجوال. على طول سجل دخول واذا نسيت كلنة المرور سو استرجاع", preferredStyle: .alert)
                    let action = UIAlertAction(title: "اوك :) ", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)

                    
                }
                    
                    if usertoken["success"].bool == true {
                        //  save user_id
                        
                  UserDataSingleton.sharedDataContainer.username = self.nametxt.text!
                        
                        UserDataSingleton.sharedDataContainer.user_phone = self.mobiletxt.text!
                        
                        self.performSegue(withIdentifier: "verify", sender: nil)
      
                    
                }
                
            }
        }
        
    }

        
    }
   
  
    @IBAction func backToMeal (_ sender: UITapGestureRecognizer) {
       
            
           dismiss(animated: true, completion: nil)
    }
   }

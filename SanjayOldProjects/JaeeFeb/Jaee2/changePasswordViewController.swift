//
//  changePasswordViewController.swift
//  Jaee2
//
//  Created by Abdulaziz  Almohsen on 7/3/17.
//  Copyright © 2017 Jaee. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class changePasswordViewController: UIViewController {
    
    
    
    @IBOutlet weak var passwordtxt: UITextField!

    
    @IBOutlet weak var confirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func changeTapped(_ sender: Any) {
    
        if (passwordtxt.text?.characters.count)! < 6 || (confirmPassword.text?.characters.count)! < 6  {
            //Swhos the error if the password is invalid, as an example is using an alert view but you can show it anyway you want
            let alert = UIAlertController(title: "تغير كلمه المرور", message: "يجب تطابق كلمه السر الجديده مع بعض وتتكون من ٦ ارفام او احرف او اكثر", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
            
        }
        let param = ["user_id": "\(UserDataSingleton.sharedDataContainer.user_id!)",
            "password":"\(passwordtxt.text!)",
            "confirm":"\(confirmPassword.text!)"
        ]
        let urlStr = "http://jaeeapp.com/api/client/change_pass"
        let url = URL(string: urlStr)
        let user = "apiuser"
        let password = "ApiAuthPass2017"
        
        var headers: HTTPHeaders = [
            "Authorization": "Basic YXBpdXNlcjpBcGlBdXRoUGFzczIwMTchQCM="
        ]
        
        
        Alamofire.request(url!, method: .post, parameters: param,encoding: URLEncoding.default, headers: headers).responseJSON { response in
            if let value: AnyObject = response.result.value as AnyObject? {
                
                let value = JSON(value)
                if value["success"].bool == true {
                    UserDataSingleton.sharedDataContainer.is_guest = "user"
                    // save user name
                    if let name = value["name"].string {
                    UserDataSingleton.sharedDataContainer.username = name
                    print(name)
                    }
                        // perform segue to the main
                        self.performSegue(withIdentifier: "main", sender: self)

                } else {
                    
                    if value["error"].stringValue == "تأكيد كلمة المرور غير صحيح" {
                        
                        let alert = UIAlertController(title: "حدث خطاء اثناء تحديث كلمة المرور", message: "الرجاءالتاكد من مطابقة كلمة المرور", preferredStyle: .alert)
                        let action = UIAlertAction(title: " محاولة ثانية", style: .default, handler: nil)
                        alert.addAction(action)
                        
                        self.present(alert, animated: true, completion: nil)

                        
                    } else {
          
                    let alert = UIAlertController(title: "حدث خطاء اثناء تحديث كلمة المرور", message: "الرجاء المحاولة مرة اخرى", preferredStyle: .alert)
                    let action = UIAlertAction(title: "محاولة", style: .default, handler: nil)
                    alert.addAction(action)
                    
                    self.present(alert, animated: true, completion: nil)
                  
                    }
                }
                
            } else {
                //MARK: - aleert
                
                    // code is wrong ALERT NEEDED
                let alert = UIAlertController(title: "خطاء في جلب المعلومات", message: "الرجاء التاكد من اتصالك بالشبكة", preferredStyle: .alert)
                let action = UIAlertAction(title: "محاولة ثانية", style: .default, handler: nil)
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil)
                
            }
        }
    }
    }
    


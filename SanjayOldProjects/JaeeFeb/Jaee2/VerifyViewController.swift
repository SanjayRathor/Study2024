//
//  VerifyViewController.swift
//  Jaee2
//
//  Created by Abdulaziz  Almohsen on 7/18/17.
//  Copyright © 2017 Jaee. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class VerifyViewController: UIViewController {

    @IBOutlet weak var code: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

    }
    
    
    @IBAction func codeTapped(_ sender: Any) {
        
        let param = ["mobile":"\(UserDataSingleton.sharedDataContainer.user_phone!)",
            "sms_code":"\(code.text!)"
        ]
        let urlStr = "http://jaeeapp.com/api/client/verify"
        let url = URL(string: urlStr)
        
        
        let user = "apiuser"
        let password = "ApiAuthPass2017"
        
        
        
        var headers: HTTPHeaders = [
            "Authorization": "Basic YXBpdXNlcjpBcGlBdXRoUGFzczIwMTchQCM="
        ]
        
        
        Alamofire.request(url!, method: .post, parameters: param,encoding: URLEncoding.default, headers: headers).responseJSON { response in
            if let value: AnyObject = response.result.value as AnyObject? {
                //Handle the results as JSON
                
              let data = JSON(value)
                print(data)
                if data["success"].bool == true {
                    let id = data["user_id"].stringValue
                    UserDataSingleton.sharedDataContainer.is_guest = "user"
                    UserDataSingleton.sharedDataContainer.user_id = id
                    
                    self.performSegue(withIdentifier: "main", sender: nil)
                } else
                {
                    
                    let alert = UIAlertController(title: " خطاء عند التسجيل  ", message:"الرجاء ادخال معلومات صحيحة. تآكد ان رقم الكود صحيح", preferredStyle: .alert)
                    let action = UIAlertAction(title: "اوك :) ", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                    
                    
                    
                }
            }
            
        }
}
    
    @IBAction func backTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
}

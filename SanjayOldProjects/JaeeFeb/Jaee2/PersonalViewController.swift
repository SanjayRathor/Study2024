//
//  PersonalViewController.swift
//  Jaee2
//
//  Created by Abdulaziz  Almohsen on 6/27/17.
//  Copyright © 2017 Jaee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import NotificationBannerSwift
import Alamofire
import SwiftyJSON






class PersonalViewController: UIViewController {

    @IBOutlet weak var nametxt: UITextField!
    
    @IBOutlet weak var phonetxt: UITextField!
    
    
    
    let banner = NotificationBanner(title: "تعديل معلومات" , subtitle : "تم تعديل معلوماتك بنجاح" , style: .success)
    
    
       override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        nametxt.text = UserDataSingleton.sharedDataContainer.username
        phonetxt.text = UserDataSingleton.sharedDataContainer.user_phone
        
        
 

    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
      
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func saveTapped(_ sender: Any) {
        var param = [String:String]()
        
        
    if UserDataSingleton.sharedDataContainer.lat == nil ||
        UserDataSingleton.sharedDataContainer.lng == nil  {
    
         param = ["name":"\(nametxt.text!)",
            "mobile":"\(phonetxt.text!)",
            "user_id":"\(UserDataSingleton.sharedDataContainer.user_id!)"]
        
        }
        if UserDataSingleton.sharedDataContainer.lat != nil &&
            UserDataSingleton.sharedDataContainer.lng != nil  {
            
             param = ["name":"\(nametxt.text!)",
                "mobile":"\(phonetxt.text!)",
                "lat":"\(UserDataSingleton.sharedDataContainer.lat!)",
                "lng":"\(UserDataSingleton.sharedDataContainer.lng!)",
                "user_id":"\(UserDataSingleton.sharedDataContainer.user_id!)"]
            
        }
        let urlStr = "http://jaeeapp.com/api/client/update_profile"
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
                let data = JSON(value)
                
                if data["success"].bool == true {
                    
                    UserDataSingleton.sharedDataContainer.user_phone = self.phonetxt.text
                    UserDataSingleton.sharedDataContainer.username = self.nametxt.text
                    
                    self.banner.show()

                    
                } else {
                    
                    let alert = UIAlertController(title: "تغير معلومات", message: "حدث خطاء اثناء تغير المعلومات. الرجاء التآكد من صحه المعلومات", preferredStyle: .alert)
                    let action = UIAlertAction(title: "معاودة", style: .default, handler: nil)
                    alert.addAction(action)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
                
                
                
            }
        }
        
        
        
        
    }
    
        
    }


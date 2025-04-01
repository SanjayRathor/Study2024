//
//  updateLocationViewController.swift
//  Jaee2
//
//  Created by Abdulaziz  Almohsen on 7/4/17.
//  Copyright © 2017 Jaee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire
import SwiftyJSON
import TextFieldEffects
import NotificationBannerSwift

class updateLocationViewController: UIViewController {
    
    // variable 
    var name = ""
    var mobile = ""
    var currentcity = ""
    // map manager  
    
    // outlet
    
    
    @IBOutlet weak var nametxt: UITextField!
    @IBOutlet weak var phonetxt: UITextField!
    
    let banner = NotificationBanner(title: "تمت العملية بنجاح", subtitle: "تم تغير الاسم ورقم الجوال بنجاح", style: .success)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nametxt.text = UserDataSingleton.sharedDataContainer.username
        phonetxt.text = UserDataSingleton.sharedDataContainer.user_phone
      
        
        self.hideKeyboardWhenTappedAround()
        phonetxt.keyboardType = UIKeyboardType.numberPad


         }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "updateLocation")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])

        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
   
    @IBAction func saveData(_ sender: Any) {
        print(UserDataSingleton.sharedDataContainer.user_id!)
        
        if (phonetxt.text?.characters.count)! > 9 && nametxt.text != "" {
        print("good")
        
        let param = ["user_id":"\(UserDataSingleton.sharedDataContainer.user_id!)",
        "name":"\(nametxt.text!)",
        "email":"",
        "mobile":"\(phonetxt.text!)",
         "":"",
         "address":"\(UserDataSingleton.sharedDataContainer.address!)",
         "lat":"\(UserDataSingleton.sharedDataContainer.lat!)",
         "lng":"\(UserDataSingleton.sharedDataContainer.lng!)"
        ]
        let urlStr = "http://jaeeapp.com/api/client/update_profile"
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
                    
                    
                    UserDataSingleton.sharedDataContainer.user_phone = self.phonetxt.text!
                    UserDataSingleton.sharedDataContainer.username = self.nametxt.text!
                    self.banner.show()

                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) {
                        
                        self.performSegue(withIdentifier: "tosubmit", sender: self)
                        
                        
                    }                }
                
            }
        }
        } else {
            
            // fix your info nigga
            print("fix your shit")
            let alert = UIAlertController(title: "البيانات مهمة", message:"اسمك ورقم جوالك مهمة بالنسبة لنا ، الرجاء ادخال اسم ورقم جوال صحيح 😚", preferredStyle: .alert)
            let action = UIAlertAction(title: "اوك :) ", style: .default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

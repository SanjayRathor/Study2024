//
//  AddItemViewController.swift
//  Jaee2
//
//  Created by Abdulaziz  Almohsen on 11/23/17.
//  Copyright © 2017 Jaee. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AddItemViewController: UIViewController {
  
    
    @IBOutlet weak var qytLab : UILabel!
    
    @IBOutlet weak var nameofItem: UITextField!
    
    @IBOutlet weak var priceofItem: UITextField!
    
    
    
    
    var qty = "1"

   
 
    
    
    var price = 0
    var name = ""
    var qtyItem = 1
    
    
    // variables
    
    var passedValue = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        qytLab.text = "1"
        priceofItem.keyboardType = UIKeyboardType.numberPad

  
        // Do any additional setup after loading the view.
    }
    

    @IBAction func backBit(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
        
        print(qty)
    }
    @IBAction func plusTapped(_ sender: Any) {
        
        let new = Int(qty)! + 1
        
        qytLab.text = String(new)
        
        qty = String(new)
    }
    @IBAction func reducedTapped(_ sender: Any) {
        
        if qytLab.text == "1" {
            qytLab.text = "1"
            
            qty = "1"
            
            
        } else {
            
            let new = Int(qty)! - 1
            
            qytLab.text = String(new)
            
            qty = String(new)
        }
    }
    
    @IBAction func addPressed(_ sender: Any) {
        
        
        if  UserDataSingleton.sharedDataContainer.is_guest == "guest" || UserDataSingleton.sharedDataContainer.is_guest == nil {
            
            self.performSegue(withIdentifier: "login", sender: self)
            UserDataSingleton.sharedDataContainer.previous = passedValue
            return
        }
        
        
        
        
        
 
        if nameofItem.text == "" || priceofItem.text == "" || nameofItem.text == nil   || priceofItem.text == nil || priceofItem.text?.isNumeric == false {
            print("complete info")
            // windown plz complete info
            let alert = UIAlertController(title: "", message: "لم يتم كتابه اي معلومة. تاكد من اسن المنتج والسعر بالارقام الانجليزية(1,2,3..)", preferredStyle: .alert)
            let action = UIAlertAction(title: "رجوع", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
            
        } else {
            
            print("complete ")

            self.price = Int(priceofItem.text!)!
            self.name = nameofItem.text!
            self.qtyItem = Int(qytLab.text!)!
            
        let urlStr = "http://jaeeapp.com/api/client/cartAdd"
        let url = URL(string: urlStr)
        let para = ["name": "\(self.name)",
            "price": "\(self.price)",
                    "qty": "\(self.qtyItem)",
                  "desc" :"custom",
                    "client_id":"\(UserDataSingleton.sharedDataContainer.user_id!)",
                    "family_id":"\(passedValue)"]
        
        print(para)
        
        let user = "apiuser"
        let password = "ApiAuthPass2017!@#"
        
        
        
        var headers: HTTPHeaders = [
            "Authorization": "Basic YXBpdXNlcjpBcGlBdXRoUGFzczIwMTchQCM="
        ]
        
        
        Alamofire.request(url!, method: .post, parameters: para,encoding: URLEncoding.default, headers: headers).responseJSON { response in
            if let value : AnyObject = response.result.value as AnyObject {

                let data = JSON(value)
                print(data)
                if data["success"].boolValue == true {
                    self.dismiss(animated: true, completion: nil)
                 // good added
                } else {
                    
                    if data["error"].stringValue == "عفوا، لا يمكنك الطلب من أكثر من متجر في نفس الطلب" {
                    print("error adding item ")
                        
                        let alert = UIAlertController(title: "طلبين مختلفين", message: "عفوا، لا يمكنك الطلب من أكثر من محل في نفس الطلب", preferredStyle: .alert)
                        let action = UIAlertAction(title: "رجوع", style: .default, handler: nil)
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                        return
                        
                        
                    } else {
                        
                        
                        if data["error"].stringValue == "عفوا، لا يمكنك تقديم اكثر من طلب بنفس الوقت" {
                            print("error adding item ")
                            let alert = UIAlertController(title: "لديك طلب جاري في السلة", message: "عفوا، لا يمكنك تقديم اكثر من طلب بنفس الوقت", preferredStyle: .alert)
                            let action = UIAlertAction(title: "رجوع", style: .default, handler: nil)
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: nil)
                            return

            }
        }
        
    }
   
    }
            }
    

}

}
}
extension String {
    var isNumeric: Bool {
        guard self.characters.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self.characters).isSubset(of: nums)
    }
}

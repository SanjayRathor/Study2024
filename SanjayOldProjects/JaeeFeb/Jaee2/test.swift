
//
//  TestViewController.swift
//  Jaee2
//
//  Created by Abdulaziz  Almohsen on 7/2/17.
//  Copyright © 2017 Jaee. All rights reserved.
//

import UIKit
import VoucherifySwiftSdk
import Alamofire
import SwiftyJSON

class test: UIViewController {
    var client: VoucherifyClient?
    

 
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        let url =  "https://api.voucherify.io/v1/vouchers/Jaee0pQiLjjh/redemption"
        
        let para: [String: Any] = [
            "order": [
                "amount": 28.00

            ]
        ]
        
        let headers = [
            "X-App-Id" : "3362ed72-c26d-4941-9159-272e57cd214e",
            "X-App-Token" : "8c02412d-7603-4923-9135-d083187b9a53",
            "Content-Type" : "application/json"]
        Alamofire.request(url, method: .post, parameters: para,encoding: JSONEncoding.default , headers: headers).responseJSON { response in
            
            if let value : AnyObject = response.result.value as AnyObject {
                
                let discountData = JSON(value)
                
                print(discountData)
                if discountData["message"].stringValue == "Resource not found" ||
                    discountData["message"].stringValue == "voucher is disabled" ||
                    discountData["message"].stringValue == "quantity exceeded" ||
                discountData["message"].stringValue == "quantity exceeded" ||
                discountData["message"].stringValue == "voucher_not_active" ||
                discountData["message"].stringValue == "voucher_expired"  {
                    
                    print("not valid")
                } else {
                    for (key,subJson):(String, JSON) in discountData {
                        
                        switch subJson["discount"]["type"].stringValue {
                        case "PERCENT" :
                            
                            print("its precent")
                            let afterDiscount = discountData["order"]["discount_amount"].intValue
                            
                            
                        case "AMOUNT" :
                            print("its amount")

                        default :
                            
                            print("not present or amount")
                        }
                        

                    
                }
                
            }
       
        }
        
        
        
        
    }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    
    }
    
    // MARK: Navigation
    
  
}

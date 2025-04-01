//
//  LoginViewController.swift
//  Jaee2
//
//  Created by Abdulaziz  Almohsen on 7/2/17.
//  Copyright © 2017 Jaee. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import JTMaterialSpinner


class LoginViewController: UIViewController {

    @IBOutlet weak var mobiletxt: UITextField!
    @IBOutlet weak var top: NSLayoutConstraint!
    @IBOutlet weak var cancelLb: UILabel!
    @IBOutlet weak var forgotLab: UILabel!
    @IBOutlet weak var loginbtn: UIButton!
    @IBOutlet weak var passwordtxt: UITextField!
    
    
    var spinnerView = JTMaterialSpinner()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        mobiletxt.keyboardType = UIKeyboardType.numberPad
        self.hideKeyboardWhenTappedAround()

        
        
        self.view.addSubview(spinnerView)
        spinnerView.frame = CGRect(x: (375.0 - 50.0) / 2.0, y: 300, width: 50, height: 50)
        
        spinnerView.circleLayer.lineWidth = 2.0
        spinnerView.circleLayer.strokeColor = UIColor.orange.cgColor
        spinnerView.endRefreshing()
        spinnerView.animationDuration = 2.5

        
        // Do any additional setup after loading the view.
    }

   
    
   
    @IBAction func forgotTapped(_ sender: UITapGestureRecognizer) {

        if passwordtxt.isHidden == false {

        passwordtxt.isHidden = true
            loginbtn.setTitle("ارسل", for: .normal)

            forgotLab.isHidden = true
            top.constant = -50
            
            cancelLb.isHidden = false
        } else {
             if passwordtxt.isHidden == true  {

            forgotLab.isHidden = false

            if passwordtxt.isHidden == true {
                
                passwordtxt.isHidden = false
                cancelLb.isHidden = true
            }
        }
        
        }
        
    }

    @IBAction func cancelTapped(_ sender: Any) {
        loginbtn.setTitle("دخول", for: .normal)

        cancelLb.isHidden = true
        forgotLab.isHidden = false

        if passwordtxt.isHidden == true {
            
            passwordtxt.isHidden = false
            
            top.constant = 50

        
    }
    }
    
    @IBAction func loginANDreturnTapped(_ sender: Any) {
        self.spinnerView.beginRefreshing()

        if passwordtxt.isHidden == true {
            

            let param = ["mobile":"\(mobiletxt.text!)"
            ]
            let urlStr = "http://jaeeapp.com/api/client/forgot"
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
                    
                    if usertoken["success"].bool == false {
                        print("cant register")
                        
                    } else {
                        
                        if usertoken["error"].string == "لا يوجد حساب بهذا الرقم" {
                           
                            let alert = UIAlertController(title: "استرجاع كلمه المرور", message:"رقم الجوال غير مسجل لدينا. الرجاء التآكد من رقم جوالك", preferredStyle: .alert)
                            let action = UIAlertAction(title: "اوك :) ", style: .default, handler: nil)
                            alert.addAction(action)
                            
                            self.present(alert, animated: true, completion: nil)                        } else {
                            
                            if usertoken["success"].bool == true {
                                UserDataSingleton.sharedDataContainer.user_id = String( usertoken["user_id"].int!)
                                UserDataSingleton.sharedDataContainer.user_phone = self.mobiletxt.text
                                UserDataSingleton.sharedDataContainer.code = String(describing: usertoken["code"].int!)
                          
                                
                                
                                self.performSegue(withIdentifier: "verifyCode", sender: self)
                                
                                }
                        
                        }
                        
                       

                    }
                
                } else {
                    print("probelm with response")
                }
            }
            
        } else {
            
            if passwordtxt.isHidden == false {
                
                
                
                print("login")
                
                let param = ["mobile": "\(mobiletxt.text!)",
                    "password":"\(passwordtxt.text!)"
                ]
                let urlStr = "http://jaeeapp.com/api/client/login"
                let url = URL(string: urlStr)
                let user = "apiuser"
                let password = "ApiAuthPass2017"
                
                var headers: HTTPHeaders = [
                    "Authorization": "Basic YXBpdXNlcjpBcGlBdXRoUGFzczIwMTchQCM="
                ]
                
                
                Alamofire.request(url!, method: .post, parameters: param,encoding: URLEncoding.default, headers: headers).responseJSON { response in
                    if let value: AnyObject = response.result.value as AnyObject? {
                        //Handle the results as JSON
                        print(response)
                        let usertoken = JSON(value)
                        
                        
                        if usertoken["disable"].stringValue == "0" && usertoken["role"].stringValue == "client" {

                            let user_id = String(usertoken["id"].int!)
                            let user_name = usertoken["name"].stringValue
                            
                            UserDataSingleton.sharedDataContainer.is_guest = "user"
                            
                            UserDataSingleton.sharedDataContainer.user_id = user_id
                            UserDataSingleton.sharedDataContainer.username = user_name
                            UserDataSingleton.sharedDataContainer.user_phone = self.mobiletxt.text!
                            
                            
               self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                            
                        } else {
                      
                            let alert = UIAlertController(title: "", message:"تاكد انك مسجل والآرقام تكون بالآنجليزي. واذا ماسجلت سجل معنا ترى ماياخذ وقت", preferredStyle: .alert)
                            let action = UIAlertAction(title: "اوك :) ", style: .default, handler: nil)
                            alert.addAction(action)
                            
                            self.present(alert, animated: true, completion: nil)

                          
                        }
                        
                        DispatchQueue.main.async {
                            self.spinnerView.endRefreshing()
                            
                            
                        }

                    } else {
                        
                        print("problem with getting response")
                       
                    }
            }
        }
        
        }
    }
    @IBAction func back(_ sender: UITapGestureRecognizer) {
        
        
        dismiss(animated: true, completion: nil)
    }
    
}

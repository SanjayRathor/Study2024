//
//  CodeViewController.swift
//  Jaee2
//
//  Created by Abdulaziz  Almohsen on 7/3/17.
//  Copyright © 2017 Jaee. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CodeViewController: UIViewController {

    @IBOutlet weak var code: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
    }

  
    @IBAction func codeTapped(_ sender: Any) {
        
        
        if code.text == UserDataSingleton.sharedDataContainer.code! {
          performSegue(withIdentifier: "changepass", sender: self)
            
        } else {
            
            
            print(UserDataSingleton.sharedDataContainer.code)
            print(code.text!)
        }
    }
    
   }

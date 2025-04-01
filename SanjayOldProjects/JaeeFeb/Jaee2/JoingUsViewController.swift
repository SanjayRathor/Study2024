//
//  JoingUsViewController.swift
//  Jaee2
//
//  Created by Abdulaziz  Almohsen on 12/12/17.
//  Copyright © 2017 Jaee. All rights reserved.
//

import UIKit

class JoingUsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func twitterTapped(_ sender: Any) {
        
        twitterGet()
        
    }
    
    
    func twitterGet () {
        let url = URL(string: "twitter:///user?screen_name=getJaee")
        UIApplication.shared.open(url!, options: [:], completionHandler: {
            (success) in
            print("Open \(String(describing: url)): \(success)")
        })
        
    }

}

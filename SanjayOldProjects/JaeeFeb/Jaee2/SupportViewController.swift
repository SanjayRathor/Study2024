//
//  SupportViewController.swift
//  Jaee2
//
//  Created by Abdulaziz  Almohsen on 7/18/17.
//  Copyright © 2017 Jaee. All rights reserved.
//

import UIKit

class SupportViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func bakcTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

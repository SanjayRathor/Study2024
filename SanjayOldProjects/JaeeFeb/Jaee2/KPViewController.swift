//
//  KPViewController.swift
//  Jaee2
//
//  Created by Abdulaziz  Almohsen on 11/16/17.
//  Copyright © 2017 Jaee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var lblAddress: UILabel!
    
    @IBAction func searchAddress(sender: UIButton){
        let mapVc = UIStoryboard.init(name: "KPLocation", bundle: nil).instantiateInitialViewController() as! KPMapVC
        mapVc.callBackBlock = {[weak self] address in
            self?.lblAddress.text = address.address
        }
        self.present(mapVc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



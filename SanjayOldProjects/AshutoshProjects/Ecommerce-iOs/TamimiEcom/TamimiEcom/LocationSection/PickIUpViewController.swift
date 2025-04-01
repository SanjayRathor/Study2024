//
//  PickIUpViewController.swift
//  TamimiEcom
//
//  Created by Ansh on 18/09/20.
//  Copyright © 2020  ltd. All rights reserved.
//

import UIKit

class PickIUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func clickAndCollect(_ sender: Any) {
        let objLocation : LocationViewController = LocationViewController(nibName: "LocationViewController", bundle: nil)
        objLocation.delegete = self
        self.navigationController?.pushViewController(objLocation, animated: true)
        
    }
    @IBAction func homeDeliveryAction(_ sender: Any) {
        //
        let objLocation : HomeDellivery = HomeDellivery(nibName: "HomeDellivery", bundle: nil)
        objLocation.delegate = self
        self.navigationController?.pushViewController(objLocation, animated: true)
    }
    

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension PickIUpViewController : ContinueActionLocationViewController {
    func continueAction() {
           self.navigationController?.popViewController(animated: true)
       }
       
}
extension PickIUpViewController : ContinueHomeDelliveryAction {
    func continueActionHomeDellivery() {
        self.navigationController?.popViewController(animated: true)
    }
    }

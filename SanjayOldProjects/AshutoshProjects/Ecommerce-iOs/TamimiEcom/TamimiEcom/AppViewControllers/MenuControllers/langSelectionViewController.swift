//
//  langSelectionViewController.swift
//  TamimiEcom
//
//  Created by Ansh on 04/09/20.
//  Copyright © 2020  ltd. All rights reserved.
//

import UIKit
protocol CloseLanguage : class  {
    func closeActionFull()
}
class langSelectionViewController: UIViewController {
    weak var delegate:CloseLanguage?
    @IBOutlet weak var btnCloseSmall: UIButton!
    
    @IBOutlet weak var btnCloseFull: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }
    func updateUI() {
        
         if self.delegate == nil {
                    self.btnCloseFull.isHidden = true
                }else {
            self.btnCloseFull.isHidden = false
                    self.btnCloseSmall.isHidden = true
            self.view.backgroundColor = UIColor.clear

                }
    }
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func closeFullView(_ sender: Any) {
        self.delegate?.closeActionFull()
    }
    
}

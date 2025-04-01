//
//  MainViewController.swift
//  TamimiEcom
//
//  Created by Ansh on 23/08/20.
//  Copyright © 2020  . All rights reserved.
//

import UIKit
import LGSideMenuController


class MainViewController: LGSideMenuController {

    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        leftViewPresentationStyle = .slideAbove
        rightViewPresentationStyle = .slideAbove
         let w = UIScreen.main.bounds.size.width
            if w > 375 {
        leftViewWidth = UIScreen.main.bounds.size.width * 0.7
        rightViewWidth = UIScreen.main.bounds.size.width * 0.7
            }else {
                leftViewWidth = UIScreen.main.bounds.size.width * 0.85
                rightViewWidth = UIScreen.main.bounds.size.width * 0.85
            }
        rightViewSwipeGestureRange = LGSideMenuSwipeGestureRangeMake(rightViewWidth, rightViewWidth);
  
    }
    override func viewWillAppear(_ animated: Bool) {
        print("working")
    }

}

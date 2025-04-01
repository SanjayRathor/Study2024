//
//  SRWelcomeViewController.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 05/10/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit

class SRWelcomeViewController: UIViewController {
    @IBOutlet weak var welcomeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      welcomeButton.setGradientImage(for: .normal)
        // Do any additional setup after loading the view.
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "welcomeScreenSegue") {
            SRApplicationStates.setUserOpenedFirstTime()
        }
    }

}

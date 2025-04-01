//
//  KnockKnockViewController.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 06/10/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit
import Repeat

class KnockKnockViewController: UIViewController {
    private var timerInstance: Repeater? = nil
    
    var counter = 6
    @IBOutlet weak var skipButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.skipButton.setTitle("Skip \( self.counter )", for: .normal)
        self.timerInstance =  Repeater.every(.seconds(1), count: 6) { repeater  in
            DispatchQueue.main.async {
                self.counter = self.counter-1;
                self.skipButton.setTitle("Skip \( self.counter )", for: .normal)
                if (repeater.state == .finished) {
                    AppCoordinator.showDashBoardController()
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.timerInstance?.pause()
        self.timerInstance = nil
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func skipButtonDidClicked(_ sender: Any) {
        timerInstance?.pause()
        AppCoordinator.showDashBoardController()
    }
}

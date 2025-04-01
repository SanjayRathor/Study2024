//
//  WelcomeViewController.swift
//  Jaee2
//
//  Created by Abdulaziz  Almohsen on 7/9/17.
//  Copyright © 2017 Jaee. All rights reserved.
//

//
import SwiftVideoBackground
import UIKit

class WelcomeViewController : UIViewController {

    @IBOutlet weak var videoView: BackgroundVideo!
    override func viewDidLoad() {
        super.viewDidLoad()
        videoView.createBackgroundVideo(name: "JaeeLaunch", type: "mp4")
   

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   
    
    
}


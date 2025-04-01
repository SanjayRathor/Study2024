//
//  ViewController.swift
//  SwiftStudy
//
//  Created by Sanjay Singh Rathor on 07/01/17.
//  Copyright © 2017 Times Mobile Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var message: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let queue = DispatchQueue(label: "com.swiftpal.dispatch.qos", attributes: .concurrent)
        // async with userInitiated type
        queue.async(qos: .userInitiated) {
            self.message.text = "userInitiated - "
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
  //  The following function is returning another function as its result which can be later assigned to a variable and called.
    func jediTrainer () -> ((String, Int) -> String) {
        func train(name: String, times: Int) -> (String) {
            return "\(name) has been trained in the Force \(times) times"
        }
        return train
    }
  //  let train = jediTrainer()
   // train("Obi Wan", 3)


}


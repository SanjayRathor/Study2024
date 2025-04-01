//
//  ViewController.swift
//  SwiftUIKIT
//
//  Created by Sanjay Singh Rathor on 31/10/20.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBSegueAction func swiftUIClicked(_ coder: NSCoder) -> UIViewController? {
        UIHostingController.init(coder: coder, rootView: ContentView())
    }
}


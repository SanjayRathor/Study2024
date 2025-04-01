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
    }
    
    @IBSegueAction func swiftUIClicked(_ coder: NSCoder) -> UIViewController? {
        UIHostingController.init(coder: coder, rootView: ContentView())
    }
}

struct ViewControllerRepresentation:
    UIViewControllerRepresentable {
    
    func makeUIViewController(
        context: UIViewControllerRepresentableContext <ViewControllerRepresentation>) -> ViewController {
        
        UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "ViewController")
            as! ViewController
    }
    
    func updateUIViewController(_ uiViewController: ViewController,
                                context: UIViewControllerRepresentableContext
                                <ViewControllerRepresentation>) {
    }
    
}


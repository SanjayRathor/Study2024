//
//  SRBaseViewController.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 02/10/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit
import SVProgressHUD

enum ControllerState {
    case loading
    case showingData(Any)
    case empty
    case error(Any)
}

class SRBaseViewController: UIViewController {
    private let activityIndicator = UIActivityIndicatorView(style: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addActivityView()
    }
}

extension SRBaseViewController {
    
    func addActivityView () {
        
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func presenActivity() {
        activityIndicator.isHidden = true;
        activityIndicator.startAnimating()
    }
    
    func dismissActivity() {
        activityIndicator.isHidden = false;
        activityIndicator.stopAnimating()
    }
    
    func presentCustomActivity() {
        DispatchQueue.main.async {
            SVProgressHUD.show()
        }
    }
    
    func dismissCustomActivity() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
    
    func presentWithError(_ error: Error) {
        let alert = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .cancel))
        present(alert, animated: true)
    }
    
    func presentWithMessage(_ errorMessage: NSString) {
        let alert = UIAlertController(title: "", message: errorMessage as String, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .cancel))
        present(alert, animated: true)
    }
    
    public func shareTapped(shareString: String) {
        let string = "Fandom Live!"
        if let url = URL(string: shareString) {
            let activityViewController =
                UIActivityViewController(activityItems: [string, url],
                                         applicationActivities: nil)
            present(activityViewController, animated: true) {
                
            }
        }
    }
}

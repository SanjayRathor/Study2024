//
//  FandomWebViewController.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 16/01/20.
//  Copyright © 2020 Sanjay Singh Rathor. All rights reserved.
//

import UIKit

class FandomWebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    var requestURL:String = ""
    var titleNameText:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = titleNameText

        webView.delegate = self
        loadURL(requestURL)
    }

    private func loadURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            let req = URLRequest(url: url)
            webView.loadRequest(req)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if webView.isLoading {
            webView.stopLoading()
        }
    }
}

extension FandomWebViewController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        return true
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.navigationItem.title = titleNameText
        indicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        indicator.stopAnimating()
    }

    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        indicator.stopAnimating()
    }
}


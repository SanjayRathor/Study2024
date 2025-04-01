//
//  WebViewViewController.swift
//  TamimiEcom
//
//  Created by Ansh Kumar on 21/09/20.
//  Copyright © 2020  ltd. All rights reserved.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController,WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndi: UIActivityIndicatorView!
    var directUrlPath = ""
    var isTamilMemberPage = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.webView.navigationDelegate = self
        if !directUrlPath.isEmpty {
            print(directUrlPath)
            self.openDirectPage()
        }
        else if isTamilMemberPage {
            self.openTamilMemberPage()
        }else {
            self.openTermsPage()
        }
    }
    func openDirectPage() {
           self.activityIndi.startAnimating()
           self.activityIndi.isHidden = false
        self.webView.load(NSURLRequest(url: NSURL(string: self.directUrlPath)! as URL) as URLRequest)
       DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                  // your function here
                  self.hideIndi()
              }
       }
    func openTamilMemberPage() {
        self.activityIndi.startAnimating()
        self.activityIndi.isHidden = false
        self.webView.load(NSURLRequest(url: NSURL(string: "https://tamimimarkets.com/members/")! as URL) as URLRequest)
    DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
               // your function here
               self.hideIndi()
           }
    }
    func openTermsPage() {
        self.activityIndi.startAnimating()
               self.activityIndi.isHidden = false
        self.webView.load(NSURLRequest(url: NSURL(string: "https://shop.tamimimarkets.com/terms-condition?mob=true")! as URL) as URLRequest)
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            // your function here
            self.hideIndi()
        }
    }
    func hideIndi() {
           self.activityIndi.isHidden = true
           self.activityIndi.stopAnimating()
       }
    //Equivalent of webViewDidFinishLoad:
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("didFinish - webView.url: \(String(describing: webView.url?.description))")
        self.activityIndi.isHidden = true
        self.activityIndi.stopAnimating()
    }
    
    @IBAction func backAction(_ sender: Any) {
           self.navigationController?.popViewController(animated: true)
       }

}

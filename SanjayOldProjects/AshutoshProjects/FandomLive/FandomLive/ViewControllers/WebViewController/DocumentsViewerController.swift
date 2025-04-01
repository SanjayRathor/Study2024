//
//  DocumentsViewerController.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 17/01/20.
//  Copyright © 2020 Sanjay Singh Rathor. All rights reserved.
//

import UIKit

class DocumentsViewerController: SRBaseViewController {

    @IBOutlet weak var downloadButton: UIBarButtonItem!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    var requestURL:String = ""
    var titleNameText:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadButton.isEnabled = false;
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
    
    @IBAction func downloadButtonDidClicked(_ sender: Any) {
        
        guard let url = URL(string: requestURL) else { return }
        self.presentCustomActivity()
          let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
              let downloadTask = urlSession.downloadTask(with: url)
              downloadTask.resume()
    }
    
}

extension DocumentsViewerController:  URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("downloadLocation:", location)
        
        self.dismissCustomActivity()
        // create destination URL with the original pdf name
        guard let url = downloadTask.originalRequest?.url else { return }
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent(url.lastPathComponent)
        // delete original copy
        try? FileManager.default.removeItem(at: destinationURL)
        // copy from temp to Document
        self.showAlertWith(title:"", message:AlertMessages.DownloadedMsg)
        do {
            try FileManager.default.copyItem(at: location, to: destinationURL)
        } catch let error {
            print("Copy Error: \(error.localizedDescription)")
        }
    }
}




extension DocumentsViewerController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        return true
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.navigationItem.title = titleNameText
        indicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        indicator.stopAnimating()
        downloadButton.isEnabled = true;
    }

    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        indicator.stopAnimating()
    }
}


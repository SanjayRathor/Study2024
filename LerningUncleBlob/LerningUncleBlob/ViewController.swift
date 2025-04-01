//
//  ViewController.swift
//  LerningUncleBlob
//
//  Created by Sanjay Singh Rathor on 24/01/22.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        let request =  URLRequest.init(url: URL(string: "asdasd")!)
        let client = HTTPClientSessionClient.init(session: URLSession.init(configuration: .default))
        _ = client.dispatch(request) {result in
            switch result {
            case .success((let data, let response)):
                print("\(data) unread messages.\(response)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


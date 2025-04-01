//
//  ViewController.swift
//  MSALSample
//
//  Created by Sanjay Rathor on 04/12/24.
//

import UIKit
import MSAL

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let config = MSALPublicClientApplicationConfig(clientId: "<your-client-id-here>")
        let scopes = ["your-scope1-here", "your-scope2-here"]
                
        if let application = try? MSALPublicClientApplication(configuration: config) {
                    
            let viewController = self
            let webviewParameters = MSALWebviewParameters(authPresentationViewController: viewController)
            
            let interactiveParameters = MSALInteractiveTokenParameters(scopes: scopes, webviewParameters: webviewParameters)
            application.acquireToken(with: interactiveParameters, completionBlock: { (result, error) in
                        
            guard let authResult = result, error == nil else {
                print(error!.localizedDescription)
                return
            }
                        
            // Get access token from result
            let accessToken = authResult.accessToken
                        
            // You'll want to get the account identifier to retrieve and reuse the account for later acquireToken calls
            let accountIdentifier = authResult.account.identifier
            })
        }
        else {
            print("Unable to create application.")
        }
    }


}


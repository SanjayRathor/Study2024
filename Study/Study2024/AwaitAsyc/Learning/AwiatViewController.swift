//
//  AwiatViewController.swift
//  Study2024
//
//  Created by Sanjay Rathor on 19/08/24.
//

import UIKit
import SwiftUI

class AwiatViewController: UIViewController {
    
    private var viewModel = UserProfileViewModel()
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileDataLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         Task {
         do {
         let userProfile = try await viewModel.fetchUserInfo()
         await MainActor.run {
         self.profileDataLabel.text = userProfile.username
         }
         }
         catch(let err) {
         print("encountered the error => \(err)")
         }
         }
         print("start the execution")
         }
         */
        
    }
}

//
//  SRLoginViewController.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 05/10/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit
import SVProgressHUD

class SRLoginViewController: UIViewController , KeyboardProtocol {
    var scrollView: UIScrollView!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView = tableView
        
        self.hideKeyboardWhenTappedAround()
        self.registerForKeyboardNotification()
        
    }
    
    func forgotPassowrdDidClicked() {
    }
    
    @IBAction func signupDidClicked() {
        
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}

extension SRLoginViewController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return self.tableView.bounds.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SRSignTableViewCell", for: indexPath) as? SRSignTableViewCell else {
            fatalError("couldn't deque cell with identifier")
        }
        
        cell.clickValue = { actionType in
            switch actionType {
            case .forgotPasswordAction:
                self.forgotPassowrdDidClicked()
                break;
            case .loginAction:
                self.loginDidClicked()
                break;
            case .facebookAction:
                self.facebookDidClicked()
                break;
            case .googleAction:
                self.googleDidClicked()
                break;
            case .signupAction:
                self.signupDidClicked()
                break;
            }
        }
        return cell
    }
}

extension SRLoginViewController {
    
    func loginDidClicked() {
        let tableCell =  self.tableView .cellForRow(at: IndexPath.init(row: 0, section: 0)) as! SRSignTableViewCell
        
        let  email = tableCell.emailLabel.text!
        let  password = tableCell.passworLabel.text!
        let loginUser = LoginUser(email: email, password: password)
        if let errorMessage = loginUser.validateFields() {
            self.showAlertWith(title: "", message: errorMessage)
            return
        }
        
        let loginprovider =  SRLoginProvider()
        loginprovider.login(provider: EmailLoginProvider(parentController: self, user: loginUser), completionRequest: { (userInfoModel) in
            SRApplicationStates.setUserLoggedIn()
            RepositoryManager.shared.saveProfileFor(user: userInfoModel)
            AppCoordinator.showDashBoardController()
            
        }) { ( err) in
            self.showAlertWith(title: "", message: err?.localizedDescription ?? AlertMessages.GeneralErrorMsg)
        }
    }
    
    func facebookDidClicked() {
        
        let loginprovider =  SRLoginProvider()
        loginprovider.login(provider: FacebookProvider(parentController: self), completionRequest: { (userInfoModel) in
            
            SRApplicationStates.setUserLoggedIn()
            RepositoryManager.shared.saveProfileFor(user: userInfoModel)
            AppCoordinator.showDashBoardController()
            
        }) { ( err) in
            self.showAlertWith(title: "", message: err?.localizedDescription ?? AlertMessages.GeneralErrorMsg)
        }
    }
    
    func googleDidClicked() {
        
        let loginprovider =  SRLoginProvider()
        loginprovider.login(provider: GoogleProvider(parentController: self), completionRequest: { (userInfoModel) in
            
            SRApplicationStates.setUserLoggedIn()
            RepositoryManager.shared.saveProfileFor(user: userInfoModel)
            AppCoordinator.showDashBoardController()
            
        }) { ( err) in
            self.showAlertWith(title: "", message: err?.localizedDescription ?? AlertMessages.GeneralErrorMsg)
        }
    }
}

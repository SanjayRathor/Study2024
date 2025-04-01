//
//  MyAccountViewController.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 06/10/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit

class MyAccountViewController: UITableViewController {
    var profileImage: UIImageView?
    
    var userName:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView.init()
    
      
        
        if let profileInfo =  RepositoryManager.shared.getProfileData() {
            self.userName = profileInfo.name
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (!SRApplicationStates.isUserLoggedIn()) {
            let viewController =  AppCoordinator.getLoginScreenController()
            self.present(viewController, animated: true, completion: nil)
            
        } else {
            
            self.setLoginStatus(hasLoggedIn: SRApplicationStates.isUserLoggedIn())
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            return 100;
        }
        return 50;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCellIdentifier", for: indexPath)
            
            if let nameLabel =  cell.viewWithTag(999) as? UILabel {
                nameLabel.text = userName
            }
            
            if let profileImageView =  cell.viewWithTag(1001) as? UIImageView {
                profileImageView.layer.cornerRadius = 40;
                profileImageView.layer.masksToBounds = true;
            }
            
            
            
            
            return cell
        }
        return tableView.dequeueReusableCell(withIdentifier: "cellIdentifier\(indexPath.row)", for: indexPath)
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 6 {
          showInterests()
        }
    }
    
    func showInterests() {
        
        let storyboard = UIStoryboard(storyboard: .signup)
        let viewController = storyboard.instantiateViewController(withIdentifier: "FLInterestsViewController") as! FLInterestsViewController
        
        viewController.hideSkip = true
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
        
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

extension MyAccountViewController {
    
    fileprivate func setLoginStatus(hasLoggedIn:Bool) {
        let logoutButton = UIButton(type: .custom)
        logoutButton.setTitle(hasLoggedIn ? "Logout": "login", for: .normal)
        logoutButton.setTitleColor(UIColor.white, for: .normal)
        let barButton =  UIBarButtonItem(customView: logoutButton)
        logoutButton.addTarget(self, action: #selector(logoutButtonClicked), for: .touchUpInside)
        navigationItem.rightBarButtonItem = barButton
    }
    
    @objc func logoutButtonClicked() {
        
        if(SRApplicationStates.isUserLoggedIn()) {
            AppCoordinator.logoutUser()
        }
        
    }
    
}

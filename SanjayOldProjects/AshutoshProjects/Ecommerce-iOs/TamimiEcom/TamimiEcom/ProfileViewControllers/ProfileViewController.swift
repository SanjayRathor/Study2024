//
//  ProfileViewController.swift
//  TamimiEcom
//
//  Created by Ansh on 04/09/20.
//  Copyright © 2020  All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var lblTammi: UILabel!
    @IBOutlet weak var lblMyOrder: UILabel!
    @IBOutlet weak var lblMyWallet: UILabel!
    @IBOutlet weak var lblMyProduct: UILabel!
    @IBOutlet weak var lblContactUs: UILabel!
    @IBOutlet weak var lblLanguage: UILabel!
    @IBOutlet weak var lblChangepassword: UILabel!
    @IBOutlet weak var lblLogout: UILabel!
    @IBOutlet weak var lblFAQ: UILabel!
    @IBOutlet weak var lblTC: UILabel!

    @IBOutlet var walletView: UIView!
    
    @IBOutlet weak var nameLbl: UILabel!
    var langSelectionVC : langSelectionViewController!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var mobLbl: UILabel!
    @IBOutlet weak var stackSTF: NSLayoutConstraint!
    @IBOutlet weak var ttf: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.view.frame.size.width > 375 {
            stackSTF.constant = 30
            ttf.constant = 40
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUserData()
    }
    func setUserData() {
        if let user = ApplicationStates.getUserData() {
            var name = "Welcome "
            
            if let fname = user["fname"] as? String {
                name.append(" ")
                name.append(fname)
            }
            if let lname = user["lname"] as? String {
                name.append(" ")
                name.append(lname)
            }
            self.nameLbl.text = name
            if let email = user["email"] as? String {
                self.emailLbl.text  = "Email: " + email
            }
            if let mob = user["mob"] as? String {
                self.mobLbl.text  = "Mobile: " + mob
            }
        }
    }
    @IBAction func myLiesActionds(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let LikeViewController = storyboard.instantiateViewController(withIdentifier: "LikeViewController") as! LikeViewController
        self.navigationController?.pushViewController(LikeViewController, animated: true)
    }
    
    @IBAction func timeRewardAction(_ sender: Any) {
        if let url = URL(string: "https://tamimimarkets.com/members/") {
            UIApplication.shared.open(url)
        }    }
    @IBAction func myOrderAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "UserMoreInfo", bundle: nil)
        let myOrdersVC = storyboard.instantiateViewController(withIdentifier: "MyOrdersVC") as! MyOrdersVC
        self.navigationController?.pushViewController(myOrdersVC, animated: true)    }
    @IBAction func myWalletAction(_ sender: Any) {
        self.tabBarController?.view.addSubview(self.walletView)
        self.walletView.frame = self.view.bounds
        
    }
    @IBAction func contactUsAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "UserMoreInfo", bundle: nil)
        let contactUsVC = storyboard.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
        self.navigationController?.pushViewController(contactUsVC, animated: true)    }
    @IBAction func langAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.langSelectionVC = storyboard.instantiateViewController(withIdentifier: "langSelectionViewController") as? langSelectionViewController
        self.langSelectionVC.view.frame = self.view.bounds
        self.langSelectionVC.delegate = self
        self.langSelectionVC.updateUI()
        self.tabBarController?.view.addSubview(self.langSelectionVC.view)
        
    }
    @IBAction func changePasswordAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "UserMoreInfo", bundle: nil)
        let changePasswordVC = storyboard.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        self.navigationController?.pushViewController(changePasswordVC, animated: true)
    }
    @IBAction func logoutAction(_ sender: Any) {
        
        showMessage(title: Constants.appName, message: Constants.logoutMessage, okButton: "Yes", cancelButton: "Cancel", controller: self, okHandler: {
            ApplicationStates.removeUserData()
            ApplicationStates.removeOrderInformation()
            PresentingCoordinator.shared().loginSucessAndPageRefersh()
        }) {
            //Cancel
        }
    }
    @IBAction func faqAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "UserMoreInfo", bundle: nil)
        let checkOutViewController = storyboard.instantiateViewController(withIdentifier: "FAQViewController") as! FAQViewController
        self.navigationController?.pushViewController(checkOutViewController, animated: true)
    }
    @IBAction func termsOfAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "UserMoreInfo", bundle: nil)
        let webViewViewController = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        webViewViewController.isTamilMemberPage = false
        self.navigationController?.pushViewController(webViewViewController, animated: true)
    }
    
    
}
extension ProfileViewController : CloseLanguage {
    func closeActionFull() {
        if self.langSelectionVC != nil {
            self.langSelectionVC.view.removeFromSuperview()
            self.langSelectionVC = nil
        }
    }
    @IBAction func hideWalllView(_ sender: Any) {
        self.walletView.removeFromSuperview()
        
    }
    
}

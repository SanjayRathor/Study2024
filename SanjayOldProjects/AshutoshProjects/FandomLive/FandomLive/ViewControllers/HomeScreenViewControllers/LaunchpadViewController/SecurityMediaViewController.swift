//
//  SecurityMediaViewController.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 13/01/20.
//  Copyright © 2020 Sanjay Singh Rathor. All rights reserved.
//

import UIKit

class SecurityMediaViewController: SRBaseViewController {
    
    private let kUpdatesIdentifier = "SecuritySocialMediaLinkTableViewCell"
    private let kHeaderIdentifier:String = "SecurityMediaHeaderView"
    private let kSocialImageIdentifier = "SecuritySocialMediaImageTableViewCell"
    
    
    @IBOutlet weak var tableView: UITableView!
    var flInterests:SLSecurityMediaLink? = nil
    var interests: [MediaLink] = []
    
    var securityModel:SLSecurityImages? = nil
    var securityImages: [SecurityImages] = []
    
    var userId:String = ""
    var campaignId:String = ""
    
    public var launchDashboardCallback: (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView.init()
        
        self.tableView.register(UINib.init(nibName: "SecuritySocialMediaLinkTableViewCell", bundle: nil), forCellReuseIdentifier: kUpdatesIdentifier)
        
        self.tableView.register(UINib.init(nibName: "SecuritySocialMediaImageTableViewCell", bundle: nil), forCellReuseIdentifier: kSocialImageIdentifier)
        
        self.tableView.register(UINib.init(nibName: "SecurityMediaHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: kHeaderIdentifier)
        
        if let profileInfo = RepositoryManager.shared.getProfileData() {
            userId = profileInfo.userId
            self.getUpdates(userId: profileInfo.userId)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension SecurityMediaViewController:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if interests.count > 0  &&  securityImages.count > 0 {
            return 2
        } else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return interests.count;
        }
        
        return  securityImages.count;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath.section == 0) {
           let models = interests[indexPath.row]
           let storyboard = UIStoryboard(storyboard: .sharedBoard)
             let viewController = storyboard.instantiateViewController(withIdentifier: "FandomWebViewController") as! FandomWebViewController
             viewController.requestURL = models.contentPath
             viewController.hidesBottomBarWhenPushed = true
             self.navigationController?.pushViewController(viewController, animated: true)
        }
            
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: kHeaderIdentifier) as? SecurityMediaHeaderView else {
            return nil
        }
        
        if section == 0 {
            view.headerTitleLabel.text = "Media Links"
        } else {
            view.headerTitleLabel.text = "Social Links"
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (interests.count > 0 && indexPath.section == 0) {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: kUpdatesIdentifier, for: indexPath) as? SecuritySocialMediaLinkTableViewCell else {
                fatalError("Unable to Dequeue Reusable Table View Cell")
            }
            
            let models = interests[indexPath.row]
            cell.configureMediaLinks(media: models)
            return cell
        }
            
        else if (securityImages.count > 0 && indexPath.section == 1) {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: kSocialImageIdentifier, for: indexPath) as? SecuritySocialMediaImageTableViewCell else {
                fatalError("Unable to Dequeue Reusable Table View Cell")
            }
            
            let models = securityImages[indexPath.row]
            cell.configureMediaImage(media: models)
            return cell
        }
        
    
        return UITableViewCell()
    }
}

extension SecurityMediaViewController {
    
    func getUpdates(userId:String) {
        self.presentCustomActivity()
        
        var userInfo:[String:Any] = [
            "CampaignId" : campaignId
        ]
        
        userInfo.append(anotherDict: SRUtilities.sharedInstance().extraPostParams())
        SRDataManager.sharedInstance().performNetworkCodablePostRequest(requestURL: API.getMediaLinkURL, postData: userInfo) { (result) -> Void in
            
            switch (result) {
            case .success(let json):
                self.dismissCustomActivity()
                self.flInterests = try? JSONDecoder().decode(SLSecurityMediaLink.self, from: json as! Data)
                
                if let interests = self.flInterests?.result {
                    self.interests += interests
                    self.getSocialImages(userId: userId)
                    
                    self.tableView.reloadData()
                } else {
                    self.dismissCustomActivity()
                    self.tableView .setNoDataPlaceholder(AlertMessages.GeneralErrorMsg)
                }
                break
            case .failure(let error):
                self.tableView.setNoDataPlaceholder(error)
                self.dismissCustomActivity()
                self.presentWithMessage(error as NSString)
                break;
            }
        }
    }
    
    
    func getSocialImages(userId:String) {
        self.presentCustomActivity()
        
        var userInfo:[String:Any] = [
            "CampaignId" : campaignId
        ]
        
        userInfo.append(anotherDict: SRUtilities.sharedInstance().extraPostParams())
        SRDataManager.sharedInstance().performNetworkCodablePostRequest(requestURL: API.getSocialMediaImageURL, postData: userInfo) { (result) -> Void in
            
            switch (result) {
            case .success(let json):
                self.dismissCustomActivity()
                self.securityModel = try? JSONDecoder().decode(SLSecurityImages.self, from: json as! Data)
                
                if let interests = self.securityModel?.result {
                    self.securityImages += interests
                    self.tableView.reloadData()
                }
                break
            case .failure( _):
                self.dismissCustomActivity()
                break;
            }
        }
    }
}

extension SecurityMediaViewController {
    @IBAction func submitButtonDidClicked(_ sender: Any) {
        
    }
}

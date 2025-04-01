//
//  CampaignsSecurityDetailViewController.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 05/01/20.
//  Copyright © 2020 Sanjay Singh Rathor. All rights reserved.
//

import UIKit

import UIKit

class CampaignsSecurityDetailViewController: SRBaseViewController {
    
    let kRewardsDetailsCell = "SecurityDetailsCell"
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var makeEventButton: UIButton!
    var jsonModelItem:FLSecurityDeatailsModel? = nil
    var detailsModel:DetailsModel? = nil
    
    var campaignId:String = "";
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Details"
        self.tableView.tableFooterView = UIView.init()
        self.tableView.register(UINib.init(nibName: "SecurityDetailsCell", bundle: nil), forCellReuseIdentifier:kRewardsDetailsCell)
        self.tableView.alpha = 0;
        if let userId = RepositoryManager.shared.userProfile?.userId {
            self.getCampaigns(userId: userId)
        }
        self.updateButtonState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func updateButtonState() {
        if let detailsModel = self.detailsModel, detailsModel.isMakeDone == 1 {
            makeEventButton.isEnabled = false
            makeEventButton.setTitle("COMPLETED", for: .normal)
            makeEventButton.isUserInteractionEnabled = false
            makeEventButton.backgroundColor = UIColor.eventDeActiveColor
            makeEventButton.setBackgroundImage(UIImage.init(), for: .normal)
        } else {
            makeEventButton.isEnabled = true
            makeEventButton.setGradientImage(for: .normal)
            makeEventButton.backgroundColor = UIColor.clear
        }
    }
}

extension CampaignsSecurityDetailViewController:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: kRewardsDetailsCell, for: indexPath) as? SecurityDetailsCell else {
            fatalError("Unable to Dequeue Reusable Table View Cell")
        }
        if let item =  self.detailsModel {
            cell.configureDetails(detailsItem: item)
        }
        
        cell.didSecurityOPtionsCallback = { options in
            switch options {
            case .securityStory:
                self.gotoStoryVC()
                break
            case .securityStatics:
                self.gotoStaticsVC()
                break
            case .securityForums:
                self.gotoForumsVC()
                break
            case .securityUpdates:
                self.gotoUpdatesVC()
                break
            case .securitySocials:
                self.gotoSocialsVC()
                break
                
            }
        }
        
        cell.didShareCallback = { shareString in
            
            let string = "Fandom Live!"
            if let url = URL(string: shareString) {
                let activityViewController =
                    UIActivityViewController(activityItems: [string, url],
                                             applicationActivities: nil)
                self.present(activityViewController, animated: true) {
                    
                }
            }
            
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
}

extension CampaignsSecurityDetailViewController {
    
    func getCampaigns(userId:String) {
        self.presentCustomActivity()
        
        let otpURLString = String(format: API.getSecurityCampaignInfoURL, campaignId, userId)
        SRDataManager.sharedInstance().performNetworkGETServiceRequestWithData(requestURL: otpURLString) { (result) -> Void in
            switch (result) {
            case .success(let jsonData):
                self.dismissCustomActivity()
                
                do {
                    self.jsonModelItem = try JSONDecoder().decode(FLSecurityDeatailsModel.self, from: jsonData as! Data)
                } catch let error {
                    print(error)
                }
                
                guard (self.jsonModelItem?.result) != nil  else {
                    self.tableView.setNoDataPlaceholder(AlertMessages.EmptyErrorMsg)
                    return
                }
                self.tableView.alpha = 1;
                self.detailsModel = self.jsonModelItem?.result
                self.updateButtonState()
                self.tableView.reloadData()
                break
            case .failure(let error):
                self.dismissCustomActivity()
                self.presentWithMessage(error as NSString)
                break;
            }
        }
    }
    
    func makeSecurityCampaigs(userId:String) {
        self.presentCustomActivity()
        
        var userInfo:[String:Any] = [
            "CampaignId" : campaignId,
            "UserId" : userId,
            "HowMuchCanPay" : 200
        ]
        
        userInfo.append(anotherDict: SRUtilities.sharedInstance().extraPostParams())
        SRDataManager.sharedInstance().performNetworkServiceRequest(requestURL: API.getMakeSecurityCampaignURL, postData: userInfo) { (result) -> Void in
            
            switch (result) {
            case .success(_ /*jsonData*/):
                self.dismissCustomActivity()
                self.detailsModel?.isMakeDone = 1
                self.updateButtonState()
                
                break
            case .failure(let error):
                self.dismissCustomActivity()
                self.presentWithMessage(error as NSString)
                break;
            }
        }
    }
    
    
    
}
extension CampaignsSecurityDetailViewController {
    
    @IBAction func backThisEventDidClickded(_ sender: Any) {
        
        if let userId = RepositoryManager.shared.userProfile?.userId {
            self.makeSecurityCampaigs(userId: userId)
        }
    }
    
    func gotoStaticsVC () {
        
        let storyboard = UIStoryboard(storyboard: .sharedBoard)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SecurityDiscriptionsViewController") as! SecurityDiscriptionsViewController
        viewController.campaignId = "\(campaignId)"
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
        
        
    }
    
    func gotoForumsVC () {
        let storyboard = UIStoryboard(storyboard: .sharedBoard)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SecurityDocumentsViewController") as! SecurityDocumentsViewController
        viewController.campaignId = "\(campaignId)"
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
        
        
    }
    
    func gotoStoryVC () {
        
        let storyboard = UIStoryboard(storyboard: .sharedBoard)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SecurityDiscriptionsViewController") as! SecurityDiscriptionsViewController
        viewController.campaignId = "\(campaignId)"
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    
    func gotoUpdatesVC () {
        let storyboard = UIStoryboard(storyboard: .sharedBoard)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SecurityUpdatesViewController") as! SecurityUpdatesViewController
        viewController.campaignId = "\(campaignId)"
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    func gotoSocialsVC () {
        
        let storyboard = UIStoryboard(storyboard: .sharedBoard)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SecurityMediaViewController") as! SecurityMediaViewController
        viewController.campaignId = "\(campaignId)"
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}
//

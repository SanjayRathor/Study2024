//
//  CampaignsRewardsDetailViewController.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 08/12/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit

class CampaignsRewardsDetailViewController: SRBaseViewController {
    
    let kRewardsDetailsCell = "RewardsDetailsCell"
    let kRewardsSupportCell = "RewardsSupportCell"
    let kRewardsSetsCell = "RewardsSetsCell"
    let kRewardSetsTableViewCell = "RewardSetsTableViewCell"
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var makeEventButton: UIButton!
    var jsonModelItem:FLRewardDetailsModel? = nil
    var detailsModel:RewardDetails? = nil
    
    var campaignId:String = "";
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Reward Details"
        self.tableView.tableFooterView = UIView.init()
        self.tableView.register(UINib.init(nibName: "RewardsDetailsCell", bundle: nil), forCellReuseIdentifier:kRewardsDetailsCell)
        self.tableView.alpha = 0;
        if let userId = RepositoryManager.shared.userProfile?.userId {
            self.getCampaigns(userId: userId)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let detailsModel = self.detailsModel, detailsModel.isMakeDone == 1 {
            makeEventButton.isEnabled = false
            makeEventButton.backgroundColor = UIColor.lightGray
        } else {
            makeEventButton.isEnabled = true; makeEventButton.setGradientImage(for: .normal)
        }
    }
}

extension CampaignsRewardsDetailViewController:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: kRewardsDetailsCell, for: indexPath) as? RewardsDetailsCell else {
            fatalError("Unable to Dequeue Reusable Table View Cell")
        }
        if let item =  self.detailsModel {
            cell.configureDetails(detailsItem: item)
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
        cell.didRewardsOPtionsCallback = { cellOptions in
            self.rewardsOptionsDidClicked(options: cellOptions)
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

extension CampaignsRewardsDetailViewController {
    
    func getCampaigns(userId:String) {
        self.presentCustomActivity()
        
        let otpURLString = String(format: API.getRewardCampaignInfo, campaignId, userId)
        SRDataManager.sharedInstance().performNetworkGETServiceRequestWithData(requestURL: otpURLString) { (result) -> Void in
            switch (result) {
            case .success(let jsonData):
                self.dismissCustomActivity()
                
                do {
                    self.jsonModelItem = try JSONDecoder().decode(FLRewardDetailsModel.self, from: jsonData as! Data)
                } catch let error {
                    print(error)
                }
                
                guard (self.jsonModelItem?.result) != nil  else {
                    self.tableView.setNoDataPlaceholder(AlertMessages.EmptyErrorMsg)
                    return
                }
                self.tableView.alpha = 1;
                self.detailsModel = self.jsonModelItem?.result
                self.tableView.reloadData()
                break
            case .failure(let error):
                self.dismissCustomActivity()
                self.presentWithMessage(error as NSString)
                break;
            }
        }
    }
}
extension CampaignsRewardsDetailViewController {
    
    @IBAction func backThisEventDidClickded(_ sender: Any) {
        
        if(!SRApplicationStates.isUserLoggedIn()){
            AppCoordinator.promptUserForSignIn()
            return
        }
        
        let storyboard = UIStoryboard(storyboard: .sharedBoard)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SelectRewardsViewController") as! SelectRewardsViewController
        viewController.campaignId = "\(campaignId)"
        viewController.detailsModel = self.detailsModel
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}


extension CampaignsRewardsDetailViewController {
    
    func rewardsOptionsDidClicked(options:RewardsOptions) {
        
        if options == .rewardForums {
            
            let storyboard = UIStoryboard(storyboard: .main)
            let viewController = storyboard.instantiateViewController(withIdentifier: "ForumDetailsViewController") as! ForumDetailsViewController
            viewController.hideHeader = true
            //viewController.forum = forum
            self.navigationController?.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else if options == .rewardStatics {
            
            let storyboard = UIStoryboard(storyboard: .sharedBoard)
            let viewController = storyboard.instantiateViewController(withIdentifier: "VotingStatisticViewController") as! VotingStatisticViewController
            viewController.campaignId = "\(campaignId)"
            viewController.isRewardStatistics = true
            viewController.campaignName = "Statistics"
            
            viewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else if options == .rewardUpdates {
            let storyboard = UIStoryboard(storyboard: .sharedBoard)
            let viewController = storyboard.instantiateViewController(withIdentifier: "SecurityUpdatesViewController") as! SecurityUpdatesViewController
            viewController.campaignId = "\(campaignId)"
            viewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else if options == .rewardSocials {
            
            let storyboard = UIStoryboard(storyboard: .sharedBoard)
            let viewController = storyboard.instantiateViewController(withIdentifier: "SecurityMediaViewController") as! SecurityMediaViewController
            viewController.campaignId = "\(campaignId)"
            viewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController, animated: true)
            
        }
        
    }
    
}

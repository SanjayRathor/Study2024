//
//  VotingsViewController.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 16/10/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit

class VotingsViewController: SRBaseViewController {
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventCountDownLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var totalPointsGenerated: UILabel!
    @IBOutlet weak var userMadePoints: UILabel!
    @IBOutlet weak var daysLeft: UILabel!
    @IBOutlet weak var pointsGeneratedValue: UILabel!
    @IBOutlet weak var liverPointsValue: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var makeEventButton: UIButton!
    @IBOutlet weak var teamTypeLabel: PaddingLabel!
    
    var vatingcampaign:Votingcampaign?
    var campaignInfo:FLCampaignInfo?
    var eventDateTime:FabdomEventTimer?
    var timeEnd : Date?
    var campaignId = ""
    var needsupdateUI = false
    var forum:ForumItem? = nil
    var likeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventCountDownLabel.text = "00:00:00:00"
        
        getCampaignsInfo(campgainId: campaignId)
        self.containerView.isHidden = true
        
        forum =  ForumItem.init(banner: "", date: "", resultDescription: "", shareURL:"", topicID: Int(self.campaignId) ?? 0, topicName: "Forum", totalLike: 0, totalcomments: 0)
        
        likeButton = UIButton(type: UIButton.ButtonType.custom)
        likeButton.setImage(UIImage(named: "heart_not_selected"), for: .normal)
        likeButton.setImage(UIImage(named: "heart_selected"), for: .selected)
        likeButton.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        
        let likeBarButton =  UIBarButtonItem(customView: likeButton)
        let shareButton = UIBarButtonItem(image: UIImage.init(named: "share"), style: .plain, target: self, action: #selector(shareDidTapped))
        navigationItem.rightBarButtonItems = [shareButton,likeBarButton]
        
        
        self.navigationItem.title = "Campaign"
        configureRightButtons()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if needsupdateUI {
            self.updateUI()
        }
    }
    
    func updateUI() {
        guard let result = campaignInfo?.result else {
            return
        }
        configureRightButtons()
        if (result.isMakeDone == 1) {
            makeEventButton.setTitle("COMPLETED", for: .normal)
            makeEventButton.isUserInteractionEnabled = false
            makeEventButton.setBackgroundImage(UIImage.init(), for: .normal)
            makeEventButton.backgroundColor = UIColor.eventDeActiveColor
        } else {
            makeEventButton.setGradientImage(for: .normal)
            makeEventButton.backgroundColor = UIColor.clear
        }
        
        let url = URL(string: result.banner)
        imageView.kf.setImage(with: url)
        
        eventTitleLabel.text = result.name
        pointsGeneratedValue.text = "\(result.totalPointsMade)"
        liverPointsValue.text = "\(result.totalFandomLivers)"
        let defaultEnddate  = DateFormatter.endDateFormatter.date(from: result.endDate)
        
        teamTypeLabel.text = result.category
        
        if let endTime  = defaultEnddate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            endDateLabel.text = "Campaign ends on \(dateFormatter.string(from: endTime))"
            self.daysLeft.text =  "\(Date().differenceInDaysWithDate(date: endTime)) Days Left"
            
        } else {
            endDateLabel.text = "Campaign ends on \(result.endDate)"
            self.daysLeft.text = "0 Days Left"
        }
        
        self.eventDateTime = FabdomEventTimer(eventDate: result.endDate)
        eventDateTime?.didTimeUpdateCallback = { [weak self] (model:FLEventModel) in
            self?.eventCountDownLabel.text = String(format:"%@ : %@ : %@ : %@", model.daysString, model.hourString, model.menutesString, model.secondsString)
        }
    }
    
}

extension VotingsViewController {
    
    func configureRightButtons() {
        
        if self.campaignInfo?.result.islike == 1 {
            likeButton.isSelected = true;
        } else {
            likeButton.isSelected = false;
        }
        
    }
    
    @objc func likeTapped() {
        
        if self.likeButton.isSelected {
            SRDataManager.sharedInstance().likedClicked(isLiked: "\(0)", for: "\(campaignId)")
            
            self.campaignInfo?.result.islike = 0;
            self.vatingcampaign?.islike = 0;
        } else{
            SRDataManager.sharedInstance().likedClicked(isLiked: "\(1)", for: "\(campaignId)")
            self.campaignInfo?.result.islike = 1;
            self.vatingcampaign?.islike = 1; 
        }
        
        configureRightButtons()
    }
    
    @objc func shareDidTapped() {
        self.shareTapped(shareString: self.campaignInfo?.result.shareURL ?? "")
    }
}

extension VotingsViewController {
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "makeCampaignScreenSegue" {
            let controller = segue.destination as! MakeCampaignViewController
            controller.campaignInfo = self.campaignInfo
            controller.campaignId = self.campaignId
            needsupdateUI = true
        }
    }
    
    @IBAction func forumDidClicked(_ sender: Any) {
        
        let storyboard = UIStoryboard(storyboard: .main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ForumDetailsViewController") as! ForumDetailsViewController
        viewController.hideHeader = true
        viewController.forum = forum
        self.navigationController?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    @IBAction func staticsButtonDidClicked(_ sender: Any) {
        
        let storyboard = UIStoryboard(storyboard: .sharedBoard)
        let viewController = storyboard.instantiateViewController(withIdentifier: "VotingStatisticViewController") as! VotingStatisticViewController
        viewController.campaignId = "\(campaignId)"
        if let result = campaignInfo?.result {
            viewController.campaignName = result.name
        }
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
        
        
    }
    
    @IBAction func updatesDidClicked(_ sender: Any) {
        let storyboard = UIStoryboard(storyboard: .sharedBoard)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SecurityUpdatesViewController") as! SecurityUpdatesViewController
        viewController.campaignId = "\(campaignId)"
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    
    @IBAction func socialDidClicked(_ sender: Any) {
        
        let storyboard = UIStoryboard(storyboard: .sharedBoard)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SecurityMediaViewController") as! SecurityMediaViewController
        viewController.campaignId = "\(campaignId)"
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
}

extension VotingsViewController {
    
    func getCampaignsInfo(campgainId:String) {
        self.presentCustomActivity()
        
        var userId = ""
        if let profileInfo =   RepositoryManager.shared.getProfileData() {
            userId = profileInfo.userId
        }
        let getCampaignString = String(format: API.getCampaignInfoURL, campgainId, userId)
        SRDataManager.sharedInstance().performNetworkGETServiceRequestWithData(requestURL: getCampaignString) { (result) -> Void in
            switch (result) {
            case .success(let jsonData):
                self.dismissCustomActivity()
                self.campaignInfo = try? JSONDecoder().decode(FLCampaignInfo.self, from: jsonData as! Data)
                
                guard self.campaignInfo != nil  else {
                    self.containerView.isHidden = true
                    self.view.setNoDataMessage(AlertMessages.GeneralErrorMsg)
                    return
                }
                self.containerView.isHidden = false
                self.updateUI()
                
                break
            case .failure(let error):
                self.dismissCustomActivity()
                self.presentWithMessage(error as NSString)
                break;
            }
        }
    }
}



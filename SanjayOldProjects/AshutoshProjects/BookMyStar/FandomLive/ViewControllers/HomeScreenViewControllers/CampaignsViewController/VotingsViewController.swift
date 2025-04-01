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
    
    var campaignInfo:FLCampaignInfo?
    var eventDateTime:FabdomEventTimer?
    var timeEnd : Date?
    var campaignId = ""
    var needsupdateUI = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        eventCountDownLabel.text = "00:00:00:00"
        configureRightButtons()
        getCampaignsInfo(campgainId: campaignId)
        self.containerView.isHidden = true
        
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
        if (result.isMakeDone == 1) {
            makeEventButton.setTitle("COMPLETED", for: .normal)
            makeEventButton.isUserInteractionEnabled = false
            makeEventButton.backgroundColor = UIColor.eventDeActiveColor
        }
        
        let url = URL(string: result.banner)
        imageView.kf.setImage(with: url)
        
        eventTitleLabel.text = result.name
        pointsGeneratedValue.text = "\(result.totalPointsMade)"
        liverPointsValue.text = "\(result.totalFandomLivers)"
        let defaultEnddate  = DateFormatter.endDateFormatter.date(from: result.endDate)
        
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
        let likeButton = UIBarButtonItem(image: UIImage.init(named: "heart_not_selected"), style: .plain, target: self, action: #selector(likeTapped))
        let shareButton = UIBarButtonItem(image: UIImage.init(named: "share"), style: .plain, target: self, action: #selector(shareDidTapped))
        navigationItem.rightBarButtonItems = [shareButton,likeButton]
        
    }
    
    @objc func likeTapped() {
        
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



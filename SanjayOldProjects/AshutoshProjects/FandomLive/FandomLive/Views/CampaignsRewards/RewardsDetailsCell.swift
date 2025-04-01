//
//  RewardsDetailsCell.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 08/12/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit

enum RewardsOptions {
       case rewardStory, rewardStatics, rewardForums, rewardUpdates, rewardSocials
   }

class RewardsDetailsCell: UITableViewCell {
    
   
    public var didRewardsOPtionsCallback: ((RewardsOptions)->())?
    
    public var didShareCallback: ((String)->())?
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var rewardImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fundedLabel: UILabel!
    @IBOutlet weak var progressLabel: UIProgressView!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var fundGoal: UILabel!
    
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var endDateValueLabel: UILabel!
    @IBOutlet weak var fandomPointsLabel: UILabel!
    @IBOutlet weak var liverPointsLabel: UILabel!
    
    var details:RewardDetails!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureDetails(detailsItem:RewardDetails) {
        self.details = detailsItem;
        let url = URL(string: (detailsItem.image))
        rewardImageView.kf.setImage(with: url, placeholder:UIImage.init(named: "placeHolder_Interest"))
        nameLabel.text = detailsItem.name
        
        let defaultEnddate  = DateFormatter.endDateFormatter.date(from: detailsItem.endDate)
        if let endTime  = defaultEnddate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            endDateLabel.text = "Campaign ends on \(dateFormatter.string(from: endTime))"
            self.endDateValueLabel.text =  "\(Date().differenceInDaysWithDate(date: endTime)) Days Left"
            
        } else {
            endDateLabel.text = "Campaign ends on \(detailsItem.endDate)"
            self.endDateValueLabel.text = "0 Days Left"
        }
        
        fandomPointsLabel.text = "\(detailsItem.totalPointsMade)"
        liverPointsLabel.text = "\(detailsItem.totalFandomLivers)"
        
        
        likeButton.isSelected = (detailsItem.islike == 1) ? true : false
        
        fundedLabel.text = "\(detailsItem.funded) Funded"
        fundGoal.text = "Of \(detailsItem.fundGoal) fund goal";
        
        let funded = detailsItem.funded.replacingOccurrences(of: ",", with: "")
        let fundedGoal = detailsItem.fundGoal.replacingOccurrences(of: ",", with: "")
        
        let progress =  Float (funded) ?? 0
        let progress2 =  Float (fundedGoal) ?? 0
        self.progressLabel.progress =  Float(progress/progress2)*100
        descLabel.text = detailsItem.desc
        
    }
    
    
    @IBAction func storyButtonDidClicked(_ sender: Any) {
        didRewardsOPtionsCallback?(.rewardStory)
    }
    
    @IBAction func staticsButtonDidClicked(_ sender: Any) {
        didRewardsOPtionsCallback?(.rewardStatics)
    }
    
    @IBAction func forumButtonDidClicked(_ sender: Any) {
        didRewardsOPtionsCallback?(.rewardForums)
    }
    
    @IBAction func updatesButtonDidClicked(_ sender: Any) {
        didRewardsOPtionsCallback?(.rewardUpdates)
    }
    
    @IBAction func socialButtonDidClicked(_ sender: Any) {
        didRewardsOPtionsCallback?(.rewardSocials)
    }
    
    @IBAction func shareButtonDidClicked(_ sender: Any) {
        var shareString = ""
        shareString = details.shareURL
        didShareCallback?(shareString)
    }
    
    @IBAction func likeButtonDidClicked(_ sender: UIButton) {
        
        if (!SRNetworkManager.sharedInstance().isNetworkReachible()) {
            SRUtilities.showToastMessage(AlertMessages.NetworkErrorMsg)
            return
        }
        
        if(!SRApplicationStates.isUserLoggedIn()){
            AppCoordinator.promptUserForSignIn()
            return
        }
        
        sender.isSelected = !sender.isSelected
        let hasLiked = sender.isSelected ? 1 : 0
        var camgainId = 0
        details.islike = hasLiked
        camgainId = details.id
        
        SRDataManager.sharedInstance().likedRewardClicked(isLiked: "\(hasLiked)", for: "\(camgainId)")
    }
}

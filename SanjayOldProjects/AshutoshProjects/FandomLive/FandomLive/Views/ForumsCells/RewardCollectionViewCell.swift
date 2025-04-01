//
//  RewardCollectionViewCell.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 12/10/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit
import Kingfisher

class RewardCollectionViewCell: UICollectionViewCell {
    
    public var didShareCallback: ((String)->())?
    public var didTrandingLikeCallback: ((Rewardscampaign)->())?
    
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var fundedLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var gradientView: UIView!
    
    @IBOutlet weak var goalProgress: UIProgressView!
    var votingcampaign: Rewardscampaign!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        shareButton.tintColor = UIColor.white
        likeButton.tintColor = UIColor.white
        applyShadow()
    }
    
    func applyShadow () {
        self.addShadow(color: UIColor.init(red: 219, green: 219, blue: 219), cornerRadius: 20)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configureRewordCell(cellModel:Rewardscampaign) {
        self.votingcampaign = cellModel
        titleLabel.text = cellModel.name
        descLabel.text = cellModel.rewardcampaignDescription
        let url = URL(string: (cellModel.image))
        thumbImageView.kf.setImage(with: url)
        likeButton.isSelected = (cellModel.islike == 1) ? true : false
        
        fundedLabel.text = "Funded \(cellModel.funded)"
        goalLabel.text = "Total Fund Goal \(cellModel.fundGoal)";
        
        let funded = cellModel.funded.replacingOccurrences(of: ",", with: "")
        let fundedGoal = cellModel.fundGoal.replacingOccurrences(of: ",", with: "")
        
        let progress =  Float (funded) ?? 0
        let progress2 =  Float (fundedGoal) ?? 0
        goalProgress.progress =  Float(progress/progress2)*100
       
    }
    
}

extension RewardCollectionViewCell {
    
    @IBAction func shareDidClicked(_ sender: Any) {
        var shareString = ""
        shareString = votingcampaign.shareURL
        didShareCallback?(shareString)
    }
    
    @IBAction func likeDidClicked(_ sender: UIButton) {
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
        votingcampaign.islike = hasLiked
        camgainId = votingcampaign.id
        
        SRDataManager.sharedInstance().likedRewardClicked(isLiked: "\(hasLiked)", for: "\(camgainId)")
    }    
}

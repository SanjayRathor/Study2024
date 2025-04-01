//
//  TrandingCollectionViewCell.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 12/10/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit
import Kingfisher

class TrandingCollectionViewCell: UICollectionViewCell {
    
    public var didShareCallback: ((String)->())?
    public var didTrandingLikeCallback: ((Votingcampaign)->())?
    
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var engagementsLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var gradientView: UIView!
    var eventDateTime:FabdomEventTimer?
    
    @IBOutlet weak var myVotingsView: UIView!
    @IBOutlet weak var myVotingState: UILabel!
    
    @IBOutlet weak var categoryName: UILabel!
    var votingcampaign: Votingcampaign!
    var items: Items!
    var favorites: Voting!
    var campaigns: CampaignModel!
    
    
    enum ModelType {
        case kVotingModel
        case kMyVotingModel
        case kMyFavoritesModel
        case kCampaignModel
        
    }
    
    var modelType:ModelType = .kVotingModel
    
    override func awakeFromNib() {
        super.awakeFromNib()
        shareButton.tintColor = UIColor.white
        likeButton.tintColor = UIColor.white
        timeLabel.text = "00:00:00:00"
        applyShadow()
    }
    
    func applyShadow () {
        self.addShadow(color: UIColor.init(red: 219, green: 219, blue: 219), cornerRadius: 20)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.eventDateTime?.releaseTimer()
    }
    
    func configureVotingCell(cellModel:Votingcampaign) {
        
        modelType = .kVotingModel
        self.votingcampaign = cellModel
        myVotingsView.isHidden = true
        titleLabel.text = cellModel.campName
        descLabel.text = cellModel.campDescription
        pointsLabel.text = "\(cellModel.pointMade) Fandompoints"
        if (cellModel.fandomPoint.isEmpty) {
            engagementsLabel.text = "0 Engage"
        } else {
            engagementsLabel.text = cellModel.fandomPoint + " Engage"
        }
        
        self.categoryName.text = cellModel.eventName;
        let url = URL(string: (cellModel.campImage))
        thumbImageView.kf.setImage(with: url)

        if (Date.isCurrentDateIsFuture(eventDate: cellModel.endDate)) {
            self.eventDateTime = FabdomEventTimer(eventDate: cellModel.endDate)
            eventDateTime?.didTimeUpdateCallback = { [weak self] (model:FLEventModel) in
                self?.timeLabel.text = String(format:"%@ : %@ : %@ : %@", model.daysString, model.hourString, model.menutesString, model.secondsString)
            }
        } else {
            myVotingsView.isHidden = false
            if (cellModel.isMakedone == 1) {
                myVotingState.text = "COMPLETED";
            } else {
                myVotingState.text = "EXPIRED";
            }
            
        }
    
        likeButton.isSelected = (cellModel.islike == 1) ? true : false
    }
    
    func configureMyVotingCell(cellModel:Items) {
        self.items = cellModel
        modelType = .kMyVotingModel
        self.applyShadow()
        
        myVotingsView.isHidden = true
        titleLabel.text = cellModel.campName
        descLabel.text = cellModel.campDescription
        pointsLabel.text = "\(cellModel.pointMade) Fandompoints"
        engagementsLabel.text = cellModel.fandomPoint + " Engage"
        
        
        self.categoryName.text = cellModel.eventName;
        
        let url = URL(string: (cellModel.campImage))
        thumbImageView.kf.setImage(with: url)
        myVotingState.text = ""
        likeButton.isSelected = (cellModel.islike == 1) ? true : false
        
        if (Date.isCurrentDateIsFuture(eventDate: cellModel.endDate)) {
            self.eventDateTime = FabdomEventTimer(eventDate: cellModel.endDate)
            eventDateTime?.didTimeUpdateCallback = { [weak self] (model:FLEventModel) in
                self?.timeLabel.text = String(format:"%@ : %@ : %@ : %@", model.daysString, model.hourString, model.menutesString, model.secondsString)
            }
        } else {
            myVotingsView.isHidden = false
            myVotingState.text = "EXPIRED";
        }
        
        
    }
    
    func configureMyFavoritesCell(cellModel:Voting) {
        self.applyShadow()
        
        self.favorites = cellModel
        modelType = .kMyFavoritesModel
        myVotingsView.isHidden = true
        
        self.categoryName.text = cellModel.eventName;
        
        pointsLabel.text = "\(cellModel.pointMade) Fandompoints"
        engagementsLabel.text = cellModel.fandomPoint + " Engage"
        
        titleLabel.text = cellModel.campName
        descLabel.text = cellModel.campDescription
        
        if (Date.isCurrentDateIsFuture(eventDate: cellModel.endDate)) {
            self.eventDateTime = FabdomEventTimer(eventDate: cellModel.endDate)
            eventDateTime?.didTimeUpdateCallback = { [weak self] (model:FLEventModel) in
                self?.timeLabel.text = String(format:"%@ : %@ : %@ : %@", model.daysString, model.hourString, model.menutesString, model.secondsString)
            }
        } else {
            myVotingsView.isHidden = false
            myVotingState.text = "EXPIRED";
        }
        
        let url = URL(string: (cellModel.campImage))
        thumbImageView.kf.setImage(with: url)
        likeButton.isSelected = (cellModel.islike == 1) ? true : false
    }
    
    func configureCampaignCell(cellModel:CampaignModel) {
        
        self.categoryName.text = cellModel.type;
        
        modelType = .kCampaignModel
        self.campaigns = cellModel
        myVotingsView.isHidden = true
        titleLabel.text = cellModel.name
        descLabel.text = cellModel.campaignDescription
        pointsLabel.text = "\(cellModel.pointGenerated) Fandompoints"
        engagementsLabel.text = "\(cellModel.engage) Engage"
        
        let url = URL(string: (cellModel.image))
        thumbImageView.kf.setImage(with: url)
        
        if (Date.isCurrentDateIsFuture(eventDate: cellModel.endDate)) {
            self.eventDateTime = FabdomEventTimer(eventDate: cellModel.endDate)
            eventDateTime?.didTimeUpdateCallback = { [weak self] (model:FLEventModel) in
                self?.timeLabel.text = String(format:"%@ : %@ : %@ : %@", model.daysString, model.hourString, model.menutesString, model.secondsString)
            }
        } else {
            myVotingsView.isHidden = false
            myVotingState.text = "EXPIRED";
            
        }
        
        //likeButton.isSelected = (cellModel.islike == 1) ? true : false
    }
    
}

extension TrandingCollectionViewCell {
    
    @IBAction func shareDidClicked(_ sender: Any) {
        
        var shareString = ""
        
        if modelType == .kVotingModel {
            shareString = votingcampaign.shareURL
            
        } else if modelType == .kMyVotingModel {
            shareString = items.shareURL
        }
        else if modelType == .kMyFavoritesModel {
            shareString = favorites.shareURL
        }
        if !shareString.isEmpty {
            didShareCallback?(shareString)
        }
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
        
        if modelType == .kVotingModel {
            votingcampaign.islike = hasLiked
            camgainId = votingcampaign.id
            
        } else if modelType == .kMyVotingModel {
            items.islike = hasLiked
            camgainId = items.campaignID
        }
        else if modelType == .kMyFavoritesModel {
            favorites.islike = hasLiked
            camgainId = favorites.campID
        }
        SRDataManager.sharedInstance().likedClicked(isLiked: "\(hasLiked)", for: "\(camgainId)")
    }
    
    
    
}

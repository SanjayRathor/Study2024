//
//  SecurityDetailsCell.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 08/12/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit


class SecurityDetailsCell: UITableViewCell {

    @IBOutlet weak var shadowView: UIStackView!
    enum SecurityOptions {
        case securityStory, securityStatics, securityForums, securityUpdates, securitySocials
    }
    @IBOutlet weak var containerView: UIView!
    public var didSecurityOPtionsCallback: ((SecurityOptions)->())?
    public var didShareCallback: ((String)->())?
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var rewardImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fundedLabel: UILabel!
    @IBOutlet weak var progressLabel: UIProgressView!
    @IBOutlet weak var fundGoal: UILabel!

    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var endDateValueLabel: UILabel!
    @IBOutlet weak var liverPointsLabel: UILabel!
    @IBOutlet weak var totalFandomLabel: UILabel!
    @IBOutlet weak var launchPadtypeLabel: UILabel!

    var details:DetailsModel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configureDetails(detailsItem:DetailsModel) {
        self.details = detailsItem;
        let url = URL(string: (detailsItem.image))
        rewardImageView.kf.setImage(with: url, placeholder:UIImage.init(named: "placeHolder_Interest"))
        nameLabel.text = detailsItem.name

        let defaultEnddate  = DateFormatter.endDateFormatter.date(from: detailsItem.endDate)
        if let endTime  = defaultEnddate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            self.endDateValueLabel.text =  "\(Date().differenceInDaysWithDate(date: endTime)) Days Left"

        } else {
           
            self.endDateValueLabel.text = "0 Days Left"
        }

        totalFandomLabel.text = "\(detailsItem.totalPointsMade)"
        liverPointsLabel.text = "\(detailsItem.totalFandomLivers)"
        likeButton.isSelected = (detailsItem.islike == 1) ? true : false
        launchPadtypeLabel.text = "\(detailsItem.category)"
        
        fundedLabel.text = "\(detailsItem.funded) Funded"
        fundGoal.text = "Of \(detailsItem.fundGoal) fund goal";

        let funded = detailsItem.funded
        let fundedGoal = detailsItem.fundGoal.replacingOccurrences(of: ",", with: "")

        let progress =  Float (funded) 
        let progress2 =  Float (fundedGoal) ?? 0
        self.progressLabel.progress =  Float((progress ?? 0)/progress2)*100
        descLabel.text = detailsItem.desc
        
        //containerView.addShadow(color: UIColor.init(red: 219, green: 219, blue: 219), cornerRadius: 5)
        containerView.castShadow(withPosition: SCShadowEdgeAll)

    }


    @IBAction func storyButtonDidClicked(_ sender: Any) {
        self.didSecurityOPtionsCallback?(.securityStory)
    }

    @IBAction func staticsButtonDidClicked(_ sender: Any) {
         self.didSecurityOPtionsCallback?(.securityStatics)
    }

    @IBAction func forumButtonDidClicked(_ sender: Any) {
        self.didSecurityOPtionsCallback?(.securityForums)
    }

    @IBAction func updatesButtonDidClicked(_ sender: Any) {
        self.didSecurityOPtionsCallback?(.securityUpdates)
    }

    @IBAction func socialButtonDidClicked(_ sender: Any) {
        self.didSecurityOPtionsCallback?(.securitySocials)
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

        SRDataManager.sharedInstance().likeSecurityCampaignClicked(isLiked: "\(hasLiked)", for: "\(camgainId)")
    }
}

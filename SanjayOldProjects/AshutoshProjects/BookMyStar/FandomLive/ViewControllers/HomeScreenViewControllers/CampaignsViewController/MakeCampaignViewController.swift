//
//  MakeCampaignViewController.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 23/10/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit
import iOSDropDown
import SVProgressHUD

class MakeCampaignViewController: UIViewController {
    
    enum CampaignType {
        case sports
        case general
        case concerts
    }
    
    @IBOutlet weak var selectTeam: UILabel!
    @IBOutlet weak var teamALabel: UILabel!
    @IBOutlet weak var amountLabel: UITextField!
    @IBOutlet weak var teamBLabel: UILabel!
    @IBOutlet weak var teamsVew: UIView!
    @IBOutlet weak var conserViewHeight: NSLayoutConstraint!
    @IBOutlet weak var consertViewBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var cityTextField: DropDown!
    @IBOutlet weak var teamALogo: UIImageView!
    @IBOutlet weak var teamBLogo: UIImageView!
    
    
    @IBOutlet weak var consertView: UIView!
    @IBOutlet weak var followersView: FollowersView!
    
    @IBOutlet weak var concertViewTopHeight: NSLayoutConstraint!
    @IBOutlet weak var concertViewTopOffset: NSLayoutConstraint!
    
    //MARK:- default Values
    var campaignInfo:FLCampaignInfo?
    var firstTeamId:String = ""
    var secondTeamId:String = ""
    var userId:String = ""
    var campaignId = ""
    var cityId = ""
    var categoryId = ""
    var followedBy:String = ""
    
    var campaignType:CampaignType = .general
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let profileInfo = RepositoryManager.shared.getProfileData() {
            self.userId = profileInfo.userId
        }
        
        self.updateUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func chooseTeamDidClicked(_ sender: Any) {
        let storyboard = UIStoryboard(storyboard: .main)
        let customAlert = storyboard.instantiateViewController(withIdentifier: "TeamsViewController") as! TeamsViewController
        customAlert.teams  = campaignInfo?.result.teams.teamB
        
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        customAlert.delegate = self
        self.present(customAlert, animated: true, completion: nil)
    }
}

extension MakeCampaignViewController : TeamsViewControllerDelegate {
    func teamButtonTapped(teamId: Int, teamName: String, imageURL: String) {
        self.secondTeamId = "\(teamId)"
        teamBLabel.text = teamName;
        
        let url = URL(string: (imageURL))
        teamBLogo.kf.setImage(with: url, placeholder:UIImage.init(named: "teamChoose"))
        
        
    }
    
    func updateUI() {
        guard let campaign = campaignInfo else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        self.categoryId = "\(campaign.result.categoryID)"
        if (campaign.result.category == "Sports") {
            self.campaignType = .sports
            self.consertView.isHidden = true
            
            if let firstTeam =  campaign.result.teams.teamA.first {
                teamALabel.text =  firstTeam.name
                self.firstTeamId = "\(firstTeam.id)"
                let url = URL(string: (firstTeam.teamLogo))
                teamALogo.kf.setImage(with: url, placeholder:UIImage.init(named: "fixedteam"))
                
            }
        }
        else  if (campaign.result.category == "General") {
            self.campaignType = .general
            
            self.conserViewHeight.constant = 0
            self.consertViewBottomSpace.constant = 40
            self.concertViewTopHeight.constant = 0
            self.teamsVew.isHidden = true
            self.consertView.isHidden = true
            self.view.layoutIfNeeded()
            
        }
        else  if (campaign.result.category == "Concert") {
            self.campaignType = .concerts
            self.teamsVew.isHidden = true
            self.followersView.reloadItems(items: campaign.result.concert)
            
            var followedArray:[String] = []
            campaign.result.concert.followed.forEach { followed in
                followedArray.append("\(followed.id)")
                
            }
            self.followedBy = followedArray.joined(separator: ",")
        }
        
        
        addLocations()
    }
    
    func addLocations() {
        
        //Fill Location
        guard let locationModel =  campaignInfo?.result.location.first else {
            return
        }
        
        //NOTE :- cityName
        var cityNames:[String] = []
        var cityCodes:[Int] = []
        locationModel.city.forEach { model in
            cityNames.append(model.name)
            cityCodes.append(Int(model.id))
        }
        
        cityTextField.optionArray = cityNames
        cityTextField.optionIds = cityCodes
        cityTextField.isSearchEnable = false
        cityTextField.isEnabled = true
        cityTextField.didSelect{(selectedText , index , id) in
            self.cityId = String("\(id)");
        }
    }
}


extension MakeCampaignViewController {
    
    @IBAction func submitButtonDidClicked(_ sender: Any) {
        
        if self.validateCampaign() {
            self.performVotingRequest()
        }
    }
    
    func performVotingRequest() {
        SVProgressHUD.show()
        
        var userInfo:[String:Any] = [
            "CategoryId" : categoryId,
            "CampaignId" : campaignId,
            "UserId" :  self.userId,
            "HowMuchCanPay" : self.amountLabel.text!,
            "FirstTeam": self.firstTeamId,
            "SecondTeam" : self.secondTeamId,
            "MainArtist" : self.followersView.mainArtistId,
            "FollowedArtistId" : followedBy,
            "CountryId" : "",
            "StateId" : "",
            "CityId" : self.cityId
        ]
        
        userInfo.append(anotherDict: SRUtilities.sharedInstance().extraPostParams())
        SRDataManager.sharedInstance().performNetworkServiceRequest(requestURL: API.voteCampaignURL, postData: userInfo) { (result) -> Void in
            switch (result) {
            case .success(let json):
                
                if let result:[String:Any] = json as? Dictionary {
                    self.parseSignInJSON(json: result)
                } else {
                    self.showAlertWith(title:"", message:AlertMessages.GeneralErrorMsg)
                }
                break
            case .failure(let error):
                self.showAlertWith(title:"", message:error)
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                }
                break;
            }
        }
    }
}


extension MakeCampaignViewController {
    
    func parseSignInJSON(json:[String:Any]) {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
        
        guard let statusCode = json["status"] as? String, statusCode.boolValue == true  else {
            if let messageText = json["message"] as? String {
                self.showAlertWith(title:"", message:messageText)
            } else {
                self.showAlertWith(title:"", message:AlertMessages.GeneralErrorMsg)
            }
            return
        }
        
        if let messageText = json["message"] as? String {
            //self.navigationController?.view.makeToast(messageText)
            self.showToastMessage(messageText)
        }
        
        campaignInfo?.result.isMakeDone = 1
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension MakeCampaignViewController {
    
    func validateCampaign() -> Bool {
        
        if (self.campaignType == .sports) {
            
            if (!firstTeamId.isEmpty && !secondTeamId.isEmpty && validateGeneral()) {
                return true
            } else {
                
                if (firstTeamId.isEmpty) {
                    //self.navigationController?.view.makeToast(AlertMessages.TeamAMissingMsg)
                    self.showToastMessage(AlertMessages.TeamAMissingMsg)
        
                    
                } else if (secondTeamId.isEmpty) {
                   // self.navigationController?.view.makeToast(AlertMessages.TeamBMissingMsg)
                    self.showToastMessage(AlertMessages.TeamBMissingMsg)
                }
                return false
            }
        }
        else if (self.campaignType == .general) {
            return validateGeneral()
        }
        else if (self.campaignType == .concerts) {
            
            if (!followersView.mainArtistId.isEmpty && validateGeneral()) {
                return true
            } else {
             //self.navigationController?.view.makeToast(AlertMessages.MainArtistMissingMsg)
                self.showToastMessage(AlertMessages.MainArtistMissingMsg)
            }
        }
        return false
    }
    
    func validateGeneral() -> Bool {
        if (!amountLabel.text!.isEmpty && !cityId.isEmpty) {
            return true
        }
        
        if (amountLabel.text!.isEmpty) {
            //self.navigationController?.view.makeToast(AlertMessages.AmountMissingMsg)
            self.showToastMessage(AlertMessages.AmountMissingMsg)
            
        } else if (cityId.isEmpty) {
           // self.navigationController?.view.makeToast(AlertMessages.CityMissingMsg)
            self.showToastMessage(AlertMessages.CityMissingMsg)
        }
        
        return false
    }
    
}

//
//  SecurityDiscriptionsViewController.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 14/01/20.
//  Copyright © 2020 Sanjay Singh Rathor. All rights reserved.
//

import UIKit
import YoutubePlayer_in_WKWebView


class SecurityDiscriptionsViewController: SRBaseViewController {
    
    private let kDescriptionIdentifier = "SecurityProjectDescription"
    private let kLegalIdentifier = "SecurityLegalDescription"
    private let kChannelIdentifier = "SecurityChannelDescription"
    
    @IBOutlet weak var tableView: UITableView!
    var jsonModelItem:FLSecurityDeatailsModel? = nil
    var securityModel:SLLegalInfo? = nil
    
    var detailsModel:DetailsModel? = nil
    var legalDataModel:SLegalModel? = nil
    
    var userId:String = ""
    var campaignId:String = ""
    var sectionCounts = Array<Int>()
    
    public var launchDashboardCallback: (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView.init()
        self.tableView.register(UINib.init(nibName: "SecurityProjectDescription", bundle: nil), forCellReuseIdentifier: kDescriptionIdentifier)
        self.tableView.register(UINib.init(nibName: "SecurityLegalDescription", bundle: nil), forCellReuseIdentifier: kLegalIdentifier)
        self.tableView.register(UINib.init(nibName: "SecurityChannelDescription", bundle: nil), forCellReuseIdentifier: kChannelIdentifier)
        
        if let profileInfo = RepositoryManager.shared.getProfileData() {
            userId = profileInfo.userId
            self.getCampaigns(userId: profileInfo.userId)
        }
        
        self.navigationItem.title = "Discription"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension SecurityDiscriptionsViewController:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCounts.count;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return 0;
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if ((self.detailsModel != nil) && indexPath.section == 0) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: kDescriptionIdentifier, for: indexPath) as? SecurityProjectDescription else {
                fatalError("Unable to Dequeue Reusable Table View Cell")
            }
            
            cell.nameLabel.text = detailsModel?.name;
            cell.descLabel.text = detailsModel?.desc;
            return cell
        }
        else if ((self.legalDataModel != nil) && indexPath.section == 1) {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: kLegalIdentifier, for: indexPath) as? SecurityLegalDescription else {
                fatalError("Unable to Dequeue Reusable Table View Cell")
            }
            cell.configureLegal(legal: legalDataModel!)
            return cell
        }
        else if ((self.legalDataModel != nil) && indexPath.section == 2) {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: kChannelIdentifier, for: indexPath) as? SecurityChannelDescription else {
                fatalError("Unable to Dequeue Reusable Table View Cell")
            }
            cell.playerView.load(withVideoId: legalDataModel?.videoID ?? "")
            return cell
        }
        
        return UITableViewCell()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let cell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 2))
        if let isCell = cell as? SecurityChannelDescription {
            if !tableView.visibleCells.contains(isCell) {
                isCell.playerView .pauseVideo()
            }
        }
        
        tableView.visibleCells.forEach { vissibleCell in
            if let cell = vissibleCell as? SecurityChannelDescription {
                cell.playerView .pauseVideo()
            }
        }
        
    }
}





extension SecurityDiscriptionsViewController {
    
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
                self.tableView.reloadData()
                
                self.getOrganizerLegalInfo(userId: userId)
                
                break
            case .failure(let error):
                self.dismissCustomActivity()
                self.presentWithMessage(error as NSString)
                break;
            }
        }
    }
    
    
    func getOrganizerLegalInfo(userId:String) {
        self.presentCustomActivity()
        
        var userInfo:[String:Any] = [
            "CampaignId" : campaignId
        ]
        
        userInfo.append(anotherDict: SRUtilities.sharedInstance().extraPostParams())
        SRDataManager.sharedInstance().performNetworkCodablePostRequest(requestURL: API.getOrganizerLegalInfoURL, postData: userInfo) { (result) -> Void in
            
            switch (result) {
            case .success(let jsonData):
                self.dismissCustomActivity()
                
                do {
                    self.securityModel = try JSONDecoder().decode(SLLegalInfo.self, from: jsonData as! Data)
                } catch let error {
                    print(error)
                }
                
                guard (self.jsonModelItem?.result) != nil  else {
                    self.tableView.setNoDataPlaceholder(AlertMessages.EmptyErrorMsg)
                    return
                }
                
                self.sectionCounts.append(1)
                self.sectionCounts.append(1)
                self.sectionCounts.append(1)
                
                self.tableView.alpha = 1;
                self.legalDataModel = self.securityModel?.result.first
                self.tableView.reloadData()
                
                
                break
            case .failure( _):
                self.dismissCustomActivity()
                break;
            }
        }
    }
}

extension SecurityDiscriptionsViewController {
    @IBAction func submitButtonDidClicked(_ sender: Any) {
        
    }
}

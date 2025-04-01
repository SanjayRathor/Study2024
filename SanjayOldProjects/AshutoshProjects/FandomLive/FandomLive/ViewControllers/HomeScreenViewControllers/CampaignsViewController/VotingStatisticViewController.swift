//
//  VotingStatisticViewController.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 19/01/20.
//  Copyright © 2020 Sanjay Singh Rathor. All rights reserved.
//

import UIKit

class VotingStatisticViewController: SRBaseViewController {
    
    private let kDocumentsIdentifier = "StatisticTableViewCell"
    @IBOutlet weak var tableView: UITableView!
    var flInterests:SLStatisticsModel? = nil
    var interests: [VStatistics] = []
    
    var userId:String = ""
    var campaignId:String = ""
    var campaignName:String = ""
    var isRewardStatistics:Bool = false
    
    public var launchDashboardCallback: (()->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView.init()
        self.tableView.register(UINib.init(nibName: "StatisticTableViewCell", bundle: nil), forCellReuseIdentifier: kDocumentsIdentifier)
        
        if let profileInfo = RepositoryManager.shared.getProfileData() {
            userId = profileInfo.userId
            self.getUpdates(userId: profileInfo.userId)
        }
        self.navigationItem.title = campaignName
        tableView.rowHeight = 50
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension VotingStatisticViewController:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interests.count;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: kDocumentsIdentifier, for: indexPath) as? StatisticTableViewCell else {
            fatalError("Unable to Dequeue Reusable Table View Cell")
        }
        
        let models = interests[indexPath.row]

        cell.configureStatistic(statistic: models, for: indexPath.row)
        return cell
    }
}

extension VotingStatisticViewController {
    
    func getUpdates(userId:String) {
        self.presentCustomActivity()
        
        var userInfo:[String:Any] = [
            "CampaignId" : campaignId
            //"UserId" : userId
        ]
        
        let urlString =  self.isRewardStatistics ?API.getRewardStatisticsURL :API.getVotingStatisticsURL
    
        userInfo.append(anotherDict: SRUtilities.sharedInstance().extraPostParams())
        SRDataManager.sharedInstance().performNetworkCodablePostRequest(requestURL: urlString, postData: userInfo) { (result) -> Void in
            
            switch (result) {
            case .success(let json):
                self.dismissCustomActivity()
                self.flInterests = try? JSONDecoder().decode(SLStatisticsModel.self, from: json as! Data)
                
                if let interests = self.flInterests?.result {
                    self.interests += interests
                    self.tableView.reloadData()
                } else {
                    self.dismissCustomActivity()
                    self.tableView .setNoDataPlaceholder(AlertMessages.GeneralErrorMsg)
                }
                break
            case .failure(let error):
                self.tableView.setNoDataPlaceholder(error)
                self.dismissCustomActivity()
                self.presentWithMessage(error as NSString)
                break;
            }
        }
    }
    
}

extension VotingStatisticViewController {
    @IBAction func submitButtonDidClicked(_ sender: Any) {
        
    }
}

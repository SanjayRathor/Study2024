//
//  SecurityUpdatesViewController.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 12/01/20.
//  Copyright © 2020 Sanjay Singh Rathor. All rights reserved.
//

import UIKit

class SecurityUpdatesViewController: SRBaseViewController {
    
    private let kUpdatesIdentifier = "SecurityUpdatesTableViewCell"
    private let kHeaderIdentifier:String = "SecurityUpdatesHeader"
    
    @IBOutlet weak var tableView: UITableView!
    var flInterests:FLSecurityUpdatesModel? = nil
    var interests: [SecurityUpdate] = []
    
    var userId:String = ""
    var campaignId:String = ""
    
    public var launchDashboardCallback: (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView.init()
        self.tableView.register(UINib.init(nibName: "SecurityUpdatesTableViewCell", bundle: nil), forCellReuseIdentifier: kUpdatesIdentifier)
        self.tableView.register(UINib.init(nibName: "SecurityUpdatesHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: kHeaderIdentifier)
        
        if let profileInfo = RepositoryManager.shared.getProfileData() {
            userId = profileInfo.userId
            self.getUpdates(userId: profileInfo.userId)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension SecurityUpdatesViewController:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return interests.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: kHeaderIdentifier) as? SecurityUpdatesHeader else {
            return nil
        }
        let model = interests[section]
        
        let defaultEnddate  = DateFormatter.endDateFormatter.date(from: model.dateUpdate)
        if let endTime  = defaultEnddate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .none
            view.textLabel?.text =   dateFormatter.string(from:endTime)
        }
        

        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: kUpdatesIdentifier, for: indexPath) as? SecurityUpdatesTableViewCell else {
            fatalError("Unable to Dequeue Reusable Table View Cell")
        }
        
        let models = interests[indexPath.section]
        cell.configureUpdates(interest: models)
        
        
        return cell
    }
}

extension SecurityUpdatesViewController {
    
    func getUpdates(userId:String) {
        self.presentCustomActivity()
        
        var userInfo:[String:Any] = [
            "CampaignId" : campaignId
        ]
        
        userInfo.append(anotherDict: SRUtilities.sharedInstance().extraPostParams())
        SRDataManager.sharedInstance().performNetworkCodablePostRequest(requestURL: API.getSecurityUpdateMasterURL, postData: userInfo) { (result) -> Void in
            
            switch (result) {
            case .success(let json):
                self.dismissCustomActivity()
                self.flInterests = try? JSONDecoder().decode(FLSecurityUpdatesModel.self, from: json as! Data)
                
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
    
    
    
    func submitInterests(userId:String, interests:String) {
        self.presentCustomActivity()
        var userInfo:[String:Any] = ["userId": userId,
                                     "interestId": interests]
        userInfo.append(anotherDict: SRUtilities.sharedInstance().extraPostParams())
        
        SRDataManager.sharedInstance().performNetworkServiceRequest(requestURL: API.submitInterestURL, postData: userInfo) { (result) -> Void in
            switch (result) {
            case .success(let json):
                self.dismissCustomActivity()
                
                if let result:[String:Any] = json as? Dictionary {
                    self.parseSignInJSON(json: result)
                } else {
                    self.showAlertWith(title:"", message:AlertMessages.GeneralErrorMsg)
                }
                break
            case .failure(let error):
                self.showAlertWith(title:"", message:error)
                self.dismissCustomActivity()
                break;
            }
        }
    }
}
extension SecurityUpdatesViewController {
    
    func parseSignInJSON(json:[String:Any]) {
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
    }
}

extension SecurityUpdatesViewController {
    
    @IBAction func submitButtonDidClicked(_ sender: Any) {
        
    }
}

//
//  SecurityDocumentsViewController.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 16/01/20.
//  Copyright © 2020 Sanjay Singh Rathor. All rights reserved.
//

import UIKit

class SecurityDocumentsViewController: SRBaseViewController {
    
    private let kDocumentsIdentifier = "DocumentsTableViewCell"
    @IBOutlet weak var tableView: UITableView!
    var flInterests:SLDocumentInfo? = nil
    var interests: [DocumentInfo] = []
    
    var userId:String = ""
    var campaignId:String = ""
    
    public var launchDashboardCallback: (()->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView.init()
        self.tableView.register(UINib.init(nibName: "DocumentsTableViewCell", bundle: nil), forCellReuseIdentifier: kDocumentsIdentifier)
        
        if let profileInfo = RepositoryManager.shared.getProfileData() {
            userId = profileInfo.userId
            self.getUpdates(userId: profileInfo.userId)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension SecurityDocumentsViewController:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interests.count;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let models = interests[indexPath.row]
        let storyboard = UIStoryboard(storyboard: .sharedBoard)
        let viewController = storyboard.instantiateViewController(withIdentifier: "DocumentsViewerController") as! DocumentsViewerController
        viewController.requestURL = models.documentPath
        viewController.titleNameText = models.documentName
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: kDocumentsIdentifier, for: indexPath) as? DocumentsTableViewCell else {
            fatalError("Unable to Dequeue Reusable Table View Cell")
        }
        
        let models = interests[indexPath.row]
        cell.configureDoc(document: models)
        return cell
    }
}

extension SecurityDocumentsViewController {
    
    func getUpdates(userId:String) {
        self.presentCustomActivity()
        
        var userInfo:[String:Any] = [
            "CampaignId" : campaignId
            //"UserId" : userId
        ]
        
        userInfo.append(anotherDict: SRUtilities.sharedInstance().extraPostParams())
        SRDataManager.sharedInstance().performNetworkCodablePostRequest(requestURL: API.getSecurityDocumentMasterURL, postData: userInfo) { (result) -> Void in
            
            switch (result) {
            case .success(let json):
                self.dismissCustomActivity()
                self.flInterests = try? JSONDecoder().decode(SLDocumentInfo.self, from: json as! Data)
                
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

extension SecurityDocumentsViewController {
    @IBAction func submitButtonDidClicked(_ sender: Any) {
        
    }
}

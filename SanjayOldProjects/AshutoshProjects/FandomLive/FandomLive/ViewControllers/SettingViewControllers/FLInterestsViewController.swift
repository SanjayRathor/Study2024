//
//  FLInterestsViewController.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 11/11/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit

class FLInterestsViewController: SRBaseViewController {
    
    
    private let kInterestIdentifier = "FLInterestTableViewCell"
    private let kHeaderIdentifier:String = "SREventSectionHeader"
    
    @IBOutlet weak var barButton: UIBarButtonItem!
    var hideSkip:Bool = true
    @IBOutlet weak var tableView: UITableView!
    var flInterests:FLInterests? = nil
    var interests: [Interests] = []
    var userId:String = ""
    
    @IBOutlet weak var submitButton: UIButton!
    
    
    //let skipButton = UIBarButtonItem.init(title: "Skip", style: .plain, target: self, action: #selector(skipButtonDidClicked))
    
    public var launchDashboardCallback: (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitButton.setGradientImage(for: .normal)
        tableView.tableFooterView = UIView.init()
        self.tableView.register(UINib.init(nibName: "FLInterestTableViewCell", bundle: nil), forCellReuseIdentifier: kInterestIdentifier)
        self.tableView.register(UINib.init(nibName: "SREventSectionHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: kHeaderIdentifier)
        
        if let profileInfo = RepositoryManager.shared.getProfileData() {
            userId = profileInfo.userId
            self.getInterests(userId: profileInfo.userId)
        }
        
        if !hideSkip {
            configureSkip()
        }
    }
    
    func configureSkip() {
        let logoutButton = UIButton(type: .custom)
        logoutButton.setTitle("Skip", for: .normal)
        logoutButton.setTitleColor(UIColor.white, for: .normal)
        let barButton =  UIBarButtonItem(customView: logoutButton)
        logoutButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = barButton
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension FLInterestsViewController:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return interests.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let model = interests[section]
        return model.interestData.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let model = interests[section]
        return model.categoryName
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: kHeaderIdentifier) as? SREventSectionHeader else {
            return nil
        }
        let model = interests[section]
        view.textLabel?.text = model.categoryName
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: kInterestIdentifier, for: indexPath) as? FLInterestTableViewCell else {
            fatalError("Unable to Dequeue Reusable Table View Cell")
        }
        
        let models = interests[indexPath.section]
        let interest:InterestDatum = models.interestData[indexPath.row]
        cell.configureInterests(interest: interest)
        
        
        return cell
    }
}

extension FLInterestsViewController {
    
    func getInterests(userId:String) {
        
        self.presentCustomActivity()
        
        var userInfo:[String:Any] = ["userId": userId]
        userInfo.append(anotherDict: SRUtilities.sharedInstance().extraPostParams())
        
        SRDataManager.sharedInstance().performNetworkCodablePostRequest(requestURL: API.getInterestURL, postData: userInfo) { (result) -> Void in
            switch (result) {
            case .success(let json):
                self.dismissCustomActivity()
                self.flInterests = try? JSONDecoder().decode(FLInterests.self, from: json as! Data)
                
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
extension FLInterestsViewController {
    
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
        
        if !hideSkip {
            launchDashboardCallback?()
            self.dismiss(animated: false, completion: nil)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension FLInterestsViewController {
    
    @IBAction func submitButtonDidClicked(_ sender: Any) {
        var idsArray = Array<String>()
        self.interests.forEach { interests in
            interests.interestData.forEach { (interestsId) in
                if interestsId.status == 1 {
                    idsArray.append("\(interestsId.id)")
                }
            }
        }
        
        if idsArray.count > 0 {
            self.submitInterests(userId: userId, interests: idsArray.joined(separator: ","))
        }
    }
    
    @IBAction func skipButtonDidClicked(_ sender: Any) {
        launchDashboardCallback?()
    }
    
    @objc @IBAction func skipButtonDidClicked() {
        launchDashboardCallback?()
    }
    @objc func addTapped() {
        launchDashboardCallback?()
    }
}

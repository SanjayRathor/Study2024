//
//  DashboardViewController.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 01/10/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit
import SVProgressHUD

let kHeaderIdentifier:String = "SREventSectionHeader"
let kBannerIdentifier:String = "BannersTableViewCell"
let kTrendingIdentifier:String = "TrendingEventsTableViewCell"
let kLatestIdentifier:String = "LatestNewsTableViewCell"

class DashboardViewController: SRBaseViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var dashBoardItem:FLDashBoard? = nil
    var serachResults:FLSearchResults? = nil
    
    @IBOutlet weak var tableView: UITableView!
    var dataSections: [DashBoardSection] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.backgroundColor = UIColor.clear
        registerCells ()
        
        let view: UIView = self.searchBar.subviews[0] as UIView
        let subViewsArray = view.subviews
        
        for subView: UIView in subViewsArray {
            if ((subView as? UITextField) != nil) {
                subView.tintColor = UIColor.black
            }
        }
        
        var userId:String = ""
        if let profileInfo =   RepositoryManager.shared.getProfileData() {
            userId = profileInfo.userId
        }
        self.getCampaigns(userId: userId)
    }
    
    func registerCells () {
        
        self.tableView.register(UINib.init(nibName: "SREventSectionHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: kHeaderIdentifier)
        
        self.tableView.register(UINib.init(nibName:"BannersTableViewCell", bundle: nil), forCellReuseIdentifier:kBannerIdentifier)
        
        self.tableView.register(UINib.init(nibName: "TrendingEventsTableViewCell", bundle: nil), forCellReuseIdentifier: kTrendingIdentifier)
        
        self.tableView.register(UINib.init(nibName: "LatestNewsTableViewCell", bundle: nil), forCellReuseIdentifier: kLatestIdentifier)
        
    }
}

extension DashboardViewController:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let model = dataSections[section]
        return model.cellModels.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = dataSections[section]
        return section.title
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: kHeaderIdentifier) as? SREventSectionHeader else {
            return nil
        }
        view.textLabel?.text = dataSections[section].title
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return 0.0
        }
        return 60.0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return 184.0
        } else if (indexPath.section == 1) {
            return 280.0
        }
        return 130.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellModel = dataSections[indexPath.section].cellModels[indexPath.row]
        switch cellModel {
        case .Banners(let banners):
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: kBannerIdentifier, for: indexPath) as? BannersTableViewCell else {
                fatalError("Unable to Dequeue Reusable Table View Cell")
            }
            cell.configureBanners(banners: banners.banners)
            cell.didClickedCallback = { bannerIndex in
            }
            
            return cell
        case .Trendings(let voting):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: kTrendingIdentifier, for: indexPath) as? TrendingEventsTableViewCell else {
                fatalError("Unable to Dequeue Reusable Table View Cell")
            }
            cell.configureTrendingEvents(campaigns: voting.votingcampaign)
            cell.didClickedCampaignCallback = { campaign in
                self.goToVotingsVC(votingcampaign: campaign)
            }
            cell.didShareCallback = { [weak self] shareString in
                self?.shareTapped(shareString: shareString)
            }
            
            return cell
        case .Latest(let latests):
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier:kLatestIdentifier, for: indexPath) as? LatestNewsTableViewCell else {
                fatalError("Unable to Dequeue Reusable Table View Cell")
            }
            cell.configureCell(latest: latests)
            return cell
        }
    }
}

extension DashboardViewController {
    
    func getCampaigns(userId:String) {
        self.presentCustomActivity()
        
        let campURLString = String(format: API.getCampaignURL, userId)
        SRDataManager.sharedInstance().performNetworkGETServiceRequestWithData(requestURL:campURLString) { (result) -> Void in
            switch (result) {
            case .success(let jsonData):
                self.dismissCustomActivity()
                self.dashBoardItem = try? JSONDecoder().decode(FLDashBoard.self, from: jsonData as! Data)
                
                guard self.dashBoardItem != nil  else {
                    self.tableView .setNoDataPlaceholder(AlertMessages.GeneralErrorMsg)
                    return
                }
                
                self.dataSections =  self.preapareDashBoard()
                
                break
            case .failure(let error):
                self.tableView.setNoDataPlaceholder(error)
                self.dismissCustomActivity()
                self.presentWithMessage(error as NSString)
                break;
            }
        }
    }
    
    func preapareDashBoard() ->[DashBoardSection] {
        
        var sections = [DashBoardSection]()
        
        //Add banners section
        var bannersSection = DashBoardSection()
        bannersSection.title = ""
        if let banner = self.dashBoardItem?.results.banner {
            bannersSection.cellModels.append(FeedItem.Banners(BannersModel(banners: banner)))
            sections.append(bannersSection)
        }
        
        //Add voting campaign section
        var trendingSection = DashBoardSection()
        trendingSection.title = "Trending Events"
        if let campaign = self.dashBoardItem?.results.votingcampaign {
            trendingSection.cellModels.append(FeedItem.Trendings(TrendingModel(votingcampaign: campaign)))
            sections.append(trendingSection)
        }
        
        //Add latest news section
        var bottomSection = DashBoardSection()
        bottomSection.title = "Latest News"
        if let latestNews = self.dashBoardItem?.results.news {
            latestNews.forEach { newsItem in
                bottomSection.cellModels.append(FeedItem.Latest(newsItem))
            }
        }
        sections.append(bottomSection)
        return sections;
    }
}

extension DashboardViewController {
    /// Navigation
    func goToVotingsVC(votingcampaign:Votingcampaign) {
        
        if (!SRNetworkManager.sharedInstance().isNetworkReachible()) {
            SRUtilities.showToastMessage(AlertMessages.NetworkErrorMsg)
            return
        }
        
        if(!SRApplicationStates.isUserLoggedIn()){
            AppCoordinator.promptUserForSignIn()
            return
        }
        
        
        let storyboard = UIStoryboard(storyboard: .main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "VotingsViewController") as! VotingsViewController
        viewController.campaignId = "\(votingcampaign.id)"
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension DashboardViewController {
    
    func getSearchResults(searchText:String) {
        self.presentCustomActivity()
        let getSearchResults = String(format: API.getSearchURL, searchText)
        SRDataManager.sharedInstance().performNetworkGETServiceRequestWithData(requestURL: getSearchResults) { (result) -> Void in
            switch (result) {
            case .success(let jsonData):
                self.dismissCustomActivity()
                self.serachResults = try? JSONDecoder().decode(FLSearchResults.self, from: jsonData as! Data)
                
                guard self.serachResults != nil, self.serachResults?.status == "true"  else {
                    self.view.setNoDataMessage(AlertMessages.GeneralErrorMsg)
                    return
                }
                self.performSegue(withIdentifier: "searchControllerSegue", sender: self)
                
                break
            case .failure(let error):
                self.dismissCustomActivity()
                self.showToastMessage(error)
                break;
            }
        }
    }
}


extension DashboardViewController : UISearchBarDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchControllerSegue" {
            let viewController = segue.destination as! SearchResultsViewController
            viewController.searchTitle = self.searchBar.text!
            viewController.result = serachResults?.result
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if !searchBar.text!.isEmpty {
            self.getSearchResults(searchText: searchBar.text!)
        }
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //searchBar.showsCancelButton = true
    }
    
    
}

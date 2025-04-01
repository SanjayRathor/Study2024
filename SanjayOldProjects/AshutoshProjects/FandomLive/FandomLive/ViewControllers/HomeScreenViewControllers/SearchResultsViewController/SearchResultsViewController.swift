//
//  SearchResultsViewController.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 05/11/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit

class SearchResultsViewController: SRBaseViewController {
    
    fileprivate let kTrendingIdentifier:String = "TrandingCollectionViewCell"
    fileprivate let kTeamsIdentifier:String = "TeamsCollectionViewCell"
    fileprivate let kArtistIdentifier:String = "ArtistCollectionViewCell"
    fileprivate let kHeaderIdentifier:String = "searchHeaderReusableView"
    
    
    @IBOutlet weak var serachResults: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var result: SearchResult? = nil
    var searchTitle:String = ""
    
    var dataSections: [SearchResultSections] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = searchTitle
        
        self.dataSections =  self.preapareSerachResult()
        configureCollectionView()
        prepareItemSize();
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        prepareItemSize()
    }
    
    func prepareItemSize() {
        
        if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            
            let screenSize =  UIScreen.main.bounds
            flowLayout.minimumInteritemSpacing = 10.0
            flowLayout.minimumLineSpacing = 10.0
            flowLayout.sectionInset = UIEdgeInsets.init(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
            var itemWidth:Float =  Float(screenSize.size.width - 30);
            itemWidth = itemWidth/2;
            flowLayout.itemSize =  CGSize(width: CGFloat(itemWidth), height: 280);
        }
    }
}

extension SearchResultsViewController {
    
    func preapareSerachResult() ->[SearchResultSections] {
        
        var sections = [SearchResultSections]()
        guard let searchResults = result  else {
            self.collectionView.setNoDataMessage("No Reasults")
            return sections
        }
        
        serachResults.text = "Found \(searchResults.artist.count+searchResults.team.count+searchResults.campaign.count) results"
        if (searchResults.artist.count > 0) {
            var artistsModel  = SearchResultSections()
            artistsModel.title = "Artist"
            searchResults.artist.forEach { artist in
                artistsModel.cellModels.append(SearchItem.Artists(artist))
            }
            sections.append(artistsModel)
        }
        
        if (searchResults.campaign.count > 0) {
            var campaignModel  = SearchResultSections()
            campaignModel.title = "Campaign"
            searchResults.campaign.forEach { campaign in
                campaignModel.cellModels.append(SearchItem.Campaign(campaign))
            }
            sections.append(campaignModel)
        }
        
        if (searchResults.team.count > 0) {
            var teamModel  = SearchResultSections()
            teamModel.title = "Teams"
            searchResults.team.forEach { team in
                teamModel.cellModels.append(SearchItem.Team(team))
            }
            sections.append(teamModel)
        }
        return sections;
    }
}

extension SearchResultsViewController : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.collectionView.register(UINib.init(nibName: "TrandingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: kTrendingIdentifier)
        self.collectionView.register(UINib.init(nibName: "ArtistCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: kArtistIdentifier)
        self.collectionView.register(UINib.init(nibName: "TeamsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: kTeamsIdentifier)
        
        self.collectionView.register(UINib.init(nibName: "SearchHeaderReusableView", bundle: .main), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kHeaderIdentifier)
               
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let model = dataSections[section]
        return model.cellModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellModel = dataSections[indexPath.section].cellModels[indexPath.row]
        
        switch cellModel {
            
        case .Campaign(let campaign):
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kTrendingIdentifier, for: indexPath) as! TrandingCollectionViewCell
            cell.applyShadow()
            cell.configureCampaignCell(cellModel: campaign)
            cell.didShareCallback = { shareString in
                self.shareTapped(shareString: shareString)
            }
            return cell
        case .Artists(let artists):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kArtistIdentifier, for: indexPath) as! ArtistCollectionViewCell
            cell.configureArtistCell(cellModel: artists)
            return cell
            
        case .Team(let team):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kTeamsIdentifier, for: indexPath) as! TeamsCollectionViewCell
            cell.configureTeamCell(cellModel: team)
            return cell
        }
    }
    
     func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kHeaderIdentifier, for: indexPath) as! SearchHeaderReusableView
        
        headerView.headerTitle.text = dataSections[indexPath.section].title
        return headerView
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 50)
       }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellModel = dataSections[indexPath.section].cellModels[indexPath.row]
        switch cellModel {
        case .Campaign(let campaign):
            goToVotingsVC(campaignId: campaign.id)
            break

        case .Artists(_): break
            
        case .Team(_): break
        }
        
    }
}

extension SearchResultsViewController {
    /// Navigation
    func goToVotingsVC(campaignId:Int) {
        
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
        viewController.campaignId = "\(campaignId)"
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

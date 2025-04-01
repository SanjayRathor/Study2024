//
//  CampaignsVotingsSecurityController.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 07/12/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit

class CampaignsVotingsSecurityController: SRBaseViewController {
    
    fileprivate let kTrendingCollectionIdentifier:String = "SecurityCollectionViewCell"
    
    var jsonModelItem:FLSecurityModel? = nil
    var favoriteItems:[Securitycampaign] = []
    
    var campaignId:String = ""
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        prepareItemSize();
        if let userId = RepositoryManager.shared.userProfile?.userId {
            self.getCampaigns(userId: userId)
        }
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
            flowLayout.itemSize =  CGSize(width: CGFloat(itemWidth), height: 285);
        }
    }
}


extension CampaignsVotingsSecurityController : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.collectionView.register(UINib.init(nibName: "SecurityCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: kTrendingCollectionIdentifier)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteItems.count;
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kTrendingCollectionIdentifier, for: indexPath) as! SecurityCollectionViewCell
            cell.configureRewordCell(cellModel: self.favoriteItems[indexPath.row])
            cell.didShareCallback = { shareString in
                self.shareTapped(shareString: shareString)
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let votingcampaign = self.favoriteItems[indexPath.row]
        self.goToVotingsVC(campaignId: votingcampaign.id)
        
    }
}

extension CampaignsVotingsSecurityController {
    
    func getCampaigns(userId:String) {
        self.presentCustomActivity()
         let otpURLString = String(format: API.getSecurityCampaignURL, userId)
        SRDataManager.sharedInstance().performNetworkGETServiceRequestWithData(requestURL: otpURLString) { (result) -> Void in
            switch (result) {
            case .success(let jsonData):
                self.dismissCustomActivity()
                
                do {
                    self.jsonModelItem = try JSONDecoder().decode(FLSecurityModel.self, from: jsonData as! Data)
                } catch let error {
                    print(error)
                }
                
                guard let items = self.jsonModelItem?.result, items.count > 0  else {
                    self.collectionView.setNoDataPlaceholder(AlertMessages.EmptyErrorMsg)
                    return
                }
                self.favoriteItems.removeAll()
                if let models = items.first {
                    self.favoriteItems += models.securitycampaign
                }
                self.collectionView.reloadData()
                break
            case .failure(let error):
                self.dismissCustomActivity()
                self.presentWithMessage(error as NSString)
                break;
            }
        }
    }
}




extension CampaignsVotingsSecurityController {
    /// Navigation
    func goToVotingsVC(campaignId:Int) {
        
//        if (!SRNetworkManager.sharedInstance().isNetworkReachible()) {
//            SRUtilities.showToastMessage(AlertMessages.NetworkErrorMsg)
//            return
//        }
//
        if(!SRApplicationStates.isUserLoggedIn()){
            AppCoordinator.promptUserForSignIn()
            return
        }
        
        
        let storyboard = UIStoryboard(storyboard: .sharedBoard)
        let viewController = storyboard.instantiateViewController(withIdentifier: "CampaignsSecurityDetailViewController") as! CampaignsSecurityDetailViewController
        viewController.campaignId = "\(campaignId)"
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

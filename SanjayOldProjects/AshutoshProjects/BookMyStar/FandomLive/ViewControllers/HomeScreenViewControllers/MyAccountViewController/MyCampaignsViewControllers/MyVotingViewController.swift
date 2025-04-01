//
//  MyVotingViewController.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 22/10/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit

class MyVotingViewController: SRBaseViewController {
    
    fileprivate let kTrendingCollectionIdentifier:String = "TrandingCollectionViewCell"
    
    var dashBoardItem:FLMyVotingModel? = nil
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
            flowLayout.itemSize =  CGSize(width: CGFloat(itemWidth), height: 280);
        }
    }
}


extension MyVotingViewController : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.collectionView.register(UINib.init(nibName: "TrandingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: kTrendingCollectionIdentifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dashBoardItem?.result.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kTrendingCollectionIdentifier, for: indexPath) as! TrandingCollectionViewCell
        
        if let votingcampaign = self.dashBoardItem?.result[indexPath.row] {
            cell.configureMyVotingCell(cellModel: votingcampaign)
        }
        
        cell.didShareCallback = { shareString in
            self.shareTapped(shareString: shareString)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension MyVotingViewController {
    
    func getCampaigns(userId:String) {
        self.presentCustomActivity()
        
        let otpURLString = String(format: API.getmyCampaignURL, userId)
        SRDataManager.sharedInstance().performNetworkGETServiceRequestWithData(requestURL: otpURLString) { (result) -> Void in
            switch (result) {
            case .success(let jsonData):
                self.dismissCustomActivity()
                self.dashBoardItem = try? JSONDecoder().decode(FLMyVotingModel.self, from: jsonData as! Data)
                
                guard self.dashBoardItem?.result != nil  else {
                    self.collectionView.setNoDataPlaceholder(AlertMessages.GeneralErrorMsg)
                    return
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

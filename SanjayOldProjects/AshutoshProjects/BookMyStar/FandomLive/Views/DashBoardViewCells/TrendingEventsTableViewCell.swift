//
//  TrendingEventsTableViewCell.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 09/10/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit



class TrendingEventsTableViewCell: UITableViewCell {
    
    fileprivate let kTrendingCollectionIdentifier:String = "TrandingCollectionViewCell"
    
    public var didClickedCampaignCallback: ((Votingcampaign)->())?
    public var didShareCallback: ((String)->())?
    
    @IBOutlet weak var collectionView: UICollectionView!
    static let reuseIdentifier: String = String(describing: self)
    
    var campaigns:[Votingcampaign] = []
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.configureCollectionView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView.register(UINib.init(nibName: "TrandingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: kTrendingCollectionIdentifier)
    }
    
    func configureTrendingEvents(campaigns:[Votingcampaign]) {
        self.campaigns = campaigns
    }
    
}

extension TrendingEventsTableViewCell : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return campaigns.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kTrendingCollectionIdentifier, for: indexPath) as! TrandingCollectionViewCell
        cell.applyShadow()
        cell.configureVotingCell(cellModel: campaigns[indexPath.item])
        cell.didShareCallback = { [weak self] (sareString) in
            self?.didShareCallback?(sareString)
        }
//        cell.didTrandingShareCallback = {[weak self] votingCompain in
//            self?.shareButtonClicked(itemInfo: votingCompain)
//        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 182.0, height: 272.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didClickedCampaignCallback?(self.campaigns[indexPath.row])
    }
    
}

extension TrendingEventsTableViewCell {
    
    func likedButtonClicked (itemInfo:Votingcampaign) {
        
    }
    
    func shareButtonClicked (itemInfo:Votingcampaign) {
        
    }
}

//
//  FollowersView.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 02/11/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit

class FollowersView: UIView {
    
    fileprivate let kFollowersCollectionIdentifier:String = "FollowedCollectionViewCell"
    
    @IBOutlet var contentView:UIView!
    @IBOutlet weak var mainTitle: UILabel!
    var mainArtistId = ""
    
    var teams: [Followed]?
    var main: [Followed]?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mainArtistImge: UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("FollowersView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.collectionView.register(UINib.init(nibName: "FollowedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: kFollowersCollectionIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @IBAction func chooseArtistsClicked(_ sender: Any) {
        
        let storyboard = UIStoryboard(storyboard: .main)
        let customAlert = storyboard.instantiateViewController(withIdentifier: "TeamsViewController") as! TeamsViewController
        customAlert.teams  = self.main
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        customAlert.delegate = self
        UIApplication.shared.topMostViewController()?.present(customAlert, animated: true, completion: nil)
        
    }
    
    func reloadItems(items:Concert) {
        self.main = items.main
        self.teams = items.followed
        self.collectionView.reloadData()
    }
}

extension FollowersView : TeamsViewControllerDelegate {
    func teamButtonTapped(teamId: Int, teamName: String, imageURL: String) {
        self.mainArtistId = "\(teamId)"
        mainTitle.text = teamName;
        let url = URL(string: (imageURL))
        mainArtistImge.kf.setImage(with: url, placeholder:UIImage.init(named: "teamChoose"))
        mainArtistImge.contentMode = .scaleToFill
        mainArtistImge.setNeedsDisplay()
    }
}

extension FollowersView : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teams?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kFollowersCollectionIdentifier, for: indexPath) as! FollowedCollectionViewCell
        
        if let followed = teams?[indexPath.row] {
            cell.configureCell(title: followed.name, imageUrl: followed.imagePath ?? "")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 85)
    }
    
    
}

//
//  SelectRewardsViewController.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 12/12/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit

class SelectRewardsViewController: SRBaseViewController {
    var nextBarButton: UIBarButtonItem?
    let kRewardCellConstatnt = "SelectRewardCollectionViewCell"
    @IBOutlet weak var collectionView: UICollectionView!
    
    var forumsModels:FLPackagesModel? = nil
    var packages:[Packages] = []
    var campaignId:String = ""
    var detailsModel:RewardDetails!
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var quentityLabel: UILabel!
    @IBOutlet weak var totalamountLabel: UILabel!
    
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout! {
        didSet {
            collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        shadowView.isHidden = true
        nextBarButton?.isEnabled = false
        collectionView.register(UINib.init(nibName: "SelectRewardCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: kRewardCellConstatnt)
        collectionView.delegate = self;
        collectionView.dataSource = self;
        if let userId = RepositoryManager.shared.userProfile?.userId {
            self.getCampaigns(userId: userId)
        }
        
        let nextButton =  UIButton.init(type: .custom)
        nextButton.addTarget(self, action: #selector(nextButtonDidClicked), for: .touchUpInside)
        nextButton.setTitle("DONE", for: .normal)
        nextButton.setTitleColor(UIColor.darkGray, for: .normal)
        nextButton.sizeToFit()
        nextBarButton = UIBarButtonItem.init(customView: nextButton)
        navigationItem.rightBarButtonItems = [(nextBarButton!)]
        shadowView.castShadow(withPosition: SCShadowEdgeTop)
    }
    
   @objc @IBAction func nextButtonDidClicked() {
        var isPackageSelected = false
        packages.forEach { (package) in
            if package.isSlected == 1 {
                isPackageSelected = true
            }
        }
        if (isPackageSelected == false) {
          self.showAlertWith(title:"", message:AlertMessages.PackageErrorMsg)
        } else {
            detailsModel.isMakeDone = 1
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}


extension SelectRewardsViewController : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return packages.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kRewardCellConstatnt, for: indexPath) as! SelectRewardCollectionViewCell
        cell.configurePlanCell(plan: packages[indexPath.item])
        return cell
    }
    
   
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenSize =  UIScreen.main.bounds
        let itemWidth:Float =  Float(screenSize.size.width - 20);
        return  CGSize(width: CGFloat(itemWidth), height: 20);
    }
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        nextBarButton?.isEnabled = true
        packages.forEach { (package) in
            package.isSlected = 0
        }
        shadowView.isHidden = false
        let pacage:Packages = packages[indexPath.row]
        pacage.isSlected = 1
        quentityLabel.text = "Package \(pacage.campaignID)"
        totalamountLabel.text = "\(pacage.amount)"
        self.collectionView.reloadData()
    }
    
}

extension SelectRewardsViewController {
    
    func getCampaigns(userId:String) {
        
        self.presentCustomActivity()
        var userInfo:[String:Any] = ["userId": userId, "CampaignId" : campaignId]
        userInfo.append(anotherDict: SRUtilities.sharedInstance().extraPostParams())
        SRDataManager.sharedInstance().performNetworkCodablePostRequest(requestURL: API.getRewardPackageURL, postData: userInfo) { (result) -> Void in
            switch (result) {
            case .success(let json):
                self.dismissCustomActivity()
                self.forumsModels = try? JSONDecoder().decode(FLPackagesModel.self, from: json as! Data)
                if let interests = self.forumsModels?.result {
                    self.packages += interests
                    self.collectionView.reloadData()
                    
                } else {
                    self.dismissCustomActivity()
                }
                
                break
            case .failure(let error):
                self.dismissCustomActivity()
                self.showToastMessage(error)
                break;
            }
        }
    }
}


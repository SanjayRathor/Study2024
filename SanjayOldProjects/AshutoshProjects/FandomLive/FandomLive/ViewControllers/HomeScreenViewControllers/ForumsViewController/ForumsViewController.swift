//
//  ForumsViewController.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 16/10/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit

fileprivate let kForumIdentifier:String = "ForumCollectionViewCell"

class ForumsViewController: SRBaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var forumsModels:FLForumList? = nil
    var forums:[ForumItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let profileInfo = RepositoryManager.shared.getProfileData() {
            self.getForum(userId: profileInfo.userId)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (!SRApplicationStates.isUserLoggedIn()) {
            let viewController =  AppCoordinator.getLoginScreenController()
            self.present(viewController, animated: true, completion: nil)
            
        } 
    }
    
}

extension ForumsViewController:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forums.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kForumIdentifier, for: indexPath) as! ForumCollectionViewCell
        cell.configuerForums(itemInfo: forums[indexPath.row])
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
         let storyboard = UIStoryboard(storyboard: .main)
         let viewController = storyboard.instantiateViewController(withIdentifier: "ForumDetailsViewController") as! ForumDetailsViewController
         viewController.forum = forums[indexPath.row]
         self.navigationController?.hidesBottomBarWhenPushed = true
         self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.size.width-20, height: 85)
       }
}

extension ForumsViewController {
    
    func getForum(userId:String) {
        
        self.presentCustomActivity()
        
        var userInfo:[String:Any] = ["userId": userId]
        userInfo.append(anotherDict: SRUtilities.sharedInstance().extraPostParams())
        
        SRDataManager.sharedInstance().performNetworkCodablePostRequest(requestURL: API.getforumThreardURL, postData: userInfo) { (result) -> Void in
            switch (result) {
            case .success(let json):
                self.dismissCustomActivity()
                
                self.forumsModels = try? JSONDecoder().decode(FLForumList.self, from: json as! Data)
                
                if let interests = self.forumsModels?.result {
                    self.forums += interests
                    self.collectionView.reloadData()
                } else {
                    self.dismissCustomActivity()
                    self.collectionView .setNoDataPlaceholder(AlertMessages.GeneralErrorMsg)
                }
                break
            case .failure(let error):
                self.collectionView.setNoDataPlaceholder(error)
                self.dismissCustomActivity()
                self.presentWithMessage(error as NSString)
                break;
            }
        }
    }
}

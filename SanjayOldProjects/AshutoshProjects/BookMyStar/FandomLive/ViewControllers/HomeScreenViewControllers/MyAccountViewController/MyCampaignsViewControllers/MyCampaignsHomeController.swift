//
//  MyCampaignsHomeController.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 23/10/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit
import SJSegmentedScrollView

class MyCampaignsHomeController: SJSegmentedViewController {
    
    var selectedSegment: SJSegmentTab?
    override func viewDidLoad() {
        prepareController()
        super.viewDidLoad()
        self.navigationItem.title = "Campaigns"
        
    }
    
    func prepareController() {
        let storyboard = UIStoryboard(storyboard: .sharedBoard)
        
        let votingController = storyboard
            .instantiateViewController(withIdentifier: "MyVotingViewController")
        votingController.title = "Voting"
        
        let rewardController = storyboard
            .instantiateViewController(withIdentifier: "MyRewardViewController")
        rewardController.title = "Reward"
        
        
        let launchpadViewController = storyboard
            .instantiateViewController(withIdentifier: "MyLaunchpadViewController")
        launchpadViewController.title = "Launchpad"
        
        let favoritesViewController = storyboard
            .instantiateViewController(withIdentifier: "MyFavoritesViewController")
        favoritesViewController.title = "Favorites"
        
        segmentControllers = [votingController,
                              rewardController,
                              launchpadViewController,
                              favoritesViewController]
        
        selectedSegmentViewHeight = 2.0
        segmentTitleColor = UIColor.lightGray
        selectedSegmentViewColor = UIColor.init(red: 63, green: 63, blue: 63)
        segmentViewHeight = 40
        headerViewHeight = 0;
        segmentShadow = SJShadow.light()
        segmentBounces = false
        delegate = self
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension MyCampaignsHomeController: SJSegmentedViewControllerDelegate {
    
    func didMoveToPage(_ controller: UIViewController, segment: SJSegmentTab?, index: Int) {
        
        if selectedSegment != nil {
            selectedSegment?.titleColor(.lightGray)
        }
        
        if segments.count > 0 {
            selectedSegment = segments[index]
            selectedSegment?.titleColor(UIColor.init(red: 63, green: 63, blue: 63))
        }
    }
}

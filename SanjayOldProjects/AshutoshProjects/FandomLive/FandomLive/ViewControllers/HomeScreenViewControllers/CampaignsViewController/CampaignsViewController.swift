//
//  CampaignsViewController.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 06/10/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit
import SJSegmentedScrollView

class CampaignsViewController: SJSegmentedViewController {
    
    var selectedSegment: SJSegmentTab?
    override func viewDidLoad() {
        prepareController()
        super.viewDidLoad()
        self.navigationItem.title = "Campaigns"
    }
    func prepareController() {
        let storyboard = UIStoryboard(storyboard: .sharedBoard)
        
        let votingController = storyboard
            .instantiateViewController(withIdentifier: "CampaignsVotingsViewController")
        votingController.title = "Voting"
        
        let rewardController = storyboard
            .instantiateViewController(withIdentifier: "CampaignsRewardsViewController")
        rewardController.title = "Reward"
        
        
        let launchpadViewController = storyboard
            .instantiateViewController(withIdentifier: "CampaignsVotingsSecurityController")
        launchpadViewController.title = "Security"
        
        
        segmentControllers = [votingController,
                              rewardController,
                              launchpadViewController]
        
        selectedSegmentViewHeight = 2.0
        segmentTitleColor = UIColor.lightGray
        selectedSegmentViewColor = UIColor.appthemeColor
        segmentTitleFont = UIFont(name: "Atami", size: 14)!
        segmentViewHeight = 40
        headerViewHeight = 0;
        segmentShadow = SJShadow.light()
        segmentBounces = false
        delegate = self
        
    }
}

extension CampaignsViewController: SJSegmentedViewControllerDelegate {
    
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

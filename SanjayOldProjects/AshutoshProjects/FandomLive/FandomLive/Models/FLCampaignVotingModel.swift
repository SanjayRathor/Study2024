//
//  FLCampaignVotingModel.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 07/12/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import Foundation

// MARK: - FLCampaignVotingModel
@objcMembers class FLCampaignVotingModel: NSObject, Codable {
    let message: String
    let result: [CampaignResult]
    let status: String

    init(message: String, campaignResults: [CampaignResult], status: String) {
        self.message = message
        self.result = campaignResults
        self.status = status
    }
}

// MARK: - CampaignResult
@objcMembers class CampaignResult: NSObject, Codable {
    let votingcampaign: [Votingcampaign]?

    init(votingcampaign: [Votingcampaign]) {
        self.votingcampaign = votingcampaign
    }
}


//
//  SRDashboadModel.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 10/10/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit

struct TrendingModel {
    var votingcampaign: [Votingcampaign] = []
}

struct BannersModel {
    var banners: [Banner] = []
}

enum FeedItem {
    case Banners(BannersModel)
    case Trendings(TrendingModel)
    case Latest(News)
}

struct DashBoardSection {
    var title: String = ""
    var cellModels: [FeedItem] = []
}

//Search Results Section
enum SearchItem {
    case Artists(ArtistModel)
    case Campaign(CampaignModel)
    case Team(TeamModel)
}

struct SearchResultSections {
    var title: String = ""
    var cellModels: [SearchItem] = []
}

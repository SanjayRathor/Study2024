//
//  RewardSetsTableViewCell.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 09/12/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit

class RewardSetsTableViewCell: UITableViewCell {

    @IBOutlet weak var includedText: NSLayoutConstraint!
    @IBOutlet weak var setTitle: UILabel!
    @IBOutlet weak var totalFandomLivers: UILabel!
    
    @IBOutlet weak var estimateddate: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var progressDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

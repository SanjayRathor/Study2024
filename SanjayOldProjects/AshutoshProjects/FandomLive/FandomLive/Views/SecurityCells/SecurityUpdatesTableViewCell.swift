//
//  SecurityUpdatesTableViewCell.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 12/01/20.
//  Copyright © 2020 Sanjay Singh Rathor. All rights reserved.
//

import UIKit


class SecurityUpdatesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var updateImageView: UIImageView!
    
    @IBOutlet weak var subNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var commentsLabel: UIButton!
    @IBOutlet weak var timeAgoLabel: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureUpdates(interest:SecurityUpdate) {
        nameLabel.text = interest.contentTitle
        subNameLabel.text = interest.resultDescription
        
        let url = URL(string: (interest.campImage))
        updateImageView.kf.setImage(with: url, placeholder:UIImage.init(named: "placeHolder_Interest"))
        commentsLabel.setTitle("  \(interest.totalcomments)", for: .normal)

        let defaultEnddate  = DateFormatter.endDateFormatter.date(from: interest.dateCreate)
        if let endTime  = defaultEnddate {
            var timeInveral = endTime.timeIntervalSince1970
            timeInveral =  NSDate().timeIntervalSince1970 - timeInveral
            timeInveral = timeInveral / 60.0;
        
            let agaLabel =   FandomUtility.init().calculatePostTime(from: "\(timeInveral)")
             timeAgoLabel.setTitle("  \(agaLabel)", for: .normal)
            
        }

        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

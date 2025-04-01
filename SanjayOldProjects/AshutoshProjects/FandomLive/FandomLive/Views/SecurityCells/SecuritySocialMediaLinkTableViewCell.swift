//
//  SecuritySocialMediaLinkTableViewCell.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 13/01/20.
//  Copyright © 2020 Sanjay Singh Rathor. All rights reserved.
//

import UIKit

class SecuritySocialMediaLinkTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mediaLinkName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureMediaLinks(media:MediaLink) {
        mediaLinkName.text = media.contentTitle + ": " + media.contentPath
    }
    
}

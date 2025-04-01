//
//  SecuritySocialMediaImageTableViewCell.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 13/01/20.
//  Copyright © 2020 Sanjay Singh Rathor. All rights reserved.
//

import UIKit

class SecuritySocialMediaImageTableViewCell: UITableViewCell {

    @IBOutlet weak var socialImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func configureMediaImage(media:SecurityImages) {
          let url = URL(string: (media.imagePath))
           socialImageView.kf.setImage(with: url, placeholder:UIImage.init(named: "placeHolder_Interest"))
    }
}

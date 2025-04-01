//
//  FollowedCollectionViewCell.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 02/11/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit

class FollowedCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(title:String, imageUrl:String) {
        let url = URL(string: (imageUrl))
        imageView?.kf.setImage(with: url, placeholder:UIImage.init(named: "team"))
        self.title.text = title
    }

}

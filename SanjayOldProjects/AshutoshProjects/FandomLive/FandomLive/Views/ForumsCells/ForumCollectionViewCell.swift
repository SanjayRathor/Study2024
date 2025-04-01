//
//  ForumCollectionViewCell.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 18/11/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit

class ForumCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var likedButton: UIButton!
    @IBOutlet weak var comentsButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var thumbImageView: UIImageView!
    
    func configuerForums(itemInfo:ForumItem) {
        self.applyShadow()
        let totalLiked = itemInfo.totalLike
        let totalcomments = itemInfo.totalcomments
        thumbImageView.layer.cornerRadius = 5;
        thumbImageView.layer.masksToBounds = true
        
        likedButton .setTitle("\(totalLiked)", for: .normal)
        comentsButton .setTitle("\(totalcomments)", for: .normal)
        nameLabel.text = itemInfo.topicName
        let url = URL(string: (itemInfo.banner))
        thumbImageView.kf.setImage(with: url, placeholder:UIImage.init(named: "placeHolder_Interest"))
        let defaultEnddate  = DateFormatter.endDateFormatter.date(from: itemInfo.date)
               
               if let endTime  = defaultEnddate {
                   let dateFormatter = DateFormatter()
                   dateFormatter.dateStyle = .medium
                   dateFormatter.timeStyle = .none
                   dateLabel.text = "Posted on \(dateFormatter.string(from: endTime))"
                  
               }
        
               
    }
    func applyShadow () {
        self.addShadow(color: UIColor.init(red: 219, green: 219, blue: 219), cornerRadius: 5)
    }
    
}

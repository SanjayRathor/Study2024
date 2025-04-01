//
//  LatestNewsTableViewCell.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 09/10/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit

class LatestNewsTableViewCell: UITableViewCell {
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    static let reuseIdentifier: String = String(describing: self)
    
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyShadow()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func applyShadow () {
        thumbImageView.addShadow(color: UIColor.init(red: 219, green: 219, blue: 219), cornerRadius: 10)
        thumbImageView.layer.cornerRadius = 10
        thumbImageView.layer.masksToBounds = true
    }
    
    func configureCell(latest:News) {
        applyShadow ()
        descLabel.text = latest.title
        dateLabel.text = latest.dateCreate
        let url = URL(string: (API.baseURL + latest.imagePath))
        thumbImageView.kf.setImage(with: url)
        
    }
}

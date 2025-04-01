//
//  ArtistCollectionViewCell.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 12/10/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit
import Kingfisher

class TeamsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var type: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        applyShadow()
    }
    
    func applyShadow () {
        self.addShadow(color: UIColor.init(red: 219, green: 219, blue: 219), cornerRadius: 20)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configureTeamCell(cellModel:TeamModel) {
        titleLabel.text = cellModel.name
        let url = URL(string: (cellModel.image))
        thumbImageView.kf.setImage(with: url)
        type.setTitle(cellModel.type, for: .normal)
        
    }
}

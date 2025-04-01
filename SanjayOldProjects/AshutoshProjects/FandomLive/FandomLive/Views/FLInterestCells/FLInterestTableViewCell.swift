//
//  FLInterestTableViewCell.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 11/11/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit

class FLInterestTableViewCell: UITableViewCell {
    
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var thumbImageView: UIImageView!
    
    var interest:InterestDatum!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func configureInterests(interest:InterestDatum) {
        self.interest = interest
        nameLabel.text = interest.name
        let url = URL(string: (interest.image))
        thumbImageView.kf.setImage(with: url, placeholder:UIImage.init(named: "placeHolder_Interest"))
        
        selectButton.isSelected = interest.status == 1 ? true : false
    }
    
    @IBAction func addButtonDidClicked(_ sender: Any) {
        selectButton.isSelected = !selectButton.isSelected
        self.interest.status = selectButton.isSelected  ? 1 : 0
    }
}

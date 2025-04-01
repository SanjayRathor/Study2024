//
//  PickerTableViewCell.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 02/11/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit

class PickerTableViewCell: UITableViewCell {

     @IBOutlet weak var thumb: UIImageView!
     @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

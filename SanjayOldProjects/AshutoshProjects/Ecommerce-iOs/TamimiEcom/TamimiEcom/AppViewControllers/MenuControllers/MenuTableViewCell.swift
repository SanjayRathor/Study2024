//
//  MenuTableViewCell.swift
//  TamimiEcom
//
//  Created by Ansh on 05/09/20.
//  Copyright © 2020  ltd. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    @IBOutlet weak var arrowImg: UIImageView!
    
    @IBOutlet weak var infoLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

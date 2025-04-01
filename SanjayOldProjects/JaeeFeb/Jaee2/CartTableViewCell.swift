//
//  CartTableViewCell.swift
//  Jaee2
//
//  Created by Abdulaziz  Almohsen on 7/1/17.
//  Copyright © 2017 Jaee. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class CartTableViewCell: MGSwipeTableCell {

  
    @IBOutlet weak var qty: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var nameofItem: UILabel!
    @IBOutlet weak var imageX: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

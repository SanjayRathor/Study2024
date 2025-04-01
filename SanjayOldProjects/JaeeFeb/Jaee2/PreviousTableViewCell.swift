//
//  PreviousTableViewCell.swift
//  Jaee2
//
//  Created by Abdulaziz  Almohsen on 6/27/17.
//  Copyright © 2017 Jaee. All rights reserved.
//

import UIKit


class PreviousTableViewCell: UITableViewCell {
    @IBOutlet weak var imageCell: UIImageView!
  

    @IBOutlet weak var date: UILabel!
 
    @IBOutlet weak var orderrNumber: UILabel!
    @IBOutlet weak var shopName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    }

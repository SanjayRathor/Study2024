//
//  SearchShopsTableViewCell.swift
//  Jaee2
//
//  Created by Abdulaziz  Almohsen on 12/14/17.
//  Copyright © 2017 Jaee. All rights reserved.
//

import UIKit

class SearchShopsTableViewCell: UITableViewCell {
    @IBOutlet weak var shopImage: UIImageView!
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

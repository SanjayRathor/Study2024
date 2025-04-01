//
//  ShopTableViewCell.swift
//  Jaee2
//
//  Created by Abdulaziz  Almohsen on 6/26/17.
//  Copyright © 2017 Jaee. All rights reserved.
//

import UIKit
import Cosmos
class ShopTableViewCell: UITableViewCell {

   
    @IBOutlet weak var shopImage: UIImageView!
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var star: CosmosView!
    @IBOutlet weak var time: UILabel!

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}

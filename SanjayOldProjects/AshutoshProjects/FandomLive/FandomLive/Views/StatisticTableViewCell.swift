//
//  StatisticTableViewCell.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 19/01/20.
//  Copyright © 2020 Sanjay Singh Rathor. All rights reserved.
//

import UIKit

class StatisticTableViewCell: UITableViewCell {
    @IBOutlet weak var percentageLabel: UILabel!
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var indexLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureStatistic(statistic:VStatistics, for indexNumber:Int) {
        let index = indexNumber + 1
        indexLabel.text = ("\(index).")
        countryNameLabel.text = statistic.name
        percentageLabel.text = statistic.percentCount
        let url = URL(string: (statistic.flagLogoLink))
        countryImage.kf.setImage(with: url, placeholder:nil)
        
    }
    
}

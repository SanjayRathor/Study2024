//
//  SecurityLegalDescription.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 14/01/20.
//  Copyright © 2020 Sanjay Singh Rathor. All rights reserved.
//

import UIKit

class SecurityLegalDescription: UITableViewCell {

    @IBOutlet weak var form: UILabel!
    @IBOutlet weak var legalName: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var formDate: UILabel!
    @IBOutlet weak var founder: UILabel!
    @IBOutlet weak var teamSize: UILabel!
    @IBOutlet weak var fundingRound: UILabel!
    @IBOutlet weak var capital: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var graphImage: UIImageView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureLegal(legal:SLegalModel) {
        
        legalName.text =  legal.legalCompanyName
        form.text =  legal.legalForm
        formDate.text =  legal.incorporatedDate
        number.text =  legal.registrationNo
        founder.text =  ("\(legal.founders)")
        teamSize.text =  legal.teamSize
        fundingRound.text =  legal.lastFundingRound
        capital.text =  ("\(legal.existingShares)")

        
    }
    
}

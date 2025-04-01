//
//  DocumentsTableViewCell.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 16/01/20.
//  Copyright © 2020 Sanjay Singh Rathor. All rights reserved.
//

import UIKit

class DocumentsTableViewCell: UITableViewCell {

    @IBOutlet weak var docTitlelabel: UILabel!
    @IBOutlet weak var docImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureDoc(document:DocumentInfo) {
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let underlineAttributedString = NSAttributedString(string: document.documentName, attributes: underlineAttribute)
        docTitlelabel.attributedText = underlineAttributedString
        
        if document.documentName.contains(".pdf") {
            docImageView.image = UIImage.init(named: "pdfDoc")
        } else {
            docImageView.image = UIImage.init(named: "medialink")
        }
    }
    
    
}

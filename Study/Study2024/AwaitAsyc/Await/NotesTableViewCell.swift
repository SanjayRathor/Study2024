//
//  NotesTableViewCell.swift
//  SWNotes
//
//  Created by Sanjay Rathor on 04/06/24.
//

import UIKit

class NotesTableViewCell: UITableViewCell {

    @IBOutlet weak var tumbImageView: UIImageView!
    @IBOutlet weak var notesTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}

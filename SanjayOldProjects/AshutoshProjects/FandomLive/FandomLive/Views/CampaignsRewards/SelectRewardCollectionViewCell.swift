//
//  SelectRewardCollectionViewCell.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 13/12/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit

class SelectRewardCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        applyShadow();
    }
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var amountDescTextView: UITextView!
    
    func applyShadow () {
        self.addShadow(color: UIColor.init(red: 219, green: 219, blue: 219), cornerRadius: 5)
    }
    
    func configurePlanCell(plan:Packages) {
        applyShadow();
        if plan.isSlected == 1 {
            
            amountLabel.text = "$ \(plan.amount)"
            amountLabel.textColor = UIColor.appthemeColor
            if let labelTextFormatted = plan.resultDescription.htmlToAttributedString {
                let textAttributes = [
                    NSAttributedString.Key.foregroundColor: UIColor.init(red: 0, green: 144, blue: 255),
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)
                    ] as [NSAttributedString.Key: Any]
                labelTextFormatted.addAttributes(textAttributes, range: NSRange(location: 0, length: labelTextFormatted.length))
                amountDescTextView.attributedText = labelTextFormatted
            }
            
        } else {
            
            amountLabel.textColor = UIColor.darkGray
            if let labelTextFormatted = plan.resultDescription.htmlToAttributedString {
                let textAttributes = [
                    NSAttributedString.Key.foregroundColor: UIColor.darkGray,
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)
                    ] as [NSAttributedString.Key: Any]
                labelTextFormatted.addAttributes(textAttributes, range: NSRange(location: 0, length: labelTextFormatted.length))
                amountDescTextView.attributedText = labelTextFormatted
            }
        }
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attr = layoutAttributes.copy() as! UICollectionViewLayoutAttributes
        layoutIfNeeded()
        
        let fittedSize = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize,
                                                 withHorizontalFittingPriority: UILayoutPriority.required,
                                                 verticalFittingPriority: UILayoutPriority.fittingSizeLevel)
        attr.frame.size.height = ceil(fittedSize.height)
        return attr
    }
}

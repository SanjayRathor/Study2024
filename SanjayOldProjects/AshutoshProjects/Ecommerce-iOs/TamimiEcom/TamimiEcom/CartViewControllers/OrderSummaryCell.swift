//
//  OrderSummaryCell.swift
//  TamimiEcom
//
//  Created by Ansh on 10/09/20.
//  Copyright © 2020  ltd. All rights reserved.
//

import UIKit

class OrderSummaryCell: UICollectionViewCell {
    @IBOutlet weak var completeOrder: UIButton!
    
    @IBOutlet weak var placeHolderTxtView: UILabel!
    @IBOutlet weak var txtViewComments: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        txtViewComments.delegate = self
    }

}
extension OrderSummaryCell:UITextFieldDelegate,UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        if numberOfChars == 0 {
            self.placeHolderTxtView.isHidden = false
        }else {
            self.placeHolderTxtView.isHidden = true
        }
        if numberOfChars == 0 && text == " " {
            return false
        }
        
        if numberOfChars > 300 {
            return false
        }
        return true
    }
}

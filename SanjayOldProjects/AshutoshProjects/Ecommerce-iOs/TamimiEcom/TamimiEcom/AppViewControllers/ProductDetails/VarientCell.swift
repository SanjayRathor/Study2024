//
//  VarientCell.swift
//  TamimiEcom
//
//  Created by Aravind Kumar on 25/10/20.
//  Copyright © 2020 Timesinternet ltd. All rights reserved.
//

import UIKit

class VarientCell: UICollectionViewCell {
    var selectedCell = 0
    var selectedVarientId : String!
    
    @IBOutlet weak var varientView: UIView!
    @IBOutlet weak var Lblprice: UILabel!
    @IBOutlet weak var lblQT: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func loadData(dict:NSDictionary,currency:String) {
            if let price = dict["price"] as? Double {
                self.Lblprice.text = "\(currency) \(price)"
            }
            if let quantity = dict["quantity"] as? Double {
                self.lblQT.text = String(quantity)
            }
        self.varientView.layer.borderWidth = 0.3;
            if let _idVarient  = dict["productId"] as? String {
                if  _idVarient == self.selectedVarientId {
                    self.varientView.backgroundColor = UIColor.white
                }else {
                    self.varientView.backgroundColor = UIColor.init(displayP3Red: 220/255.0, green: 219.0/255.0, blue: 219.0/255.0, alpha: 1.0)
                }
            }
        
    }
}

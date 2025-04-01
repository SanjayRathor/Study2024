//
//  footerCollectionViewCell.swift
//  TamimiEcom
//
//  Created by Ansh on 26/08/20.
//  Copyright © 2020  . All rights reserved.
//

import UIKit
protocol ClickFooterInformation:class {
    func clickIndex(ad:Adverts)
}
class footerCollectionViewCell: UICollectionViewCell {
    var adverts:Adverts!
    weak var delegate:ClickFooterInformation?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btnClick: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func clickObject(_ sender: Any) {
    self.delegate?.clickIndex(ad: self.adverts)
    }
    func loadAdverts(ad:Adverts) {
        self.adverts = ad
        let imageUrl = NetworkManager.shared.baseImageURL + self.adverts!.imageUrl
        let url = URL(string:imageUrl )
       self.imageView.kf.setImage(with: url, placeholder:UIImage(named: "placeholder"))
    }
}

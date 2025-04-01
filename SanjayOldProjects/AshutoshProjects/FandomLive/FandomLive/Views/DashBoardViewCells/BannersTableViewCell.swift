//
//  BannersTableViewCell.swift
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 09/10/19.
//  Copyright © 2019 Sanjay Singh Rathor. All rights reserved.
//

import UIKit
//import LCBannerView

class BannersTableViewCell: UITableViewCell {
    
    public var didClickedCallback: ((Int)->())?
    
    @IBOutlet weak var cellBannerView: LCBannerView!
    static let reuseIdentifier: String = String(describing: self)
    
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureBanners(banners:[Banner]) {
        DispatchQueue.main.async() {
            self.cellBannerView.addSubview(self.AddBannerView(bannerView: self.cellBannerView, imageUrlArray:banners))
        }
    }
}

extension BannersTableViewCell {
    
    func AddBannerView(bannerView: UIView, imageUrlArray: [Banner]) -> LCBannerView {
        
        let banner = LCBannerView.init(frame: CGRect(x: 0, y: 0, width: bannerView.frame.size.width, height: bannerView.frame.size.height), delegate: self , imageURLs: imageUrlArray, placeholderImageName: "Concert", timeInterval: 3, currentPageIndicatorTintColor: UIColor.appthemeColor, pageIndicatorTintColor: UIColor.white)
        
        banner?.clipsToBounds = true
        return banner!
    }
}

extension BannersTableViewCell:LCBannerViewDelegate {
    func bannerView(_ bannerView: LCBannerView!, didClickedImageIndex index: Int) {
        self.didClickedCallback?(index)
    }
}

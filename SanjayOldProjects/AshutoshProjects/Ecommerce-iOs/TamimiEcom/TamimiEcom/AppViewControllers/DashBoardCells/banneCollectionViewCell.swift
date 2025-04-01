//
//  banneCollectionViewCell.swift
//  TamimiEcom
//
//  Created by Ansh on 26/08/20.
//  Copyright © 2020  . All rights reserved.
//

import UIKit
protocol BannerInformation:class {
    func bannerInfoClick(banner:Banner?,advert:Adverts?)
}

class banneCollectionViewCell: UICollectionViewCell {
    weak var delegate:BannerInformation?
    var bannerScrollIndex = false
    var nextTimer: Timer?
    var currentPage = 0;
    @IBOutlet weak var pageCtrnl: UIPageControl!
    var isBanner = true
    var bannerInfoArray : [Banner]!
    var advertsInfoArray : [Adverts]!
    
    @IBOutlet weak var ctView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.bannerInfoArray = NSArray.init() as? [Banner]
        self.advertsInfoArray = NSArray.init() as? [Adverts]
        
        let nibInfoCell = UINib(nibName: "homeCell", bundle: nil)
        self.ctView.register(nibInfoCell, forCellWithReuseIdentifier: "homeCell")
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        ctView!.collectionViewLayout = layout
        
        ctView.delegate = self
        ctView.dataSource = self
        ctView.cornerRadius = 5.0
        ctView.clipsToBounds = true
        
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    }
    func loadBanner(){
        if isBanner {
            if self.bannerInfoArray != nil {
                self.ctView.reloadData()
                self.pageCtrnl.numberOfPages = self.bannerInfoArray.count
                self.pageCtrnl.currentPage = currentPage
                if self.bannerInfoArray.count > 1 {
                    self.startTimer()
                }
            }
        }else {
            if self.advertsInfoArray != nil {
                self.ctView.reloadData()
                self.pageCtrnl.numberOfPages = self.advertsInfoArray.count
                self.pageCtrnl.currentPage = currentPage
                if self.advertsInfoArray.count > 1 {
                    self.startTimer()
                }
            }
        }
    }
    func isVisbileShow(isShow:Bool) {
        self.bannerScrollIndex = isShow
    }
    func startTimer() {
        if nextTimer == nil {
            nextTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        }
    }
    func stopTimer() {
        if nextTimer != nil {
            nextTimer!.invalidate()
            nextTimer = nil
        }
    }
    @objc func runTimedCode() {
        if isBanner {
            if(currentPage == self.bannerInfoArray.count) {
                currentPage = 0;
            }else {
                currentPage = currentPage + 1;
            }
            self.pageCtrnl.currentPage = currentPage
            self.ctView.scrollToItem(at:IndexPath(item: self.pageCtrnl.currentPage, section: 0), at: .right, animated: true)
        }
        else {
            if(currentPage == self.advertsInfoArray.count) {
                currentPage = 0;
            }else {
                currentPage = currentPage + 1;
            }
            self.pageCtrnl.currentPage = currentPage
            self.ctView.scrollToItem(at:IndexPath(item: self.pageCtrnl.currentPage, section: 0), at: .right, animated: true)
        }
    }
}
func denit() {
    print("aaaa")
}
//MARK: UICollectionViewDataSource
extension banneCollectionViewCell : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isBanner {
            return self.bannerInfoArray.count
        }else {
            return self.advertsInfoArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        let cell : homeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCell", for: indexPath as IndexPath) as! homeCell
        cell.imageView.backgroundColor = UIColor.black
        cell.imageView.clipsToBounds = true
        if isBanner {
            let bannner = self.bannerInfoArray[indexPath.row]
            let imageUrl = NetworkManager.shared.baseImageURL + bannner.imageUrl
            let url = URL(string:imageUrl )
            cell.imageView.kf.setImage(with: url, placeholder:UIImage(named: "placeholder"))
            cell.imageView.contentMode = .scaleToFill
        }else {
            
            let adverts = self.advertsInfoArray[indexPath.row]
            let imageUrl = NetworkManager.shared.baseImageURL + adverts.imageUrl
            let url = URL(string:imageUrl )
            cell.imageView.kf.setImage(with: url, placeholder:UIImage(named: "placeholder"))
            cell.imageView.contentMode = .scaleToFill
        }
        return cell
    }
    
}
extension banneCollectionViewCell : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isBanner {
            self.delegate?.bannerInfoClick(banner: self.bannerInfoArray[indexPath.row],advert: nil)
        }else {
            self.delegate?.bannerInfoClick(banner: nil,advert:  self.advertsInfoArray[indexPath.row])
        }
    }
}
extension banneCollectionViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.size.width - 20 , height:157)
    }
}

extension UIColor {
    static func randomColor() -> UIColor {
        return UIColor(
            red:   .random(),
            green: .random(),
            blue:  .random(),
            alpha: 1.0
        )
    }
}
extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

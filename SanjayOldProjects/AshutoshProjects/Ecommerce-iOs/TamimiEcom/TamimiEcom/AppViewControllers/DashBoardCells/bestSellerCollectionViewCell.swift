//
//  bestSellerCollectionViewCell.swift
//  TamimiEcom
//
//  Created by Ansh on 26/08/20.
//  Copyright © 2020  . All rights reserved.
//

import UIKit
protocol BestSellerInformation:class {
    func bannerInfoClick(category:CategoryDetail?)
}

class bestSellerCollectionViewCell: UICollectionViewCell {
    var isLeftClick = false
    var isRighClick = false
    
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var btnLeft: UIButton!
    weak var delegate:BestSellerInformation?
    var bannerScrollIndex = false
    var currentPage = 1;
    var bestSellerInfoArray : [CategoryDetail]!
    @IBOutlet weak var ctView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.bestSellerInfoArray = NSArray.init() as? [CategoryDetail]
        
        let nibInfoCell = UINib(nibName: "bestSellerCell", bundle: nil)
        self.ctView.register(nibInfoCell, forCellWithReuseIdentifier: "bestSellerCell")
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        ctView!.collectionViewLayout = layout
        ctView.delegate = self
        ctView.dataSource = self
        self.btnLeft.isHidden = true
        self.btnRight.isHidden = true
    }
    
    func loadBestSeller(){
        if self.bestSellerInfoArray.count <= 2 {
            self.btnLeft.isHidden = true
            self.btnRight.isHidden = true
        }else if self.bestSellerInfoArray.count > 2 {
            self.btnLeft.isHidden = true
            self.btnRight.isHidden = false
        }
        self.ctView.reloadData()
    }
    @IBAction func leftBtnAction(_ sender: Any) {
        
        if currentPage != 0 {
            if isRighClick  {
                currentPage =  currentPage - 2
            }else {
                currentPage =  currentPage - 1
            }
            print(currentPage)
            if currentPage == 0 {
                self.btnLeft.isHidden = true
            }
           if self.bestSellerInfoArray.count <= 2 {
                self.btnRight.isHidden = true
            }else if self.bestSellerInfoArray.count > 2 {
                self.btnRight.isHidden = false
            }
            self.ctView.scrollToItem(at:IndexPath(item: currentPage, section: 0), at: .left, animated: true)
            print(currentPage)
        }
        self.isLeftClick = true
        self.isRighClick = false
    }
    @IBAction func rightBtnAction(_ sender: Any) {
        
        if bestSellerInfoArray.count != currentPage-1 {
            if isLeftClick  {
                currentPage =  currentPage + 2
            }else {
                currentPage =  currentPage + 1
            }
            print(bestSellerInfoArray.count)
            if bestSellerInfoArray.count-1 == currentPage {
                self.btnRight.isHidden = true
            }
            self.btnLeft.isHidden = false
            self.ctView.scrollToItem(at:IndexPath(item: currentPage, section: 0), at: .right, animated: true)
            print(currentPage)
        }
        self.isLeftClick = false
        self.isRighClick = true
    }
    
}
//MARK: UICollectionViewDataSource
extension bestSellerCollectionViewCell : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.bestSellerInfoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : bestSellerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "bestSellerCell", for: indexPath as IndexPath) as! bestSellerCell
        //        cell.backgroundColor = UIColor.randomColor()
        cell.configureModel(model: self.bestSellerInfoArray[indexPath.row])
        return cell
    }
    
}
extension bestSellerCollectionViewCell : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.bannerInfoClick(category: self.bestSellerInfoArray[indexPath.row])
    }
}
extension bestSellerCollectionViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.size.width/2  , height:235)
    }
}

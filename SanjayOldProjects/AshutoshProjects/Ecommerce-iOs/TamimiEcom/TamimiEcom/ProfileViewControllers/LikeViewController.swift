//
//  CategoryViewController.swift
//  TamimiEcom
//
//  Created by Ansh on 09/09/20.
//  Copyright © 2020  ltd. All rights reserved.
//

import UIKit
import SwiftyJSON
//LikeViewController
class LikeViewController: UIViewController {
    @IBOutlet weak var btnGList: UIButton!
    var gridType = true
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var categoryCount: UILabel!
    var itemArray : NSMutableArray!
    var categoryID = ""
    var categoryType = 0
    var catName = ""
    @IBOutlet weak var ctview: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnGList.isSelected = !gridType
        self.tabBarController?.tabBar.isHidden = false
        self.itemArray = NSMutableArray.init()
        self.registerNib()
        ctview.delegate = self
        ctview.dataSource = self
        self.categoryName.text = "MY LIKES"
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        self.getDetailsData()
        
    }
    
    func registerNib() {
        let nibCategory = UINib(nibName: "categoryCell", bundle: nil)
        self.ctview.register(nibCategory, forCellWithReuseIdentifier: "categoryCell")
        let categoryNormal = UINib(nibName: "categoryNormal", bundle: nil)
        self.ctview.register(categoryNormal, forCellWithReuseIdentifier: "categoryNormal")
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func gridAction(_ sender: Any) {
        gridType = !gridType
        self.btnGList.isSelected = !gridType
        self.ctview.reloadData()
    }
}
//MARK: UICollectionViewDataSource
extension LikeViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.gridType == true {
            let cell : categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath as IndexPath) as! categoryCell
            cell.likeRemoveDeleagte = self
            cell.btnLike.tag = indexPath.row
            cell.configureModel(model: itemArray[indexPath.row] as! CategoryDetail)
            
            return cell
        }else {
            let cell : categoryNormal = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryNormal", for: indexPath as IndexPath) as! categoryNormal
            cell.likeRemoveDeleagte = self
            cell.btnLike.tag = indexPath.row
            cell.configureModel(model: itemArray[indexPath.row] as! CategoryDetail)
            return cell
        }
    }
}
extension LikeViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let productDetilsVC = storyboard.instantiateViewController(withIdentifier: "ProductDetilsVC") as! ProductDetilsVC
        let  categoryDetail : CategoryDetail = itemArray[indexPath.row] as! CategoryDetail
        productDetilsVC.productId = categoryDetail.id
        self.navigationController?.pushViewController(productDetilsVC, animated: true)
    }
}
extension LikeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.gridType == true {
            return CGSize(width: self.view.frame.size.width/2 - 7 , height:240)
        }else {
            return CGSize(width: self.view.frame.size.width , height:100)
        }
    }
}

extension LikeViewController {
    func getDetailsData() {
        let requestPath =  Constants.fetchLikedProducts
        NetworkManager.shared.getJSONResponse(path: requestPath,isLoader:false) { (value, status) in
            switch status {
            case .success:
                if let valueData  = value as? NSDictionary {
                    if let success = valueData["success"] as? Int {
                        if success == 1 {
                            if let data = valueData["data"] as? NSArray {
                                self.itemArray.removeAllObjects()
                                for ids in data {
                                    if let idsDict = ids as? [String:Any] {
                                        let categoryModel = CategoryDetail()
                                        if let selectedQuanity = idsDict["selectedQuanity"] as? String {
                                            categoryModel.count = Int(selectedQuanity) ?? 0
                                        }else {
                                            categoryModel.count = 0
                                        }
                                        if let isLiked = idsDict["isLiked"] as? Bool {
                                            categoryModel.isLiked = isLiked
                                        }
                                        if let product = idsDict["product"] as? [String:Any] {
                                            categoryModel.id = product["_id"] as! String
                                            categoryModel.name.update(other: product)
                                            self.itemArray.add(categoryModel)
                                        }
                                    }
                                    
                                }
                            }
                        }
                    }
                }
                self.ctview.reloadData()
                self.categoryCount.text = "\(self.itemArray.count)" + " Products"
            case .error(let error):
                print(error!)
            }
            
        };
    }
    
}
extension LikeViewController : LikeCellRemoveDelegate,LikeCellRemoveNormalDelegate {
    func openLoginView() {
        //Do Nothing
    }
    func openLoginViewNormal() {
        //Do Nothing
    }
    func isLikeRemoved(index: Int) {
        self.itemArray.removeObject(at: index)
        self.ctview.reloadData()
        self.categoryCount.text = "\(self.itemArray.count)" + " Products"
    }
    
    func isLikeRemovedNormal(index: Int) {
        self.itemArray.removeObject(at: index)
        self.ctview.reloadData()
        self.categoryCount.text = "\(self.itemArray.count)" + " Products"
    }    
}

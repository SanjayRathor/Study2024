//
//  ProductDetilsVC.swift
//  TamimiEcom
//
//  Created by Ansh on 10/09/20.
//  Copyright © 2020  ltd. All rights reserved.
//

import UIKit

class ProductDetilsVC: UIViewController {
    @IBOutlet weak var btnEx: UIButton!
    @IBOutlet weak var middleBtnConst: NSLayoutConstraint!
    @IBOutlet weak var btnBundleOffer: UIButton!
    @IBOutlet weak var btnWeekOffer: UIButton!
    
    var productId = ""
    var itemArray = NSMutableArray.init()
    @IBOutlet weak var btnLocation: UIButton!

    @IBOutlet weak var ctView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setFont()
        self.registerNib()
        ctView.delegate = self
        ctView.dataSource = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getDetailsData()
        self.updateLocation()
    }
    func registerNib() {
        let nibProductDetilsCell = UINib(nibName: "ProductDetilsCell", bundle: nil)
        self.ctView.register(nibProductDetilsCell, forCellWithReuseIdentifier: "ProductDetilsCell")
        
        let nibCategory = UINib(nibName: "categoryCell", bundle: nil)
        self.ctView.register(nibCategory, forCellWithReuseIdentifier: "categoryCell")
        
        let nibtitleHeader = UINib(nibName: "titleHeaderCollectionViewCell", bundle: nil)
        self.ctView.register(nibtitleHeader, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "titleHeaderCollectionViewCell")
        
        let nibInfoEmptyCell = UINib(nibName: "emptyCollectionViewCell", bundle: nil)
        self.ctView.register(nibInfoEmptyCell, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "emptyCollectionViewCell")
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func selectLocationAction(_ sender: Any) {
           let objLocation : PickIUpViewController = PickIUpViewController(nibName: "PickIUpViewController", bundle: nil)
           self.tabBarController?.navigationController?.pushViewController(objLocation, animated: true)
           
       }
    @IBAction func openSearchViewControllers(_ sender: Any) {
        let searchViewController : SearchViewController = SearchViewController(nibName: "SearchViewController", bundle: nil)
        self.tabBarController?.navigationController?.pushViewController(searchViewController, animated: true)
    }

}
//MARK: UICollectionViewDataSource
extension ProductDetilsVC : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return self.itemArray.count
        }else {
            return 8
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout  collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        var h : CGFloat = 0.0;
        if section == 1 {
            h = 50
        }
        let w = self.view.frame.size.width
        let size = CGSize(width: w, height: h)
        return size
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionView.elementKindSectionFooter){
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "emptyCollectionViewCell", for: indexPath)
            return headerView
        } else {
            if indexPath.section == 0 {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "emptyCollectionViewCell", for: indexPath)
                return headerView
            }else {
                let titleHeader : titleHeaderCollectionViewCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "titleHeaderCollectionViewCell", for: indexPath) as! titleHeaderCollectionViewCell
                titleHeader.lblTitle.text = "You may also like"
                // Customize headerView here
                titleHeader.backgroundColor = UIColor.clear
                return titleHeader
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell : ProductDetilsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductDetilsCell", for: indexPath as IndexPath) as! ProductDetilsCell
            cell.configureModel(model: itemArray[indexPath.row] as! CategoryDetail)
            cell.delegate = self
            return cell
        }else  {
            let cell : categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath as IndexPath) as! categoryCell
            cell.discountView.isHidden = true
            cell.moreOptionView.isHidden = true
            cell.likeRemoveDeleagte = self
            return cell
        }
    }
}
extension ProductDetilsVC : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
extension ProductDetilsVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: self.view.frame.size.width , height:375)
        }else {
            return CGSize(width: self.view.frame.size.width/2 - 7 , height:240)
        }
    }
}
extension ProductDetilsVC {
    func getDetailsData() {
       let  requestPath = "\(Constants.productById)?productId=\(self.productId)"
        NetworkManager.shared.getJSONResponse(path: requestPath,isLoader:false) { (value, status) in
            print(value)
            switch status {
            case .success:
                if let valueData  = value as? NSDictionary {
                    if let success = valueData["success"] as? Int {
                        if success == 1 {
                            self.itemArray.removeAllObjects()
                            if let data = valueData["data"]  as? [String:Any] {
                                let categoryModel = CategoryDetail()
                                if let selectedQuanity = data["selectedQuanity"] as? String {
                                    categoryModel.count = Int(selectedQuanity) ?? 0
                                }else {
                                    categoryModel.count = 0
                                }
                                if let isLiked = data["isLiked"] as? Bool {
                                categoryModel.isLiked = isLiked
                                }
                                if var product = data["product"] as? [String:Any] {
                                    categoryModel.id = product["_id"] as! String
                                     if let variants = data["variants"] as? NSArray {
                                    product["variants"] = variants
                                    }
                                    categoryModel.name.update(other: product)
                                    self.itemArray.add(categoryModel)
                                }
                            }
                            self.ctView.reloadData()
                        }
                    }
                }
            case .error(let error):
                print(error!)
            }
            
        };
    }
    
}
extension ProductDetilsVC {
    @IBAction func moreOptionClick(_ sender: Any) {
        if let btn  = sender as? UIButton {
            //MoreOptionsViewController
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let moreOptionsViewController = storyboard.instantiateViewController(withIdentifier: "MoreOptionsViewController") as! MoreOptionsViewController
            moreOptionsViewController.categoryType = btn.tag
            self.navigationController?.pushViewController(moreOptionsViewController, animated: true)
        }
    }

    func updateLocation() {
        if  let info =    ApplicationStates.getLocationInformation() as? NSDictionary{
            if var locationName = info["locationName"] as? String {
                locationName = "  " + locationName
                self.btnLocation.setTitle(locationName, for: .normal)
            }
            else {
                self.btnLocation.setTitle("  Select Your Location", for: .normal)
            }
        }
    }
}
extension ProductDetilsVC : LikeCellRemoveNormalDelegate,LikeCellRemoveDelegate,LoginOptionView {
    func openLoginView() {
        PresentingCoordinator.shared().openLoginPage()
    }
    func openLoginViewNormal() {
        PresentingCoordinator.shared().openLoginPage()
    }
    
    func isLikeRemoved(index: Int) {
        //Do Nothing
    }
    func isLikeRemovedNormal(index: Int) {
        //Do Nothing
    }
    func setFont() {
        if self.view.frame.size.width < 375 {
        self.middleBtnConst.constant =  95
        }else if self.view.frame.size.width == 375 {
            self.middleBtnConst.constant =  120
            }
    }
}

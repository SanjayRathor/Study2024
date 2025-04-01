//
//  CategoryViewController.swift
//  TamimiEcom
//
//  Created by Ansh on 09/09/20.
//  Copyright © 2020  ltd. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class CategoryDetail {
    var id: String = ""
    var count = 0
    var name = [String:Any]()
    var comment:String = ""
    var isLiked:Bool = false
    var substitution:Bool = false

}

extension Dictionary {
    mutating func update(other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}


class CategoryViewController: UIViewController {
    @IBOutlet weak var btnEx: UIButton!
    @IBOutlet weak var middleBtnConst: NSLayoutConstraint!
    @IBOutlet weak var btnBundleOffer: UIButton!
    @IBOutlet weak var btnWeekOffer: UIButton!
    
    //Filter parms --
    var filterByBrand : NSMutableArray!
    var filterByCategory : NSMutableArray!
    var sortTypes = NSMutableArray()
    var isPopularity = false
    var isNew = false
    var popular = ""
    var new = ""
    var price = ""
    var range = ""
    var isLowestFirst = -1
    
    @IBOutlet weak var btnGList: UIButton!
    var gridType = true
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var categoryCount: UILabel!
    var itemArray : NSMutableArray!
    var categoryID = ""
    var categoryType = 0
    var catName = ""
    @IBOutlet weak var ctview: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setFont()
        self.filterByBrand  = NSMutableArray.init()
        self.filterByCategory = NSMutableArray.init()
        self.btnGList.isSelected = !gridType
        self.tabBarController?.tabBar.isHidden = false
        
        self.itemArray = NSMutableArray.init()
        self.registerNib()
        ctview.delegate = self
        ctview.dataSource = self
        self.categoryName.text = self.catName
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.getDetailsData()
        self.updateLocation()
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
    @IBAction func selectLocationAction(_ sender: Any) {
        let objLocation : PickIUpViewController = PickIUpViewController(nibName: "PickIUpViewController", bundle: nil)
        self.tabBarController?.navigationController?.pushViewController(objLocation, animated: true)
        
    }
    @IBAction func openSearchViewControllers(_ sender: Any) {
        let searchViewController : SearchViewController = SearchViewController(nibName: "SearchViewController", bundle: nil)
        self.tabBarController?.navigationController?.pushViewController(searchViewController, animated: true)
    }
    
    @IBAction func gridAction(_ sender: Any) {
        gridType = !gridType
        self.btnGList.isSelected = !gridType
        self.ctview.reloadData()
    }
    
       @IBAction func moreOptionClick(_ sender: Any) {
       if let btn  = sender as? UIButton {
           //MoreOptionsViewController
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
               let moreOptionsViewController = storyboard.instantiateViewController(withIdentifier: "MoreOptionsViewController") as! MoreOptionsViewController
           moreOptionsViewController.categoryType = btn.tag
           self.navigationController?.pushViewController(moreOptionsViewController, animated: true)
       }
   }

    
}
//MARK: UICollectionViewDataSource
extension CategoryViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.gridType == true {
        let cell : categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath as IndexPath) as! categoryCell
        cell.configureModel(model: itemArray[indexPath.row] as! CategoryDetail)
            cell.likeRemoveDeleagte = self
        return cell
        }else {
        let cell : categoryNormal = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryNormal", for: indexPath as IndexPath) as! categoryNormal
            cell.likeRemoveDeleagte = self
            cell.configureModel(model: itemArray[indexPath.row] as! CategoryDetail)
        return cell
        }
    }
}
extension CategoryViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let productDetilsVC = storyboard.instantiateViewController(withIdentifier: "ProductDetilsVC") as! ProductDetilsVC
        let  categoryDetail : CategoryDetail = itemArray[indexPath.row] as! CategoryDetail
        productDetilsVC.productId = categoryDetail.id
        self.navigationController?.pushViewController(productDetilsVC, animated: true)
    }
}
extension CategoryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.gridType == true {
            return CGSize(width: self.view.frame.size.width/2 - 7 , height:240)
        }else {
            return CGSize(width: self.view.frame.size.width , height:100)
        }
    }
}

extension CategoryViewController {
    func getDetailsData() {
        var params : [String : Any] = [:]
        var requestPath = ""
        if categoryType == 1 {
            params = ["tmCode":self.categoryID ,"filterByBrand":self.filterByBrand ?? NSArray.init(),"filterByCategory":self.filterByCategory ?? NSArray.init(),"popular":self.popular,"new":self.new,"price":self.price,"range":self.range]
            requestPath =  "core/product-by-category"
        }else {
            params  = ["brandId":self.categoryID ,"filterByBrand":self.filterByBrand ?? NSArray.init(),"filterByCategory":self.filterByCategory ?? NSArray.init(),"popular":self.popular,"new":self.new,"price":self.price,"range":self.range]
            requestPath =  "core/product-by-brand"
        }
      NetworkManager.shared.postJSONResponse(path:requestPath, parameters: params) { (value, status) in
       // print(value)
                 switch status {
                 case .success:
                     if let valueData  = value as? NSDictionary {
                         if let code = valueData["code"] as? Int {
                             if code == 201 {
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
                      let count  =  self.itemArray.count
                     if count > 1 {
                     self.categoryCount.text = "\(self.itemArray.count)" + " Products"
                     }else {
                        self.categoryCount.text = "\(self.itemArray.count)" + " Product"
                    }
                 case .error(let error):
                     print(error!)
                 }
             }
}
    
}
extension CategoryViewController {
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
extension CategoryViewController : ClikInfomartionDelegte {
    @IBAction func sortByAction(_ sender: Any) {
        print("Open Right Menu")
        if let right : RightMenuViewController =  self.sideMenuController?.rightViewController as? RightMenuViewController {
            right.delgate = self
            right.range = self.range
            right.isNew = self.isNew
            right.isLowestFirst = self.isLowestFirst
            right.isPopularity = self.isPopularity
            right.selctedPageId = self.categoryID
            right.filterByCategoryValues = self.filterByCategory
            right.filterByBrandValues = self.filterByBrand
           right.isFromCategary = categoryType == 1 ? true : false
            right.sortByViewCall()
            self.sideMenuController?.showRightView(animated: true, completionHandler: {
                 
            })
        }
       }
       @IBAction func filterByAction(_ sender: Any) {
        print("Open Right Menu")
        if let right : RightMenuViewController =  self.sideMenuController?.rightViewController as? RightMenuViewController {
            right.range = self.range
            right.isNew = self.isNew
            right.isLowestFirst = self.isLowestFirst
            right.isPopularity = self.isPopularity
            right.isFromCategary = categoryType == 1 ? true : false
            right.selctedPageId = self.categoryID
            right.filterByCategoryValues = self.filterByCategory
            right.filterByBrandValues = self.filterByBrand
            right.filterByCall()
            right.delgate = self
            self.sideMenuController?.showRightView(animated: true, completionHandler: {
            })
        }
       }
    @IBAction func feedbacjkView(_ sender: Any) {
     print("Open Right Menu")
     if let right : RightMenuViewController =  self.sideMenuController?.rightViewController as? RightMenuViewController {
         right.feedbackViewShow()
         right.delgate = self
         self.sideMenuController?.showRightView(animated: true, completionHandler: {
         })
     }
    }
    func clikeInformationSent(info: [String : Any]) {
        if let feedback = info["feedback"] as? String {
            if !feedback.isEmpty {
                self.addFeedBack(feedback: feedback)
                return;
            }
        }
        if let filterByBrandValue = info["filterByBrand"] as? NSMutableArray {
            self.filterByBrand = filterByBrandValue;
        }
        if let filterByCategoryValue = info["filterByCategory"] as? NSMutableArray {
                   self.filterByCategory = filterByCategoryValue;
               }
        if let popularValue = info["popular"] as? String {
            self.popular = popularValue;
            if self.popular == "asc" {
                self.isPopularity = true
            }else {
            self.isPopularity = false
            }
        }
        if let newValue = info["new"] as? String {
            self.new = newValue;
            if self.new == "asc" {
                self.isNew = true
            }else {
            self.isNew = false
            }
        }
        if let priceValue = info["price"] as? String {
            print(priceValue)
            print(self.isLowestFirst)

            self.price = priceValue;
            if self.price == "asc" {
                print("aaaaa")
                self.isLowestFirst = 1
            }else if self.price == "desc" {
                self.isLowestFirst = 0
            }else {
            self.isLowestFirst = -1
            }
            
        }
        if let rangeValue = info["range"] as? String {
            self.range = rangeValue;
        }
        self.getDetailsData()
      }
    func addFeedBack(feedback:String) {
        SVProgressHUD.show()
        let post:[String:Any] = [
            "description": feedback,"customerId":ApplicationStates.getUserID(),"category":"query"
        ]
        NetworkManager.shared.postJSONResponse(path: Constants.addQuery, parameters:post) { (value, status) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }
            switch status {
            case .success:
                if let valueData  = value as? NSDictionary {
                    if let code = valueData["code"] as? Int {
                        if code == 201 {
                            if let message  = valueData["message"] as? String {
                                alert(Constants.appName, message: message, view: self)
                            }
                        }
                    }
                }
            case .error(let error):
                print(error!)
            }
        }
    }
}
extension CategoryViewController : LikeCellRemoveNormalDelegate,LikeCellRemoveDelegate {
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


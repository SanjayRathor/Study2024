//
//  CartListViewController.swift
//  TamimiEcom
//
//  Created by Ansh on 09/09/20.
//  Copyright © 2020  ltd. All rights reserved.
//

import UIKit

class CartListViewController: UIViewController {
    @IBOutlet weak var switchAllSubstrtion: UISwitch!
    
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var bottomView: UIView!
    var totalPrice : Double = 0.0
    @IBOutlet var substrationHintView: UIView!
    var totalDiscountAmount : Double = 0.0
    @IBOutlet weak var emptyCart: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var btnCheckOut: UIButton!
    @IBOutlet weak var savedLbl: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var ctview: UICollectionView!
    var itemArray = NSMutableArray.init()
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyCart.isHidden = true
        self.registerNib()
        ctview.delegate = self
        ctview.dataSource = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getOrderDetailsData()
        self.updateLocation()
    }
    func registerNib() {
        let nibCategory = UINib(nibName: "cartListCell", bundle: nil)
        self.ctview.register(nibCategory, forCellWithReuseIdentifier: "cartListCell")
        
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func checkOutAction(_ sender: Any) {
        if ApplicationStates.isUserLoggedIn() {
            
//            if  let info =    ApplicationStates.getLocationInformation() as? NSDictionary{
//            if let locationName = info["locationId"] as? String {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let checkOutViewController = storyboard.instantiateViewController(withIdentifier: "CheckOutViewController") as! CheckOutViewController
        self.navigationController?.pushViewController(checkOutViewController, animated: true)
//                       }else {
//                        self.secletLocationPicker()
//                }
//            }
            
        }else {
            PresentingCoordinator.shared().openLoginPage()
        }
    }
    
    @IBAction func openLocationSelection(_ sender: Any) {
        self.secletLocationPicker()
    }
    func secletLocationPicker() {
        let objLocation : PickIUpViewController = PickIUpViewController(nibName: "PickIUpViewController", bundle: nil)
              self.navigationController?.pushViewController(objLocation, animated: true)
    }
    
    @IBAction func allSubstraionValueChangedAction(_ sender: Any) {
        
        let idScategory = NSMutableArray.init()
        for isd in self.itemArray {
            if let isdCategory = isd as? CategoryDetail {
                idScategory.add(isdCategory.id)
            }
        }
        let valuesubstitution = self.switchAllSubstrtion.isOn
        let post:[String:Any] = [
            "orderNumber": ApplicationStates.getOrderNumber(),
            "orderId": ApplicationStates.getOrderId(),
            "productIds": idScategory,
            "substitution": valuesubstitution
        ]
        NetworkManager.shared.postJSONResponse(path:  Constants.addRemoveSubstitution, parameters:post,isLoder: true) { (value, status) in
            switch status {
            case .success:
                if let valueData  = value as? NSDictionary {
                    if let code = valueData["code"] as? Int {
                        if code == 201 {
                            for isd in self.itemArray {
                            if let isdCategory = isd as? CategoryDetail {
                                isdCategory.substitution = valuesubstitution
                                }
                            }
                            if valuesubstitution {
                                self.subStaritionONCall(witOn: true)
                            }
                            self.ctview.reloadData()
                            
                            self.checkAllSubstrionEnbale()
                        }else {
                            
                        }
                    }
                }
            case .error(let error):
                print(error!)
            }
        }
    }
    func subStaritionONCall(witOn:Bool) {
        DispatchQueue.main.async {
            self.substrationHintView.isHidden = !witOn
    }
    }
}
//MARK: UICollectionViewDataSource
extension CartListViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : cartListCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cartListCell", for: indexPath as IndexPath) as! cartListCell
        cell.configureModel(model: itemArray[indexPath.row] as! CategoryDetail)
        cell.delegate = self
        return cell
        
    }
}
extension CartListViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
extension CartListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width , height:110)
        
    }
}
extension CartListViewController:cartListAddRemove {
    
    @IBAction func removeSibstartionHint(_ sender: Any) {
        self.subStaritionONCall(witOn: false)
    }
    
    func allSubstitutionCheck(withOn: Bool) {
        if withOn {
            self.subStaritionONCall(witOn: true)
        }
        self.checkAllSubstrionEnbale()
    }
    func checkAllSubstrionEnbale() {
        var allSustrionFalse = false
        for idS in self.itemArray {
            if let category: CategoryDetail = idS as? CategoryDetail {
                if category.substitution {
                    allSustrionFalse = true
                    break
                }
        }
        }
        self.switchAllSubstrtion.isOn  = allSustrionFalse;
    
    }
    func addRemover() {
        self.getOrderDetailsData()
    }
    
    func getOrderDetailsData() {
        NetworkManager.shared.getJSONResponse(path: Constants.orderDetails,isLoader: true) { (value, status) in
            switch status {
            case .success:
                print(value)
                if let valueData  = value as? NSDictionary {
                    if let success = valueData["success"] as? Int {
                        if success == 1 {
                            if let data = valueData["data"] as? NSDictionary {
                                if data.count > 0 {
                                    if let orderNumber = data["orderNumber"] as? String {
                                        ApplicationStates.saveOrderNumber(Info: orderNumber)
                                    }
                                    if let orderId = data["_id"] as? String {
                                        ApplicationStates.saveOrderId(Info: orderId)
                                    }
                                }else {
                                    ApplicationStates.removeOrderInformation()
                                }
                            }
                            self.itemArray.removeAllObjects()
                            self.totalPrice = 0.0
                            self.totalDiscountAmount = 0.0
                                                    
                            if let data = valueData["data"] as? NSDictionary {
                                if let productId = data["productId"] as? NSArray {
                                    
                                    NotificationCenter.default.post(name: Notification.Name("cartUpdateCount"), object: nil, userInfo:["count":productId.count])

                                    for ids in productId {
                                        if let idsDict = ids as? [String:Any] {
                                            if let product = idsDict ["product"] as? NSDictionary {
                                                let categoryModel = CategoryDetail()
                                                categoryModel.id = product["_id"] as! String
                                              
                                                categoryModel.comment = idsDict["comment"] as! String
                                                
                                                if let quantity = idsDict["quantity"] as? String {
                                                    categoryModel.count = Int(quantity) ?? 0
                                                }else  {
                                                    categoryModel.count = 0
                                                }
                                                if let isLiked = idsDict["isLiked"] as? Bool {
                                                    categoryModel.isLiked = isLiked
                                                }
                                                if let substitution = idsDict["substitution"] as? Bool {
                                                categoryModel.substitution = substitution
                                                }
                                                
                                                if let price = product["price"] as? Double {
                                                    print(price);
                                                    print(categoryModel.count);
                                                    self.totalPrice =  self.totalPrice + price*Double(categoryModel.count)
                                                    print(self.totalPrice);
                                                }
                                                
                                                if let discountAmount = product["discountAmount"] as? Double {
                                                    self.totalDiscountAmount =  self.totalDiscountAmount + discountAmount*Double(categoryModel.count)
                                                }
                                                
                                                categoryModel.name.update(other: idsDict["product"] as! Dictionary<String, Any>)
                                                self.itemArray.add(categoryModel)
                                            }
                                        }
                                    }
                                }
                                self.updateDataBottom(infoDict: valueData)
                                self.checkAllSubstrionEnbale()
                            }
                        }}}
                if self.itemArray.count == 0 {
                    self.topView.isHidden = true
                    self.bottomView.isHidden = true
                    self.emptyCart.isHidden = false
                }else {
                    self.topView.isHidden = false
                    self.bottomView.isHidden = false
                    self.emptyCart.isHidden = true
                }
                self.ctview.reloadData()
            case .error(let error):
                print(error!)
            }
            print( ApplicationStates.getOrderNumber());
        }
    }
    func updateDataBottom(infoDict:NSDictionary) {
        let totalPriceY = Double(round(100*self.totalPrice)/100)
        self.totalAmount.text = "Total Amount: \(totalPriceY) SAR"
        let y = Double(round(100*self.totalDiscountAmount)/100)
        self.savedLbl.text = "You Saved: \(y) SAR"
    }
}
extension CartListViewController {
    func updateLocation() {
        if  let info =    ApplicationStates.getLocationInformation() as? NSDictionary {
            if let locationName = info["locationName"] as? String {
                self.lblLocation.text = locationName
            }else {
                self.lblLocation.text = "Select Your Location"
            }
        }
    }
}

//
//  homeInfoCell.swift
//  
//
//  Created by Ansh on 14/12/18.
//  Copyright © 2018 Sanjay Singh Rathor. All rights reserved.
//

import UIKit
import Kingfisher
protocol LikeCellRemoveDelegate : class {
    func isLikeRemoved(index:Int)
    func openLoginView()
}
class categoryCell: UICollectionViewCell {
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var btnMinus: UIButton!
    weak var likeRemoveDeleagte :LikeCellRemoveDelegate?
    @IBOutlet weak var discountLblPercentage: UILabel!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var originalPrice: UILabel!
    @IBOutlet weak var variant: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var discountPrice: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var discountView: UIImageView!
    @IBOutlet weak var moreOptionView: UIView!
    @IBOutlet weak var quantity: UILabel!
    
    var categoryModel:CategoryDetail!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureModel(model:CategoryDetail) {
        self.categoryModel = model;
        quantity.text = "\(model.count)"
        if let imagePath = model.name["defaultImage"] as? String {
            let imageUrl = NetworkManager.shared.baseImageURL + imagePath.replacingOccurrences(of: " ", with: "%20")
            let url = URL(string:imageUrl )
            self.imageView.kf.setImage(with: url, placeholder:UIImage(named: "placeholder"))
        }
        self.discountView.isHidden = true
        if let price = model.name["price"] as? Double{
            self.originalPrice.text = "SAR " + "\(price)"
            if let discountAmount = model.name["discountAmount"] as? Double{
                self.discountPrice.text = "SAR " + "\(price - discountAmount)"
                self.discountView.isHidden = false
                let percentage = String(format: "%.2f", (discountAmount/price)*100)
                if percentage == "0.00" {
                    self.discountView.isHidden = true
                }
                self.discountLblPercentage.text = "\(percentage)% OFF"
            }else {
                self.discountPrice.text = "SAR " + "\(price)"
            }
        }
        if let name = model.name["title"] as? String {
            self.nameLbl.text = name
        }
        if let variants = model.name["variants"] as? NSArray {
            self.variant.text = "\(variants.count)" + " more variants"
        }else {
            self.variant.text = "0" + " more variants"
        }
        self.btnLike.isSelected = model.isLiked
        self.setPlusMinus()
    }    
    @IBAction func incrimentDidClicked(_ sender: Any) {
        self.categoryModel.count = self.categoryModel.count + 1
        quantity.text = "\(categoryModel.count)"
        addUpdateOrderData(quantity:"\(categoryModel.count)" , substitution:false,withCheck: true)
        self.setPlusMinus()
    }
    
    @IBAction func dicrimentDidClicked(_ sender: Any) {
        if self.categoryModel.count == 0 {
            return;
        }
        self.categoryModel.count = self.categoryModel.count - 1
        quantity.text = "\(categoryModel.count)"
        addUpdateOrderData(quantity:"\(categoryModel.count)" , substitution:true,withCheck: false)
        self.setPlusMinus()
    }
    func setPlusMinus() {
        if categoryModel.count == 0 {
            self.btnMinus.isHidden = true
            self.quantity.isHidden = true
        }else {
            self.btnMinus.isHidden = false
            self.quantity.isHidden = false
        }
    }
    
    @IBAction func shareAction(_ sender: Any) {
        PresentingCoordinator.shared().openShareDailog(productId: categoryModel.id,type: "product")
    }
    @IBAction func likeAction(_ sender: Any) {
        if ApplicationStates.isUserLoggedIn() {
            self.updateLike()
        }else {
            self.likeRemoveDeleagte?.openLoginView()
        }
    }
    
}

extension categoryCell {
    func addUpdateOrderData(quantity:String, substitution: Bool,withCheck:Bool) {
        let orderNumber = ApplicationStates.getOrderNumber()
        let post:[String:Any] = [
            "logIn":ApplicationStates.isUserLoggedIn(),
            "source":"MOBILE",
            "orderNumber": orderNumber,
            "orderId": ApplicationStates.getOrderId(),
            "customerId": ApplicationStates.getUserID(),
            "productId":[[
                "product" : self.categoryModel.id,
                "quantity": quantity,
                "substitution": substitution
            ]]
        ]
        if orderNumber.isEmpty && withCheck {
            self.getOrderInformationIfAny(quantity: quantity, substitution: substitution)
            return;
        }
        NetworkManager.shared.postJSONResponse(path: orderNumber.isEmpty ?  Constants.addOrder : Constants.editOrder, parameters:post) { (value, status) in
            switch status {
            case .success:
                if let valueData  = value as? NSDictionary {
                    if let code = valueData["code"] as? Int {
                        if code == 201 {
                            if self.categoryModel.count == 0 && substitution {
                                let userInfo = ["type":substitution ? 1 : 2]
                                NotificationCenter.default.post(name: Notification.Name("cartBudgeUpdate"), object: nil, userInfo:userInfo)
                            }
                            else if self.categoryModel.count == 1 && !substitution {
                                let userInfo = ["type":substitution ? 1 : 2]
                                NotificationCenter.default.post(name: Notification.Name("cartBudgeUpdate"), object: nil, userInfo:userInfo)
                            }
                            if let data = valueData["data"] as? NSDictionary {
                                if data.count > 0 {
                                    if let orderNumber = data["orderNumber"] as? String {
                                        ApplicationStates.saveOrderNumber(Info: orderNumber)
                                    }
                                    if let orderId = data["_id"] as? String {
                                        ApplicationStates.saveOrderId(Info: orderId)
                                    }
                                }
                            }
                        }
                    }
                }
            case .error(let error):
                print(error!)
            }
        }
    }
    func getOrderInformationIfAny(quantity:String, substitution: Bool) {
        NetworkManager.shared.getJSONResponse(path: Constants.orderDetails,isLoader:false) { (value, status) in
            switch status {
            case .success:
                if let valueData  = value as? NSDictionary {
                    if let success = valueData["success"] as? Int {
                        if success == 1 {
                            if let data = valueData["data"] as? NSDictionary {
                                if let productId = data["productId"] as? NSArray {
                                    if productId.count > 0 {
                                        
                                        ApplicationStates.saveCartBudge(Info: String(productId.count))
                                        NotificationCenter.default.post(name: Notification.Name("cartUpdateCount"), object: nil, userInfo:["count":productId.count])
                                        
                                    }
                                }
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
                        }
                        self.addUpdateOrderData(quantity: quantity, substitution: substitution, withCheck: false)
                    }}
                
            case .error(let error):
                print(error!)
            }
            print( ApplicationStates.getOrderNumber());
        }
    }
    func updateLike() {
        let post:[String:Any] = ["liked":self.categoryModel.isLiked ? "false" : "true","productId":self.categoryModel.id]
        NetworkManager.shared.postJSONResponse(path:Constants.handleLikes,  parameters:post) { (value, status) in
            switch status {
            case .success:
                if let valueData  = value as? NSDictionary {
                    if let code = valueData["code"] as? Int {
                        if code == 201 {
                            self.categoryModel.isLiked = !self.categoryModel.isLiked
                            self.btnLike.isSelected = self.categoryModel.isLiked
                            if !self.categoryModel.isLiked  && self.likeRemoveDeleagte != nil {
                                self.likeRemoveDeleagte?.isLikeRemoved(index: self.btnLike.tag)
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

//
//  cartListCell.swift
//  
//
//  Created by Ansh on 14/12/18.
//  Copyright © 2018 Sanjay Singh Rathor. All rights reserved.
//

import UIKit
import Kingfisher
protocol cartListAddRemove : class{
    func addRemover()
    func allSubstitutionCheck(withOn:Bool)
}

class cartListCell: UICollectionViewCell {
    @IBOutlet weak var switchSbstration: UISwitch!
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var btnMinus: UIButton!
    weak var delegate:cartListAddRemove?
    @IBOutlet weak var txtComments: UITextField!
    var categoryModel:CategoryDetail!
    @IBOutlet weak var originalPrice: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var discountPrice: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var quantity: UILabel!
    
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
       
        
        if let price = model.name["price"] as? Double{
            self.originalPrice.text = "SAR " + "\(price)"
            
            if let discountAmount = model.name["discountAmount"] as? Double{
                   self.discountPrice.text = "SAR " + "\(price - discountAmount)"
            }else {
                self.discountPrice.text = "SAR " + "\(price)"
            }
        }
        if let name = model.name["title"] as? String {
            self.nameLbl.text = name
        }
        self.switchSbstration.isOn = model.substitution
        self.txtComments.text = model.comment
        
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
    @IBAction func txtEddingEnd(_ sender: Any) {
        self.categoryModel.comment = self.txtComments.text ?? ""
        //Service Addd
        self.addCommentService()
    }
    @IBAction func txtValueChanged(_ sender: Any) {
    }
    
    @IBAction func switchSubstrationChanged(_ sender: Any) {
        self.addRemoveSubstitutionNetwork()

    }
}
extension cartListCell {
    
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
                    if let success = valueData["success"] as? Int {
                        if success == 1 {
                            print(valueData)
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
                            self.delegate?.addRemover()
                        }
                    }
                }
            case .error(let error):
                print(error!)
            }
        }
    }
    
    func addCommentService() {
        let post:[String:Any] = [
            "orderNumber": ApplicationStates.getOrderNumber(),
            "orderId": ApplicationStates.getOrderId(),
            "productId": self.categoryModel.id,
            "comment": self.txtComments.text ?? ""
        ]
        NetworkManager.shared.postJSONResponse(path:  Constants.addComment, parameters:post) { (value, status) in
            switch status {
            case .success:
                if let valueData  = value as? NSDictionary {
                    if let code = valueData["code"] as? Int {
                        if code == 201 {
                            
                        }else {
                            self.txtComments.text = ""
                            self.categoryModel.comment = ""
                        }
                    }
                }
            case .error(let error):
                print(error!)
            }
        }
    }
    func addRemoveSubstitutionNetwork() {
        let post:[String:Any] = [
            "orderNumber": ApplicationStates.getOrderNumber(),
            "orderId": ApplicationStates.getOrderId(),
            "productIds": NSArray.init(objects: self.categoryModel.id),
            "substitution": !self.categoryModel.substitution
        ]
        NetworkManager.shared.postJSONResponse(path:  Constants.addRemoveSubstitution, parameters:post,isLoder: true) { (value, status) in
            switch status {
            case .success:
                if let valueData  = value as? NSDictionary {
                    if let code = valueData["code"] as? Int {
                        if code == 201 {
                            self.categoryModel.substitution = !self.categoryModel.substitution
                            self.delegate?.allSubstitutionCheck(withOn: self.categoryModel.substitution)
                        }else {
                            
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
}

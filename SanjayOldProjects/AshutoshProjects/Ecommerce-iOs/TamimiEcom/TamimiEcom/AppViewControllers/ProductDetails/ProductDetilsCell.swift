//
//  ProductDetilsCell.swift
//  TamimiEcom
//
//  Created by Ansh on 10/09/20.
//  Copyright © 2020  ltd. All rights reserved.
//

import UIKit
protocol LoginOptionView: class {
    func openLoginView()
}

class ProductDetilsCell: UICollectionViewCell {
    
    @IBOutlet weak var ctView: UICollectionView!
    @IBOutlet weak var widthConstraion: NSLayoutConstraint!
    var selectedVarintentProduct:NSDictionary?
    var variantsArray:NSArray  = NSArray.init()
    var varientCurrency:String = ""
    @IBOutlet weak var vPrice1: UILabel!
    @IBOutlet weak var vQtantity1: UILabel!
    @IBOutlet weak var vPrice2: UILabel!
    @IBOutlet weak var vQtantity2: UILabel!
    @IBOutlet weak var vPrice3: UILabel!
    @IBOutlet weak var vQtantity3: UILabel!
    @IBOutlet weak var vPrice4: UILabel!
    @IBOutlet weak var vQtantity4: UILabel!
    @IBOutlet weak var vPrice5: UILabel!
    @IBOutlet weak var vQtantity5: UILabel!
    
    var selectedVariantID  = ""
    weak var delegate:LoginOptionView?
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var discountLblPercentage: UILabel!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var originalPrice: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var discountPrice: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var discountView: UIView!
    @IBOutlet weak var stackVarientHight: NSLayoutConstraint!
    @IBOutlet weak var varientStackView: UIStackView!
    @IBOutlet weak var quantity: UILabel!
    var categoryModel:CategoryDetail!
    @IBOutlet weak var variants3: UIView!
    @IBOutlet weak var variants5: UIView!
    @IBOutlet weak var variants4: UIView!
    @IBOutlet weak var variants2: UIView!
    @IBOutlet weak var variants1: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.ctView.delegate = self
        self.ctView.dataSource = self
        self.registerNib()

        self.loadUForValient()
    }
    func registerNib() {
        let nibProductDetilsCell = UINib(nibName: "VarientCell", bundle: nil)
        self.ctView.register(nibProductDetilsCell, forCellWithReuseIdentifier: "VarientCell")
    }
    func loadUForValient(){
        variants5.backgroundColor = UIColor.init(displayP3Red: 220/255.0, green: 219.0/255.0, blue: 219.0/255.0, alpha: 1.0)
        variants5.layer.borderWidth = 0.3;
        variants4.backgroundColor = UIColor.init(displayP3Red: 220/255.0, green: 219.0/255.0, blue: 219.0/255.0, alpha: 1.0)
        variants4.layer.borderWidth = 0.3;
        variants3.backgroundColor = UIColor.init(displayP3Red: 220/255.0, green: 219.0/255.0, blue: 219.0/255.0, alpha: 1.0)
        variants3.layer.borderWidth = 0.3;
        variants2.backgroundColor = UIColor.init(displayP3Red: 220/255.0, green: 219.0/255.0, blue: 219.0/255.0, alpha: 1.0)
        variants2.layer.borderWidth = 0.3;
        variants1.backgroundColor = UIColor.init(displayP3Red: 220/255.0, green: 219.0/255.0, blue: 219.0/255.0, alpha: 1.0)
        variants1.layer.borderWidth = 0.3;
        
    }
    func configureModel(model:CategoryDetail) {
        self.categoryModel = model;
        var currency = "SAR"
        if let currency1 = model.name["currency"] as? String {
            currency = currency1
        }
        if let variants = model.name["variants"] as? NSArray {
            self.setVarients(variants: variants,currency: currency)
            if variants.count == 0 {
                self.setUIForSelctedObject(dict: self.categoryModel.name as NSDictionary, currency: currency)
            }else {
                var dict : NSDictionary = NSDictionary.init()
                for index in 0..<variants.count {
                    if let dictLocal  = variants[index] as? NSDictionary {
                        if let _idVarient  = dictLocal["productId"] as? String {
                            if  _idVarient == self.categoryModel.id {
                                dict = dictLocal
                                break
                            }
                        }
                    }
                }
                self.setUIForSelctedObject(dict: dict, currency: currency)
            }
        }else {
            self.stackVarientHight.constant = 0.0
            self.varientStackView.isHidden = true
            self.setUIForSelctedObject(dict: self.categoryModel.name as NSDictionary, currency: currency)
        }
    }
    func setUIForSelctedObject(dict:NSDictionary,currency:String) {
        self.selectedVarintentProduct = dict
        if let _idVarient  = self.selectedVarintentProduct?["productId"] as? String {
            self.categoryModel.id = _idVarient
        }
        if let selectedQuanity  = self.selectedVarintentProduct?["selectedQuanity"] as? String {
            self.categoryModel.count = Int(selectedQuanity) ?? 0
        }
        if let isLiked = self.selectedVarintentProduct?["isLiked"] as? Bool {
            self.categoryModel.isLiked = isLiked
        }
        quantity.text = "\(self.categoryModel.count)"
        if let imagePath = dict["defaultImage"] as? String {
            let imageUrl = NetworkManager.shared.baseImageURL + imagePath.replacingOccurrences(of: " ", with: "%20")
            let url = URL(string:imageUrl )
            self.imageView.kf.setImage(with: url, placeholder:UIImage(named: "placeholder"))
        }
        self.discountView.isHidden = true
        if let price = dict["price"] as? Double {
            
            self.originalPrice.text = "\(currency) " + "\(price)"
            if let discountAmount = dict["discountAmount"] as? Double {
                let intPrice = price - discountAmount
               let intPriceString = String(format: "%.2f", intPrice)
                self.discountPrice.text = "\(currency) " + "\(intPriceString)"
                
                self.discountView.isHidden = false
                let percentage = String(format: "%.2f", (discountAmount/price)*100)
                if percentage == "0.00" {
                    self.discountView.isHidden = true
                }
                self.discountLblPercentage.text = "\(percentage)% OFF"
            }else {
                self.discountPrice.text = "\(currency) " + "\(price)"
            }
        }
        if let name = dict["title"] as? String {
            self.nameLbl.text = name
        }
        self.btnLike.isSelected = categoryModel.isLiked
        self.setPlusMinus()
        self.setVarients(variants: self.variantsArray, currency: self.varientCurrency)
    }
    
    func setVarients(variants:NSArray,currency:String) {
        self.variantsArray = variants
        self.varientCurrency = currency
        self.variants1.isHidden = true
        self.variants2.isHidden = true
        self.variants3.isHidden = true
        self.variants4.isHidden = true
        self.variants5.isHidden = true
        let count  = variants.count
        let wd = Int(self.frame.size.width-20)/5
        self.widthConstraion.constant = CGFloat(wd*count)
        if count > 5 {
            self.ctView.isHidden = false
            self.varientStackView.isHidden = true
            self.ctView.reloadData()
            return
        }
        self.ctView.isHidden = true
        self.varientStackView.isHidden = false

        if variants.count > 1 {
            self.stackVarientHight.constant = 35.0
            self.varientStackView.isHidden = false
            
            for index in 1..<variants.count {
                if index == 1 {
                    self.variants1.isHidden = false
                    self.variants2.isHidden = false
                    if let dict0  = variants[0] as? NSDictionary {
                        if let price = dict0["price"] as? Double {
                            self.vPrice1.text = "\(currency) \(price)"
                        }
                        if let quantity = dict0["quantity"] as? Double {
                            self.vQtantity1.text = String(quantity)
                        }
                        if let _idVarient  = dict0["productId"] as? String {
                            if  _idVarient == self.categoryModel.id {
                                self.variants1.backgroundColor = UIColor.white
                            }
                        }
                    }
                    if let dict1  = variants[1] as? NSDictionary {
                        if let price = dict1["price"] as? Double {
                            self.vPrice2.text = "\(currency) \(price)"
                        }
                        if let quantity = dict1["quantity"] as? Double {
                            self.vQtantity2.text = String(quantity)
                        }
                        if let _idVarient  = dict1["productId"] as? String {
                            if   _idVarient == self.categoryModel.id {
                                self.variants2.backgroundColor = UIColor.white
                            }
                        }
                    }
                }
                if index == 2 {
                    self.variants3.isHidden = false
                    if let dict  = variants[2] as? NSDictionary {
                        if let price = dict["price"] as? Double {
                            self.vPrice3.text = "\(currency) \(price)"
                        }
                        if let quantity = dict["quantity"] as? Double {
                            self.vQtantity3.text = String(quantity)
                        }
                        if let _idVarient  = dict["productId"] as? String {
                            if   _idVarient == self.categoryModel.id {
                                self.variants3.backgroundColor = UIColor.white
                            }
                        }
                    }
                }
                if index == 3 {
                    self.variants4.isHidden = false
                    if let dict  = variants[3] as? NSDictionary {
                        if let price = dict["price"] as? Double {
                            self.vPrice4.text = "\(currency) \(price)"
                        }
                        if let quantity = dict["quantity"] as? Double {
                            self.vQtantity4.text = String(quantity)
                        }
                        if let _idVarient  = dict["productId"] as? String {
                            if   _idVarient == self.categoryModel.id {
                                self.variants4.backgroundColor = UIColor.white
                            }
                        }
                    }
                    
                }
                if index == 4 {
                    self.variants5.isHidden = false
                    if let dict  = variants[4] as? NSDictionary {
                        if let price = dict["price"] as? Double {
                            self.vPrice5.text = "\(currency) \(price)"
                        }
                        if let quantity = dict["quantity"] as? Double {
                            self.vQtantity5.text = String(quantity)
                        }
                        if let _idVarient  = dict["productId"] as? String {
                            if   _idVarient == self.categoryModel.id {
                                self.variants5.backgroundColor = UIColor.white
                            }
                        }
                    }
                }
            }
        }else {
            self.stackVarientHight.constant = 0.0
            self.varientStackView.isHidden = true
        }
        
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
            self.delegate?.openLoginView()
        }
    }
    
    @IBAction func varientHandelAction(_ sender: Any) {
        if let btn = sender as? UIButton {
            self.loadUForValient()
            if self.variantsArray.count > btn.tag {
                if let dictVarients = self.variantsArray[btn.tag] as? NSDictionary {
                    self.setUIForSelctedObject(dict: dictVarients, currency: self.varientCurrency as String)
                }
            }
        }
    }
}
extension ProductDetilsCell {
    
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
                        }else {
                            if let msg = valueData["message"] as? String {
                                DispatchQueue.main.async {
                                    if let cv = UIApplication.shared.keyWindow?.rootViewController {
                                    alert(Constants.appName, message: msg, view: cv)
                            }                        }
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
//MARK: UICollectionViewDataSource
extension ProductDetilsCell : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.variantsArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : VarientCell = collectionView.dequeueReusableCell(withReuseIdentifier: "VarientCell", for: indexPath as IndexPath) as! VarientCell
        if let dict = self.variantsArray[indexPath.row] as? NSDictionary {
            cell.selectedVarientId = self.categoryModel.id
            cell.loadData(dict: dict,currency: self.varientCurrency)
        }
        return cell
    }
}
extension ProductDetilsCell : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let dictVarients = self.variantsArray[indexPath.row] as? NSDictionary {
            self.setUIForSelctedObject(dict: dictVarients, currency: self.varientCurrency as String)
        }
    }
    
}
extension ProductDetilsCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let wd = Int(self.frame.size.width-20)/5
        return CGSize(width: wd , height:35)
    }
}

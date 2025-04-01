//
//  CheckOutViewController.swift
//  TamimiEcom
//
//  Created by Ansh on 10/09/20.
//  Copyright © 2020  ltd. All rights reserved.
//

import UIKit
import SVProgressHUD

class CheckOutViewController: UIViewController {
    var prefered_day = ""
    var prefered_time = ""
    
    var ewalletBalance = "0"
    var ewalletCurrency = "SAR"
    var paymenttSlectionType = 0
    var giftCardSelect = false
    var eWalletSelect = false
    
    var clickAndCollect = true
    var infoArray:NSArray!
    var infoTimeArray:NSArray!
    var selectedIndex = -1;
    var selectedSlotIndex = -1;
    var isLocationSelected = false
    @IBOutlet weak var btnHomeDelivery: UIButton!
    @IBOutlet weak var btnClickCollect: UIButton!
    
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var ctView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNib()
        //        self.infoArray = self.getDates(forLastNDays: 7) as NSArray
        self.infoArray = NSArray.init()
        self.infoTimeArray = NSArray.init()
        ctView.delegate = self
        ctView.dataSource = self
        self.getLoyaltyBalance()
        // Do any additional setup after loading the view.
        
    }
    func registerNib() {
        let nibCategory = UINib(nibName: "CheckOutGridCell", bundle: nil)
        self.ctView.register(nibCategory, forCellWithReuseIdentifier: "CheckOutGridCell")
        let nibpaymentMethodCell = UINib(nibName: "paymentMethodCell", bundle: nil)
        self.ctView.register(nibpaymentMethodCell, forCellWithReuseIdentifier: "paymentMethodCell")
        let niubOrderSummaryCell = UINib(nibName: "OrderSummaryCell", bundle: nil)
        self.ctView.register(niubOrderSummaryCell, forCellWithReuseIdentifier: "OrderSummaryCell")
        
        
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func openLocation(_ sender: Any) {
        if clickAndCollect {
            let objLocation : LocationViewController = LocationViewController(nibName: "LocationViewController", bundle: nil)
            self.navigationController?.pushViewController(objLocation, animated: true)
        }else {
            let objLocation : HomeDellivery = HomeDellivery(nibName: "HomeDellivery", bundle: nil)
            self.navigationController?.pushViewController(objLocation, animated: true)
        }
    }
    @IBAction func clieckAndCollectAction(_ sender: Any) {
        clickAndCollect = true
        self.btnClickCollect.backgroundColor = UIColor.init(red: 238.0/255.0, green: 27.0/255.0, blue: 34.0/255.0, alpha: 1)
        self.btnHomeDelivery.backgroundColor = UIColor.init(red: 106.0/255.0, green: 109.0/255.0, blue: 110.0/255.0, alpha: 1)
        self.ctView.reloadData()
    }
    
    @IBAction func homeDeliveryAction(_ sender: Any) {
        clickAndCollect = false
        self.btnHomeDelivery.backgroundColor = UIColor.init(red: 238.0/255.0, green: 27.0/255.0, blue: 34.0/255.0, alpha: 1)
        self.btnClickCollect.backgroundColor = UIColor.init(red: 106.0/255.0, green: 109.0/255.0, blue: 110.0/255.0, alpha: 1)
        self.ctView.reloadData()
    }
    
    
}
//MARK: UICollectionViewDataSource
extension CheckOutViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell : CheckOutGridCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CheckOutGridCell", for: indexPath as IndexPath) as! CheckOutGridCell
            cell.titleLbl.text = "Select your prefered day"
            cell.infoArray = self.infoArray
            cell.selectedInx = self.selectedIndex
            cell.cellType = 0
            cell.delegate = self
            cell.loadData()
            return cell
            
        }else if indexPath.row == 1 {
            let cell : CheckOutGridCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CheckOutGridCell", for: indexPath as IndexPath) as! CheckOutGridCell
            cell.titleLbl.text = "Select your preferred time"
            cell.cellType = 1
            cell.delegate = self
            cell.infoArray = infoTimeArray
            cell.selectedInx = selectedSlotIndex
            cell.loadData()
            return cell
            
        }else if indexPath.row == 2 {
            let cell : paymentMethodCell = collectionView.dequeueReusableCell(withReuseIdentifier: "paymentMethodCell", for: indexPath as IndexPath) as! paymentMethodCell
            cell.paymenttSlectionType = self.paymenttSlectionType
            cell.giftCardSelect = self.giftCardSelect
            cell.eWalletSelect = self.eWalletSelect
            cell.updatePayemtType()
            cell.lblAmmount.text = self.ewalletBalance
            cell.lblAmountHint.text = self.ewalletCurrency
            
            cell.delegate = self
            return cell
        }else {
            let cell : OrderSummaryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderSummaryCell", for: indexPath as IndexPath) as! OrderSummaryCell
            cell.completeOrder.addTarget(self, action: #selector(checkoutCall), for: .touchUpInside)
            return cell
        }
    }
}
extension CheckOutViewController : UICollectionViewDelegate {
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //    }
}
extension CheckOutViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 || indexPath.row == 1 {
            if self.clickAndCollect {
                return CGSize(width: self.view.frame.size.width , height:75)
            }else {
                return CGSize(width: self.view.frame.size.width , height:0)
            }
        }else  if indexPath.row == 2{
            return CGSize(width: self.view.frame.size.width , height:220)
        }else if indexPath.row == 3{
            return CGSize(width: self.view.frame.size.width , height:350)
            
        }else {
            return CGSize(width: self.view.frame.size.width , height:0)
        }
    }
}

extension CheckOutViewController:PaymentsMethodType {
    func selectPaymentsOption(indx: Int) {
        self.paymenttSlectionType = indx
    }
    
    func isGiftCardSelect(isSlect: Bool) {
        self.giftCardSelect = isSlect
    }
    
    func iseWalletSelect(isSlect: Bool) {
        self.eWalletSelect = isSlect
    }
    @objc func checkoutCall() {
        if self.prefered_day == "" {
            alert(Constants.appName, message: "Please select Prefered Day", view: self)
        }
        else if self.prefered_time == "" {
            alert(Constants.appName, message: "Please select Prefered Time", view: self)
        }else {
            SVProgressHUD.show()
            let orderNumber = ApplicationStates.getOrderNumber()
            let post:[String:Any] = [
                "orderNumber": orderNumber,
                "orderId": ApplicationStates.getOrderId(),
                "customerId": ApplicationStates.getUserID(),
            ]
            
            NetworkManager.shared.postJSONResponse(path:Constants.handleOrder, parameters:post) { (value, status) in
                switch status {
                case .success:
                    if let valueData  = value as? NSDictionary {
                        if let code = valueData["code"] as? Int {
                            if code == 201 {
                                print(valueData);
                                self.payMentsCheckout()
                            }
                            else {
                                if let msg = valueData["message"] as? String {
                                    DispatchQueue.main.async {
                                        alert(Constants.appName, message: msg, view: self)
                                    }                        }
                                
                            }
                        }
                    }
                case .error(let error):
                    print(error!)
                }
            }
        }
    }
    func payMentsCheckout() {
        SVProgressHUD.show()
        var paymentType = "Debit Card"
        if paymenttSlectionType == 0 {
            paymentType = "Debit Card"
        }
        else if paymenttSlectionType == 1 {
            paymentType = "Credit Card"
        }
        else if paymenttSlectionType == 2 {
            paymentType = "Cash on Delivery"
        }
        let orderNumber = ApplicationStates.getOrderNumber()
        let post:[String:Any] = [
            "orderNumber": orderNumber,
            "orderId": ApplicationStates.getOrderId(),
            "userId": ApplicationStates.getUserID(),"isHome": false,"paymentType":paymentType,"prefered_day":prefered_day,"prefered_time":prefered_time
        ]
        NetworkManager.shared.postJSONResponse(path:Constants.addPayment, parameters:post,isLoder: true,isHeader: true) { (value, status) in
            switch status {
            case .success:
                if let valueData  = value as? NSDictionary {
                    if let code = valueData["code"] as? Int {
                        if code == 201 {
                            if let data = valueData["data"]  as? NSDictionary {
                                self.openPayMentSDK(data: data)
                            }
                        }else {
                            if let msg = valueData["message"] as? String {
                                DispatchQueue.main.async {
                                    alert(Constants.appName, message: msg, view: self)
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
    func openPayMentSDK(data:NSDictionary) {
        if let checkoutID  = data["id"]  as? String {
            if paymenttSlectionType == 2 {
                self.lastFinsalStausFromServer(checkoutID: checkoutID)
                return
            }
            
            let provider = OPPPaymentProvider(mode: OPPProviderMode.test)
            
            let checkoutSettings = OPPCheckoutSettings()
            
            // Set available payment brands for your shop
//            checkoutSettings.paymentBrands = ["VISA", "DIRECTDEBIT_SEPA"]
            
            // Set shopper result URL
            checkoutSettings.shopperResultURL = "com.companyname.appname.payments://result"
            let checkoutProvider = OPPCheckoutProvider(paymentProvider: provider, checkoutID: checkoutID, settings: checkoutSettings)
            // Since version 2.13.0
            checkoutProvider?.presentCheckout(forSubmittingTransactionCompletionHandler: { (transaction, error) in
                guard let transaction = transaction else {
                    print(error)
                    // Handle invalid transaction, check error
                    //show Error
                    return
                }
                
                if transaction.type == .synchronous {
                    // If a transaction is synchronous, just request the payment status
                    // You can use transaction.resourcePath or just checkout ID to do it
                    self.lastFinsalStausFromServer(checkoutID: checkoutID)
                } else if transaction.type == .asynchronous {
                    // The SDK opens transaction.redirectUrl in a browser
                    // See 'Asynchronous Payments' guide for more details
                    self.lastFinsalStausFromServer(checkoutID: checkoutID)

                } else {
                    // Executed in case of failure of the transaction for any reason
                    
                }
            }, cancelHandler: {
                // Executed if the shopper closes the payment page prematurely
                //User Cancel ----
            })
        }
    }
    func  lastFinsalStausFromServer(checkoutID:String) {
        let orderNumber = ApplicationStates.getOrderNumber()
        let params:[String:Any] = [
            "orderNumber": orderNumber,"checkoutID":checkoutID
        ]
        NetworkManager.shared.getJSONResponse(path:Constants.statusPayment, parameters:params,isHeader: true) { (value, status) in
            print(value)
            switch status {
            case .success:
                if let valueData  = value as? NSDictionary {
                    if let code = valueData["code"] as? Int {
                        DispatchQueue.main.async {
                            SVProgressHUD.dismiss()
                            if code == 201 {
                                print(valueData);
                                self.openFeedBackScreen()
                            }else {
                                if let msg = valueData["message"] as? String {
                                    alert(Constants.appName, message: msg, view: self)
                                    
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
    func openFeedBackScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let checkOutFeedbackViewController = storyboard.instantiateViewController(withIdentifier: "CheckOutFeedbackViewController") as! CheckOutFeedbackViewController
        self.navigationController?.pushViewController(checkOutFeedbackViewController, animated: true)
    }
}
extension CheckOutViewController : ClickInformationCheckOutGrid {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateLocation()
        if !self.isLocationSelected {
            self.fetchAvailableSlotInformation()
        }
    }
    func updateLocation() {
        if  let info =    ApplicationStates.getLocationInformation() as? NSDictionary{
            if let locationName = info["locationName"] as? String {
                self.lblLocation.text = locationName
            }else  {
                self.lblLocation.text = "Select Your Location"
            }
        }
    }
    func clickIndex(indx: Int,cellType:Int,slot:String) {
        if cellType == 0 {
            if ApplicationStates.getLocationSelctedID() != "" {
                self.selectedIndex = indx
                self.setPeferDay()
            }
            else {
                self.selectedIndex = -1
                let indexPath = IndexPath(item: 0, section: 0)
                self.ctView.reloadItems(at: [indexPath])
                let objLocation : LocationViewController = LocationViewController(nibName: "LocationViewController", bundle: nil)
                self.navigationController?.pushViewController(objLocation, animated: true)
            }
            
        }else {
            if indx == -1  {
                alert(Constants.appName, message: "Slot is not available", view: self)
            }else {
                self.selectedSlotIndex = indx
            }
        }
        self.prefered_time = slot
    }
    func setPeferDay() {
        if self.selectedIndex == -1 {
            self.prefered_day = "";
            return;
        }
        if let dict = self.infoArray.object(at: self.selectedIndex) as? NSDictionary{
            if let date = dict["date"] as? String {
                self.prefered_day = date
                self.updateSlot(withIndx: self.selectedIndex)
            }
        }
        
    }
}
extension CheckOutViewController {
    func getDates(forLastNDays nDays: Int) -> [NSDictionary] {
        let cal = NSCalendar.current
        // start with today
        var date = cal.startOfDay(for: Date())
        var arrDates  = [NSDictionary]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        for index in 0...nDays  {
            // move back in time by one day:
            let dict  = NSMutableDictionary.init()
            if index == 0 {
                dict["date"] = dateFormatter.string(from: date)
                dict["info"] = "Today"
                arrDates.append(dict)
            }  else if index == 1 {
                date = cal.date(byAdding: Calendar.Component.day, value: +1, to: date)!
                dict["date"] = dateFormatter.string(from: date)
                dict["info"] = "Tomorrow"
                arrDates.append(dict)
            }
            else {
                date = cal.date(byAdding: Calendar.Component.day, value: +1, to: date)!
                dateFormatter.dateFormat = "MM-dd-yyyy"
                dict["date"] = dateFormatter.string(from: date)
                dateFormatter.dateFormat = "EEE, MMM  dd'\(self.dateST(date: date))'"
                dict["info"] = dateFormatter.string(from: date)
                arrDates.append(dict)
                
            }
            
        }
        print(arrDates)
        return arrDates
    }
    func dateST(date:Date) -> String {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        switch day {
        case 11...13: return "th"
        default:
            switch day % 10 {
            case 1: return "st"
            case 2: return "nd"
            case 3: return "rd"
            default: return "th"
            }
        }
    }
}
extension CheckOutViewController {
    func getLoyaltyBalance () {
        let post:[String:Any] = [
            "userId": ApplicationStates.getUserID(),
            "sid": ApplicationStates.getUserSid()]
        NetworkManager.shared.postJSONResponse(path:  Constants.getloyaltybalance, parameters:post) { (value, status) in
            switch status {
            case .success:
                if let valueData  = value as? NSDictionary {
                    if let code = valueData["code"] as? Int {
                        if code == 201 {
                            if let data = valueData["data"]  as? NSDictionary {
                                if let  ewallet_balance = data["ewallet_balance"] as? String {
                                    self.ewalletBalance = ewallet_balance
                                }
                                if let  ewallet_currency = data["ewallet_currency"] as? String {
                                    self.ewalletCurrency = ewallet_currency
                                }
                                let indexPath = IndexPath(item: 2, section: 0)
                                self.ctView.reloadItems(at: [indexPath])
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
extension CheckOutViewController {
    func fetchAvailableSlotInformation() {
        if  let info =    ApplicationStates.getLocationInformation() as? NSDictionary{
            if let locationId = info["locationId"] as? String {
                self.isLocationSelected = true
                SVProgressHUD.show()
                let orderNumber = ApplicationStates.getOrderNumber()
                let post:[String:Any] = [
                    "orderNumber": orderNumber,
                    "orderId": ApplicationStates.getOrderId(),
                    "storeId": locationId,
                ]
                NetworkManager.shared.postJSONResponse(path:Constants.fetchAvailableSlots, parameters:post) { (value, status) in
                    switch status {
                    case .success:
                        if let valueData  = value as? NSDictionary {
                            if let code = valueData["code"] as? Int {
                                if code == 201 {
                                    if let data =  valueData["data"] as? NSArray {
                                        self.infoArray = data
                                        if self.infoArray.count > 0 {
                                            self.selectedIndex = 0
                                            self.setPeferDay()
                                            let indexPath = IndexPath(item: 0, section: 0)
                                            self.ctView.reloadItems(at: [indexPath])
                                            self.updateSlot(withIndx: self.selectedIndex)
                                        }
                                    }
                                }
                                else {
                                    if let msg = valueData["message"] as? String {
                                        DispatchQueue.main.async {
                                            alert(Constants.appName, message: msg, view: self)
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
        }else {
            alert(Constants.appName, message: "Please choose location", view: self)
        }
    }
    func updateSlot(withIndx:Int) {
        if self.infoArray.count > withIndx {
            self.selectedSlotIndex = -1
            if let dict = self.infoArray.object(at: withIndx) as? NSDictionary {
                if let  slots = dict["slots"] as? NSArray {
                    self.infoTimeArray = slots
                    
                }else {
                    self.infoTimeArray = NSArray.init()
                }
                let indexPath = IndexPath(item: 1, section: 0)
                self.ctView.reloadItems(at: [indexPath])
            }
        }
    }
}

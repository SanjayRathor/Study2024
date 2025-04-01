//
//  MyOrderDetialsVC.swift
//  TamimiEcom
//
//  Created by Ansh on 21/09/20.
//  Copyright © 2020  ltd. All rights reserved.
//

import UIKit
class MyOrderPayDetails:UITableViewCell {
    @IBOutlet weak var lblKey: UILabel!
    
    @IBOutlet weak var lblValue: UILabel!
}
class MyOrderSummearyCell:UITableViewCell {
    @IBOutlet weak var lblFinalQt: UILabel!
    
    @IBOutlet weak var lineHint: UIImageView!
    @IBOutlet weak var lblYouPay: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblName: UILabel!
}
class MyOrderSummearyHintCell:UITableViewCell {
    @IBOutlet weak var lblHint: UILabel!
    
}
class MyOrderDetailsCell:UITableViewCell {
    @IBOutlet weak var lblPickUpHint: UILabel!
    
    @IBOutlet weak var lblPickUpAddress: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblPreferSlot: UILabel!
    @IBOutlet weak var lblPreferDate: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblOrderNumber: UILabel!
}
class MyOrderDetialsVC: UIViewController {
    var orderDict:NSDictionary!
    @IBOutlet weak var tbView: UITableView!
    var paymentsDetaisArray : NSMutableArray!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.paymentsDetaisArray = NSMutableArray.init()
        self.tbView.delegate = self
        self.tbView.dataSource = self
        self.getMyorderData()
        self.setStaticData()
        // Do any additional setup after loading the view.
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setStaticData() {
        paymentsDetaisArray.add(["Price":"122.40"])
        paymentsDetaisArray.add(["Product Discount":"122.40"])
        paymentsDetaisArray.add(["Coupon Discount":"42.40"])
        paymentsDetaisArray.add(["Shipping Charges":"12.40"])
        paymentsDetaisArray.add(["Amount Paid":"2.40"])
        paymentsDetaisArray.add(["Amount Payable":"0.00"])
        paymentsDetaisArray.add(["Payment Mode":"0.00"])
        
    }
}
extension MyOrderDetialsVC:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10
        }
        return 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let hv = UIView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: section == 0 ? 10 : 1))
        hv.backgroundColor = UIColor.clear
        return hv
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        }else  if indexPath.section == 1  {
            return 40
        }
        else  if indexPath.section == 2{
            if indexPath.row == 0 {
                return 40
            }else {
                return 70
            }
        }
        else  if indexPath.section == 3{
            return 50
        }
        else  if indexPath.section == 4{
            return 20
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0  || section == 1 || section == 3{
            return 1
        }
        else if section == 2 {
            return 3
        }else if section == 4 {
            return self.paymentsDetaisArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell : MyOrderDetailsCell = tableView.dequeueReusableCell(withIdentifier: "MyOrderDetailsCell", for: indexPath) as! MyOrderDetailsCell
            let attributedString = NSMutableAttributedString(string: "STATUS: COMPLETED", attributes: [
                .font: UIFont(name: "SegoeUI-Bold", size: 10.0)!,
                .foregroundColor: UIColor(red: 0.0, green: 179.0 / 255.0, blue: 67.0 / 255.0, alpha: 1.0)
            ])
            attributedString.addAttributes([
                .font: UIFont(name: "SegoeUI", size: 10.0)!,
                .foregroundColor: UIColor(red: 106.0 / 255.0, green: 109.0 / 255.0, blue: 110.0 / 255.0, alpha: 1.0)
            ], range: NSRange(location: 0, length: 8))
            
            cell.lblStatus.attributedText = attributedString
            return cell
        }else if indexPath.section == 1 ||  indexPath.section == 3{
            let cell : MyOrderSummearyHintCell = tableView.dequeueReusableCell(withIdentifier: "MyOrderSummearyHintCell", for: indexPath) as! MyOrderSummearyHintCell
            if indexPath.section == 1 {
                cell.lblHint.text = "ORDER SUMMARY"
            }else {
                cell.lblHint.text = "PAYMENT DETAILS"
            }
            return cell
        }else if indexPath.section == 2{
            let cell : MyOrderSummearyCell = tableView.dequeueReusableCell(withIdentifier: "MyOrderSummearyCell", for: indexPath) as! MyOrderSummearyCell
            if indexPath.row == 0 {
                cell.lblName.text = "You Pay"
                cell.lblPrice.text = "Price"
                cell.lblFinalQt.text = "Final Qty"
                cell.lblYouPay.text = "You Pay"
                
            }else {
                cell.lblName.text = "Al Walimah Brown Rice\n- 2 Kg"
                cell.lblPrice.text = "19.95 SAR"
                cell.lblFinalQt.text = "1"
                cell.lblYouPay.text = "19.95 SAR"
            }
            cell.lineHint.isHidden = false
            
            if indexPath.row == 3 {
                cell.lineHint.isHidden = true
                
            }
            return cell
            
        }else {
            let cell : MyOrderPayDetails = tableView.dequeueReusableCell(withIdentifier: "MyOrderPayDetails", for: indexPath) as! MyOrderPayDetails
            cell.lblKey.textColor = UIColor.init(red: 106.0/255.0, green: 109.0/255.0, blue: 110.0/255.0, alpha: 1.0)
            cell.lblValue.textColor = UIColor.init(red: 106.0/255.0, green: 109.0/255.0, blue: 110.0/255.0, alpha: 1.0)
            cell.lblKey.font = UIFont(name: "SegoeUI", size: 12);
            cell.lblValue.font = UIFont(name: "SegoeUI", size: 12);
            
            if let dict = self.paymentsDetaisArray[indexPath.row] as? NSDictionary {
                cell.lblKey.text = dict.allKeys.first as? String
                cell.lblValue.text = dict.allValues.first as? String
                if cell.lblKey.text == "Amount Payable" {
                    cell.lblKey.textColor = UIColor.init(red: 238.0/255.0, green: 27.0/255.0, blue: 34.0/255.0, alpha: 1.0)
                    cell.lblValue.textColor = UIColor.init(red: 238.0/255.0, green: 27.0/255.0, blue: 34.0/255.0, alpha: 1.0)
                    cell.lblKey.font = UIFont(name: "SegoeUI-SemiBold", size: 12);
                    cell.lblValue.font = UIFont(name: "SegoeUI-SemiBold", size: 12);
                    
                }
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
extension MyOrderDetialsVC {
    func getMyorderData() {
        if let orderId = self.orderDict["_id"] as? String {
        let requestPath =  "\(Constants.getCompletedOrderDetails)?orderId=\(orderId)"
        NetworkManager.shared.getJSONResponse(path: requestPath,isLoader:true) { (value, status) in
            print(value)
            switch status {
            case .success:
                if let valueData  = value as? NSDictionary {
                    if let success = valueData["success"] as? Int {
                        if success == 1 {
                            if let data = valueData["data"] as? NSArray {
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
}

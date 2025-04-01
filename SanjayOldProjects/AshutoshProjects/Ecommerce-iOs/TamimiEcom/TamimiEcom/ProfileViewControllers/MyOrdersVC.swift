//
//  MyOrdersVC.swift
//  TamimiEcom
//
//  Created by Ansh on 20/09/20.
//  Copyright © 2020  ltd. All rights reserved.
//

import UIKit
class MyOrderCell:UITableViewCell {
    
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblPreferSlot: UILabel!
    @IBOutlet weak var lblPreferDate: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblOrderNumber: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
}
class MyOrdersVC: UIViewController {
    var itemArray = NSMutableArray()
    @IBOutlet weak var tbView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tbView.delegate = self
        tbView.dataSource = self
        self.itemArray = NSMutableArray.init()
        self.getMyorderData()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension MyOrdersVC:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let hv = UIView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 10))
        hv.backgroundColor = UIColor.clear
        return hv
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MyOrderCell = tableView.dequeueReusableCell(withIdentifier: "MyOrderCell", for: indexPath) as! MyOrderCell
            if let dict = self.itemArray[indexPath.row] as? NSDictionary {
                
                   // print(dict);
                    if let orderNumber = dict["orderNumber"] as? String{
                        cell.lblOrderNumber.text = "ORDER# \(orderNumber)"
                    }
                    if let totalPrice = dict["totalPrice"] as? Double{
                        //Need Courrency
                    cell.lblPrice.text = "\(totalPrice) SAR"
                    }
                    if var createdAt = dict["createdAt"] as? String{
                        if createdAt.count > 8 {
                         createdAt.removeLast(8)
                        }
                        createdAt = createdAt.replacingOccurrences(of: "T", with: " ")

                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                        if   let date = dateFormatter.date(from: createdAt) {
                        dateFormatter.dateFormat = "dd. MMM. yyyy hh:mm a"
                            cell.lblDate.text = "DATE: \(dateFormatter.string(from: date).uppercased())"
                        }else {
                    cell.lblDate.text = "DATE: \(createdAt)"
                        }
                    }
                    if let preferDate = dict["prefered_day"] as? String{
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MM-dd-yyyy"
                        if   let date = dateFormatter.date(from: preferDate) {
                        dateFormatter.dateFormat = "dd. MMM. yyyy"
                            cell.lblPreferDate.text = "PREFFERED DATE:  \(dateFormatter.string(from: date).uppercased())"
                        }else {
                            cell.lblPreferDate.text = "PREFFERED DATE: \(preferDate)"
                        }
                    }
                 if let preferDate = dict["prefered_time"] as? String{
                cell.lblPreferSlot.text = "PREFFERED SLOT:  \(preferDate)"
                }
                    cell.lblStatus.textColor = UIColor(red: 106.0/255.0, green: 109.0/255.0, blue: 110.0/255.0, alpha: 1.0)
                
                     cell.lblStatus.text = ""
                    if let order_status = dict["order_status"] as? String{
                        if order_status == "CANCELLED" {
                            cell.lblStatus.textColor = UIColor(red: 238.0/255.0, green: 27.0/255.0, blue: 34.0/255.0, alpha: 1.0)
                        }else if order_status == "COMPLETED" {
                            cell.lblStatus.textColor = UIColor(red: 0.0/255.0, green: 159.0/255.0, blue: 38.0/255.0, alpha: 1.0)

                        }
                        cell.lblStatus.text = "\(order_status)"
                    }
                    
                
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let dict = self.itemArray[indexPath.row] as? NSDictionary {
        let storyboard = UIStoryboard(name: "UserMoreInfo", bundle: nil)
        let myOrderDetialsVC = storyboard.instantiateViewController(withIdentifier: "MyOrderDetialsVC") as! MyOrderDetialsVC
            myOrderDetialsVC.orderDict = dict
        self.navigationController?.pushViewController(myOrderDetialsVC, animated: true)
        }
    }
}
extension MyOrdersVC {
    func getMyorderData() {
        let requestPath =  "\(Constants.viewCustomerOrders)?customerId=\(ApplicationStates.getUserID())"
        NetworkManager.shared.getJSONResponse(path: requestPath,isLoader:true) { (value, status) in
            switch status {
            case .success:                
                if let valueData  = value as? NSDictionary {
                    if let success = valueData["success"] as? Int {
                        if success == 1 {
                            self.itemArray.removeAllObjects()
                            if let data = valueData["data"] as? NSArray {
                                self.itemArray.addObjects(from: data as! [Any])
                            }
                            self.tbView.reloadData()
                        }
                    }
                }
            case .error(let error):
                print(error!)
            }
            
        };
    }
}

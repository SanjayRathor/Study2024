//
//  PreviousViewController.swift
//  Jaee2
//
//  Created by Abdulaziz  Almohsen on 6/27/17.
//  Copyright © 2017 Jaee. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import Haneke
import JTMaterialSpinner


class PreviousViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var spinnerView = JTMaterialSpinner()

    var history = [Previous]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(spinnerView)
        spinnerView.frame = CGRect(x: (375.0 - 50.0) / 2.0, y: 300, width: 50, height: 50)
        spinnerView.circleLayer.lineWidth = 2.0
        spinnerView.circleLayer.strokeColor = UIColor.orange.cgColor
        spinnerView.beginRefreshing()
        spinnerView.animationDuration = 2.5
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
getData()
        // Do any additional setup after loading the view.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if history.count > 0 {
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = .singleLine
            return 1
            
            
        }
        
        let rect = CGRect(x: 0,
                          y: 0,
                          width: self.tableView.bounds.size.width,
                          height: self.tableView.bounds.size.height)
        let noDataLabel: UILabel = UILabel(frame: rect)
        
        noDataLabel.text = "لا يوجد طلبات سابقة في الوقت الحالي آنتظر ⛹🏽"
        noDataLabel.textColor = UIColor.white
        noDataLabel.textAlignment = NSTextAlignment.center
        self.tableView.backgroundView = noDataLabel
        self.tableView.separatorStyle = .none
        
        
        
        return 1
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for:  indexPath) as! PreviousTableViewCell
        
        let entry = history[indexPath.row]
        
        
        cell.shopName.text = entry.shop_name
        cell.orderrNumber.text = "# \(entry.order_id)"
        cell.imageCell.hnk_setImage(from: URL(string: entry.logo))
    
        
        return cell
        
    }
    
    @IBAction func back(_ sender: UITapGestureRecognizer) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func getData () {
        
        let param = ["user_id":"\(UserDataSingleton.sharedDataContainer.user_id!)",]
        let urlStr = "http://jaeeapp.com/api/client/history"
        let url = URL(string: urlStr)
        
        
        let user = "apiuser"
        let password = "ApiAuthPass2017"
        
        
        
        var headers: HTTPHeaders = [
            "Authorization": "Basic YXBpdXNlcjpBcGlBdXRoUGFzczIwMTchQCM="
        ]
        
        
        Alamofire.request(url!, method: .post, parameters: param,encoding: URLEncoding.default, headers: headers).responseJSON { response in
            if let value: AnyObject = response.result.value as AnyObject? {
                //Handle the results as JSON
                
                
                
                let data = JSON(value)
                print(data)
                for (key,subJson):(String, JSON) in  data["orders"] {

                
                let total = subJson["total"].stringValue
                let orderStatus = subJson["order_statuses"]["name"].stringValue
                let id = subJson["id"].stringValue
                let shopeName = subJson["family"]["name"].stringValue
                let shopLogo = subJson["family"]["logo"].stringValue
                let date = subJson["updated_at"].stringValue
               let logoString = "http://jaeeapp.com/upload/img/\(shopLogo)"

                    
                    let info = Previous(order_id: id,  shop_name: shopeName,  logo : logoString)
                    self.history.append(info)
                    
                    
            }
                
                DispatchQueue.main.async {
                    self.spinnerView.endRefreshing()
                    
                    self.tableView.reloadData()
                    
                }
        }
        
    }
    }
    
   
    
    @IBAction func dissmissTapped(_ sender: UIBarButtonItem) {
         dismiss(animated: true, completion: nil)
    }
    
   }

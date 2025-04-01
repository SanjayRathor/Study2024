//
//  CartViewController.swift
//  Jaee2
//
//  Created by Abdulaziz  Almohsen on 6/26/17.
//  Copyright © 2017 Jaee. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MGSwipeTableCell
import JTMaterialSpinner
import CoreLocation


typealias MailActionCallback = (_ cancelled: Bool, _ deleted: Bool, _ actionIndex: Int) -> Void

class CartViewController: UIViewController , UITableViewDelegate , UITableViewDataSource,MGSwipeTableCellDelegate , UIActionSheetDelegate, CLLocationManagerDelegate{

    var actionCallback: MailActionCallback?;
    var spinnerView = JTMaterialSpinner()

  

    @IBOutlet weak var editbtn: UIButton!
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var total: UILabel!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var totalLab: UILabel!
    @IBOutlet weak var proceedbtn: UIButton!
    
    var name = ""
    var price = ""
    var qty = ""
    var id = ""
 
    var totalNumberOfRows = 00
    let locationManager = CLLocationManager()

    
    
    var  hello = [String]()

    var carts = [Cart]();
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Cart")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)

        
        self.locationManager.requestAlwaysAuthorization()

        self.view.addSubview(spinnerView)

        spinnerView.frame = CGRect(x: (375.0 - 50.0) / 2.0, y: 300, width: 50, height: 50)
        
        spinnerView.circleLayer.lineWidth = 2.0
        spinnerView.circleLayer.strokeColor = UIColor.orange.cgColor
        spinnerView.beginRefreshing()
        spinnerView.animationDuration = 2.5

        
        
        
        tableView.tableFooterView = UIView()
        if self.carts.isEmpty == true {
            self.totalLab.isHidden = true
            self.total.isHidden = true
            self.editbtn.isHidden = true
            self.bottomView.isHidden = true
            self.proceedbtn.isHidden = true
            self.bottomView.isHidden = true

            
        }

        getData ()
     tableView.delegate = self
     tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
  
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt index: Int) {
        if let action = actionCallback {
            action(index == actionSheet.cancelButtonIndex,
                   index == actionSheet.destructiveButtonIndex,
                   index);
            actionCallback = nil;
        }
    }

    

    

        func numberOfSections(in tableView: UITableView) -> Int {
            if carts.count > 0 {
                self.tableView.backgroundView = nil
                self.tableView.separatorStyle = .singleLine
                return 1
 
                
            }
            
//            let rect = CGRect(x: 0,
//                              y: 0,
//                              width: self.tableView.bounds.size.width,
//                              height: self.tableView.bounds.size.height)
//            let noDataLabel: UILabel = UILabel(frame: rect)
//
//            noDataLabel.text = "⛹🏽"
//            noDataLabel.textColor = UIColor.white
//            noDataLabel.textAlignment = NSTextAlignment.center
//            self.tableView.backgroundView = noDataLabel
//            self.tableView.separatorStyle = .none
//

            
            return 1
        }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carts.count
    }

    func deleteMail(_ path:IndexPath) {
        guard carts.count > path.row else {
            print("Index out of range")
            return
        }
        
        let entry = carts[path.row]
        deletItem(id: entry.meal_id)// call api to delete items
        carts.remove(at: (path as NSIndexPath).row);
        
        //You have to disable the button while delete the cells from cart table view
        if (carts.isEmpty) {
            self.total.isHidden = true
            self.proceedbtn.isHidden = true
            self.totalLab.isHidden = true
            self.bottomView.isHidden = true
            
        }
        
        tableView.deleteRows(at: [path], with: .left);
        
    }
    func mailForIndexPath(_ path: IndexPath) -> Cart {
        return carts[(path as NSIndexPath).row];
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let reuseIdentifier = "OrderCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CartTableViewCell
        let entry = carts[indexPath.row]
        cell.delegate = self;

        cell.nameofItem.text = entry.meal_name
        cell.price.text = "\(entry.price)ريال"
        cell.qty.text = entry.qty
        
        
        cell.imageX.isHidden = !isImageDisplaying

        
        return cell
    }
    
    var isImageDisplaying: Bool = false {
        didSet {
            tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50;
    }
    
    func swipeTableCell(_ cell: MGSwipeTableCell, canSwipe direction: MGSwipeDirection) -> Bool {
        return true;
    }
    func showMailActions(_ mail: Cart, callback: @escaping MailActionCallback) {
        actionCallback = callback;
        let sheet = UIActionSheet.init(title: "Actions", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Trash    ");
        
        sheet.show(in: self.view);
    }

    
    func swipeTableCell(_ cell: MGSwipeTableCell, swipeButtonsFor direction: MGSwipeDirection, swipeSettings: MGSwipeSettings, expansionSettings: MGSwipeExpansionSettings) -> [UIView]? {
        
        swipeSettings.transition = MGSwipeTransition.border;
        expansionSettings.buttonIndex = 0;
        
        
        let mail = mailForIndexPath(tableView.indexPath(for: cell)!);
        
        
        
        expansionSettings.fillOnTrigger = true;
        expansionSettings.threshold = 1.1;
        let padding = 15;
        let color1 = UIColor.init(red:1.0, green:59/255.0, blue:50/255.0, alpha:1.0);
        let color2 = UIColor.init(red:1.0, green:149/255.0, blue:0.05, alpha:1.0);
        let color3 = UIColor.init(red:200/255.0, green:200/255.0, blue:205/255.0, alpha:1.0);
        
        let trash = MGSwipeButton(title: "Trash", backgroundColor: color1, padding: padding, callback: { (cell) -> Bool in
            self.deleteMail(self.tableView.indexPath(for: cell)!);
            return false; //don't autohide to improve delete animation
        });
        
        
        
        let more = MGSwipeButton(title: "More", backgroundColor: color3, padding: padding, callback: {
            (cell) -> Bool in
            let path = self.tableView.indexPath(for: cell)!;
            let mail = self.mailForIndexPath(path);
            
            self.showMailActions(mail, callback: { (cancelled, deleted, index) in
                if cancelled {
                    return;
                }
                else if deleted {
                    self.deleteMail(path);
                }
                
                
            });
            
            return false; // Don't autohide
        });
        
        return [trash, more];
    }
    



    @IBAction func Back(_ sender:
        UITapGestureRecognizer) {
        
        performSegue(withIdentifier: "main", sender: self)
    }



    @IBAction func proceed(_ sender: Any) {
        
        
    }
    func getData () {
        
       
        spinnerView.beginRefreshing()
        let param = ["user_id":"\(UserDataSingleton.sharedDataContainer.user_id!)",]
        let urlStr = "http://jaeeapp.com/api/client/cart_meals"
        let url = URL(string: urlStr)
        let user = "apiuser"
        let password = "ApiAuthPass2017"
        
        var headers: HTTPHeaders = [
            "Authorization": "Basic YXBpdXNlcjpBcGlBdXRoUGFzczIwMTchQCM="
        ]
        
        Alamofire.request(url!, method: .post, parameters: param,encoding: URLEncoding.default, headers: headers).responseJSON { response in
            if let value: AnyObject = response.result.value as AnyObject? {
                //Handle the results as JSON
                let usertoken = JSON(value)
                print(response)
                
                let total = usertoken["total"].stringValue
                self.total.text = "\(total) ريال "
                
                for (key,subJson):(String, JSON) in  usertoken["meals"] {
                    
                    if subJson["price"].stringValue == "0" {
                        self.price = subJson["meal"]["price"].stringValue
                        
                    } else {
                        self.price = subJson["price"].stringValue
                     }
                     self.qty = subJson["qty"].stringValue
                    
                    
                     let id = subJson["id"].stringValue
                    
                  self.id = id
                  self.name = subJson["meal"]["name"].stringValue
                
                    
                    let info = Cart(meal_id: self.id, qty: self.qty, meal_name: self.name, price: self.price)
                    
                    self.carts.append(info)
                    
                    if self.carts.isEmpty == true {
                        self.proceedbtn.isHidden = true
                        self.totalLab.isHidden = true
                        self.total.isHidden = true
                        self.editbtn.isHidden = true
                        self.bottomView.isHidden = true
                    
                        
                        
                    } else {
                        if self.carts.isEmpty == false {
                            print("NOT empty")
                            
                            
                            
                            self.hello.append(self.qty)
                            
                           self.totalNumberOfRows = self.carts.count
                                
                                self.proceedbtn.isHidden = false
                            self.totalLab.isHidden = false
                            self.total.isHidden = false
                            self.editbtn.isHidden = false
                            self.bottomView.isHidden = false
                        }

                    }
                    
}

            }
            DispatchQueue.main.async {
                
            
                
                
                self.spinnerView.endRefreshing()
                
                if self.carts.isEmpty == true {
                    self.bottomView.isHidden = true

                    let rect = CGRect(x: 0,
                                      y: 0,
                                      width: self.tableView.bounds.size.width,
                                      height: self.tableView.bounds.size.height)
                    let noDataLabel: UILabel = UILabel(frame: rect)
                    
                    noDataLabel.text = "سلتك فارغة حاليا  "
                    noDataLabel.textColor = UIColor.white
                    noDataLabel.textAlignment = NSTextAlignment.center
                    noDataLabel.font = noDataLabel.font.withSize(20)
                    self.tableView.backgroundView = noDataLabel
                    self.tableView.separatorStyle = .none
                    
                    
                }
                self.tableView.reloadData()
                
            }
        }
        
    }
    
   
    
    func deletItem (id :String){
        
        print(id)
        let param = ["id":"\(id)",]
        let urlStr = "http://jaeeapp.com/api/client/cart"
        let url = URL(string: urlStr)
        
        
        let user = "apiuser"
        let password = "ApiAuthPass2017"
        
        
        
        var headers: HTTPHeaders = [
            "Authorization": "Basic YXBpdXNlcjpBcGlBdXRoUGFzczIwMTchQCM="
        ]
        
        
        Alamofire.request(url!, method: .delete, parameters: param,encoding: URLEncoding.default, headers: headers).responseJSON { response in
            if let value: AnyObject = response.result.value as AnyObject? {
                //Handle the results as JSON
                
                
                let usertoken = JSON(value)
                print(usertoken)
                if usertoken["success"].bool == true {
                    self.updateTotal ()

                    print("deleted the item")
                } else {
                    
                    let alert = UIAlertController(title: "حذف منتج", message: "حدث خطاء اثناء الحذف", preferredStyle: .alert)
                    let action = UIAlertAction(title: "معاودة", style: .default, handler: nil)
                    alert.addAction(action)
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        
    }
    func updateTotal (){
        let param = ["user_id":"\(UserDataSingleton.sharedDataContainer.user_id!)",]
        let urlStr = "http://jaeeapp.com/api/client/cart_meals"
        let url = URL(string: urlStr)
        
        
        let user = "apiuser"
        let password = "ApiAuthPass2017"
        
        
        
        var headers: HTTPHeaders = [
            "Authorization": "Basic YXBpdXNlcjpBcGlBdXRoUGFzczIwMTchQCM="
        ]
        
        
        Alamofire.request(url!, method: .post, parameters: param,encoding: URLEncoding.default, headers: headers).responseJSON { response in
            if let value: AnyObject = response.result.value as AnyObject? {
                //Handle the results as JSON
                
                
                let usertoken = JSON(value)
                
                print(usertoken)
                if  usertoken["total"].stringValue == "0.00" {
                    self.total.text = ""
                    self.editbtn.isHidden = true
                }
                let total = usertoken["total"].stringValue
                self.total.text = total
                
            }
            
        }
        
    }
    

    @IBAction func edit(_ sender: Any) {
        isImageDisplaying = !isImageDisplaying
        if !isImageDisplaying {
        self.editbtn.setTitle("تعديل", for: .normal )
        }
        else {
            
            self.editbtn.setTitle("تم", for: .normal )

        }
    }
    
    }
 


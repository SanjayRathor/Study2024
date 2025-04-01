//
//  ViewController.swift
//  Jaee2
//
//  Created by Abdulaziz  Almohsen on 6/25/17.
//  Copyright © 2017 Jaee. All rights reserved.
//

import UIKit
import Haneke
import Alamofire
import Foundation
import SwiftyJSON
import HMScrollNavigationBar
import TIPBadgeManager
import JTMaterialSpinner
import Cosmos
import OneSignal
import ViewAnimator
import PinterestSegment


class ViewControlvar: UIViewController, UITableViewDelegate , UITableViewDataSource , UISearchBarDelegate  {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    // search bar
    
    
    //    var data : [Shops] = ()
    var auxiliar = [Shops]()
    var searchActive: Bool = false
    var filteredArr  = [Shops]()
    var NofilteredArr  = [Shops]()
    
    // shps category
    var Restaurant = [Shops]()
    var coffee = [Shops]()
    var pharmacy = [Shops]()
    var supermarket = [Shops]()
    var home = [Shops]()
    var clothes = [Shops]()
    var allShops  = [Shops]()
    var favorite = [Shops]()
    var shopLogo = ""
    
    //
    
    var hello = [String]()
    var shops = [Shops]()
    var qty = ""
    var spinnerView = JTMaterialSpinner()
    var hasOrder : Bool = false
    var finalRate = 4
    
    var selectedIndex = 0
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        
        let fav = NSLocalizedString("Our Favorite", comment: "")
        let Cafes = NSLocalizedString("cafes", comment: "")
        let Restaurants = NSLocalizedString("Restaurants", comment: "")
        let Pharmacy = NSLocalizedString("Pharmacy", comment: "")
        let Supermarkets = NSLocalizedString("Super Markets", comment: "")
        let Home = NSLocalizedString("Home", comment: "")
        let Clothes = NSLocalizedString("Clothes", comment: "")

        

        // Pinterest Menue
        let w = view.frame.width
        
        
        let s = PinterestSegment(frame: CGRect(x: 20, y: 80, width: w - 40, height: 44), titles: ["المتميزة" , "كافيهات", "مطاعم", "صيدليات","أسواق", "المنزل ", "كماليات"])
        
        
        
        
        
        s.style.titleFont = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(rawValue: 7))
        view.addSubview(s)
        s.setSelectIndex(index: 0)
        s.valueChange = { index in
            switch index {
            case 0 :
                print("im the first")
                self.selectedIndex = 0
                self.tableView.reloadData()
            case 1 :
                self.selectedIndex = 1
                self.tableView.reloadData()
            case 2 :
                self.selectedIndex = 2
                self.tableView.reloadData()
            case 3 :
                self.selectedIndex = 3
                self.tableView.reloadData()
            case 4 :
                self.selectedIndex = 4
                self.tableView.reloadData()
            case 5:
                self.selectedIndex = 5
                self.tableView.reloadData()
            case 6 :
                self.selectedIndex = 6
                self.tableView.reloadData()
            
            default:
                self.selectedIndex = 0
                self.tableView.reloadData()

            }
            
          
        }
        // date
        getData ()
        
        
        
      
        // banner
        self.automaticallyAdjustsScrollViewInsets = false

        
        self.navigationController?.setNavigationBarHidden(true, animated: true)

        GetStatus ()
        // spinner
        self.view.addSubview(spinnerView)
        spinnerView.frame = CGRect(x: (375.0 - 50.0) / 2.0, y: 300, width: 50, height: 50)
        spinnerView.circleLayer.lineWidth = 2.0
        spinnerView.circleLayer.strokeColor = UIColor.gray.cgColor
        spinnerView.beginRefreshing()
        spinnerView.animationDuration = 2.5
        
//        self.navigationBarAnimator.setup(scrollView : self.tableView , navBar : self.navBar)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        //        animateTable()
        view.animateRandom()
        getNumber ()
    }
    
    
    
    // MARK: - Table view data source
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        switch selectedIndex {
        case 0:
            print("im 1 in  numbers of rin sections ")

            return  favorite.count

        case 1:
            return self.coffee.count
        case 2:
            return self.Restaurant.count
        case 3:
            return self.pharmacy.count
        case 4:
            return self.supermarket.count
        case 5:
            return self.home.count
        case 6:
            return self.clothes.count
     
        default:
            return   shops.count
        }
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        switch selectedIndex {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ShopTableViewCell
            let entry = favorite[indexPath.row]
            cell.shopImage.hnk_setImage(from: URL(string: entry.Logo))
            cell.shopName.text = entry.shopname
            cell.star.rating = Double(entry.rate)
            cell.time.text = entry.time
            cell.backgroundColor = UIColor(white: 1 , alpha : 0.5)
            return cell
            
        case 1 :
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ShopTableViewCell
            let entry = coffee[indexPath.row]
            cell.shopImage.hnk_setImage(from: URL(string: entry.Logo))
            cell.shopName.text = entry.shopname
            cell.star.rating = Double(entry.rate)
            cell.time.text = entry.time
            cell.backgroundColor = UIColor(white: 1 , alpha : 0.5)
            return cell
            
        case 2 :
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ShopTableViewCell
            let entry = Restaurant[indexPath.row]
            cell.shopImage.hnk_setImage(from: URL(string: entry.Logo))
            cell.shopName.text = entry.shopname
            cell.star.rating = Double(entry.rate)
            cell.time.text = entry.time
            cell.backgroundColor = UIColor(white: 1 , alpha : 0.5)
            return cell
            
        case 3 :
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ShopTableViewCell
            let entry = pharmacy[indexPath.row]
            cell.shopImage.hnk_setImage(from: URL(string: entry.Logo))
            cell.shopName.text = entry.shopname
            cell.star.rating = Double(entry.rate)
            cell.time.text = entry.time
            cell.backgroundColor = UIColor(white: 1 , alpha : 0.5)
            return cell
        case 4 :
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ShopTableViewCell
            let entry = supermarket[indexPath.row]
            cell.shopImage.hnk_setImage(from: URL(string: entry.Logo))
            cell.shopName.text = entry.shopname
            cell.star.rating = Double(entry.rate)
            cell.time.text = entry.time
            cell.backgroundColor = UIColor(white: 1 , alpha : 0.5)
            return cell
        case 5 :
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ShopTableViewCell
            let entry = home[indexPath.row]
            cell.shopImage.hnk_setImage(from: URL(string: entry.Logo))
            cell.shopName.text = entry.shopname
            cell.star.rating = Double(entry.rate)
            cell.time.text = entry.time
            cell.backgroundColor = UIColor(white: 1 , alpha : 0.5)
            return cell
        case 6 :
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ShopTableViewCell
            let entry = clothes[indexPath.row]
            cell.shopImage.hnk_setImage(from: URL(string: entry.Logo))
            cell.shopName.text = entry.shopname
            cell.star.rating = Double(entry.rate)
            cell.time.text = entry.time
            cell.backgroundColor = UIColor(white: 1 , alpha : 0.5)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ShopTableViewCell
            let entry = shops[indexPath.row]
            cell.shopImage.hnk_setImage(from: URL(string: entry.Logo))
            cell.shopName.text = entry.shopname
            cell.star.rating = Double(entry.rate)
            cell.time.text = entry.time
            cell.backgroundColor = UIColor(white: 1 , alpha : 0.5)
            return cell
        }
        }
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if let visibleRows = tableView.indexPathsForVisibleRows , let lastRows = visibleRows.last?.row , let lastSection = visibleRows.map({$0.section}).last  {
            
            if indexPath.row != lastRows && indexPath.section != lastSection {
                print("finished loading now")
            }
        }
    }
    
        func animateTable() {
        
        self.tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 5, y: tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animate(withDuration: 0.0, delay: 0.00 * Double(index), usingSpringWithDamping: 9.0, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            
            index += 1
        }
    }
    
    
    // get table data 
    
    func getData (){
                let urlStr = "http://jaeeapp.com/api/client/main"
        let url = URL(string: urlStr)
        
        let headers: HTTPHeaders = [
            "Authorization": "Basic YXBpdXNlcjpBcGlBdXRoUGFzczIwMTchQCM="
        ]
                Alamofire.request(url!, method: .get ,encoding: URLEncoding.default, headers: headers).responseJSON { response   in
                    
                    if response.error != nil {
                        print("damn it happened")
                        let rect = CGRect(x: 0,
                                          y: 0,
                                          width: self.tableView.bounds.size.width,
                                          height: self.tableView.bounds.size.height)
                        let noDataLabel: UILabel = UILabel(frame: rect)
                        
                        noDataLabel.text = "نأسف .. التطبيق تحت التطوير حالياً , الرجاء الإنتظار "
                        noDataLabel.textColor = UIColor.blue
                        noDataLabel.textAlignment = NSTextAlignment.center
                        self.tableView.backgroundView = noDataLabel
                        self.tableView.separatorStyle = .none
                        self.spinnerView.endRefreshing()

                        return
                    }
            
                 if let value : AnyObject = response.result.value as AnyObject {
                
                let shops = JSON(value)
                for (key,subJson):(String, JSON) in  shops["families"] {
                    print(subJson)

                    if subJson["disable"] == "0" {
                        var time = ""
                        var rate = 0
                        let shopName = subJson["name"].stringValue
                        if subJson["time"].stringValue == nil {
                            time = "12pm-11pm"
                        }
                            time = subJson["time"].stringValue
                        
                        if subJson["rate"].stringValue == nil {
                            rate = 1
                        }
                            rate = subJson["rate"].intValue
                        
                        // perform search for stars
                        self.performSereach(shopName: shopName)
                        let logo = subJson["logo"].stringValue
                        let logoString = "http://jaeeapp.com/upload/img/\(logo)"
                        self.shopLogo = logoString
                        let designImage = subJson["design"].stringValue
                        let desgin = "http://jaeeapp.com/upload/img/\(designImage)"
                        let familiy_id = subJson["id"].stringValue
                        let cat = subJson["cat"].stringValue
                        let info = Shops(shopname: shopName, Logo: logoString, family_id: familiy_id , design : designImage , rate : rate, time : time , cat : cat )
                        self.shops.append(info)
                        self.filteredArr = self.shops.filter { $0.design != nil }
                        self.NofilteredArr =  self.shops.filter { $0.design == nil }
                        self.allShops = self.NofilteredArr + self.filteredArr
                        ""
                        self.favorite = self.shops.filter { $0.cat == "favorite" }
                        self.coffee = self.shops.filter { $0.cat == "coffee" }
                        self.Restaurant = self.shops.filter { $0.cat == "Restaurant" }
                        self.pharmacy = self.shops.filter { $0.cat == "Pharmacy" }
                        self.supermarket = self.shops.filter { $0.cat == "Supermarket" }
                        self.home = self.shops.filter { $0.cat == "Home" }
                        self.clothes = self.shops.filter { $0.cat == "Clothes" }
                    } 
                    
                    DispatchQueue.main.async {
                        
                        self.spinnerView.endRefreshing()
                        
                        self.tableView.reloadData()
                        
                    }
                    
                }
                
                
                
            }
             
            
        }
        
        
        
        
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        switch selectedIndex {
        case 0  :
            let meal1 =  favorite[indexPath.row]
            guard (favorite.count) > indexPath.row else {
                print("Index out of range")
                return
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var viewController = storyboard.instantiateViewController(withIdentifier: "viewControllerIdentifer") as! MealsDetailsController
            viewController.passedValue = (meal1.familiy_id)
            viewController.shopLogo = (meal1.Logo)

            viewController.name = (meal1.shopname)
            print("\(meal1.familiy_id) im the search ")
            view.animateRandom()
            self.present(viewController, animated: true , completion: nil)
            
        case 1 :
            let meal1 =  coffee[indexPath.row]
            
            guard (coffee.count) > indexPath.row else {
                print("Index out of range")
                return
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var viewController = storyboard.instantiateViewController(withIdentifier: "viewControllerIdentifer") as! MealsDetailsController
            viewController.passedValue = (meal1.familiy_id)
            viewController.name = (meal1.shopname)
            viewController.shopLogo = (meal1.Logo)

            print("\(meal1.familiy_id) im the search ")
            view.animateRandom()
            self.present(viewController, animated: true , completion: nil)
            
        case 2 :
            let meal1 =  Restaurant[indexPath.row]
            
            
            guard (Restaurant.count) > indexPath.row else {
                print("Index out of range")
                return
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var viewController = storyboard.instantiateViewController(withIdentifier: "viewControllerIdentifer") as! MealsDetailsController
            viewController.passedValue = (meal1.familiy_id)
            viewController.name = (meal1.shopname)
            viewController.shopLogo = (meal1.Logo)

            print("\(meal1.familiy_id) im the search ")
            view.animateRandom()
            self.present(viewController, animated: true , completion: nil)
        case 3 :
            let meal1 =  pharmacy[indexPath.row]
            guard (pharmacy.count) > indexPath.row else {
                print("Index out of range")
                return
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var viewController = storyboard.instantiateViewController(withIdentifier: "viewControllerIdentifer") as! MealsDetailsController
            viewController.passedValue = (meal1.familiy_id)
            viewController.name = (meal1.shopname)
            viewController.shopLogo = (meal1.Logo)

            print("\(meal1.familiy_id) im the search ")
            view.animateRandom()
            self.present(viewController, animated: true , completion: nil)
            
        case 4 :
            let meal1 =  supermarket[indexPath.row]
            guard (supermarket.count) > indexPath.row else {
                print("Index out of range")
                return
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var viewController = storyboard.instantiateViewController(withIdentifier: "viewControllerIdentifer") as! MealsDetailsController
            viewController.passedValue = (meal1.familiy_id)
            viewController.name = (meal1.shopname)
            viewController.shopLogo = (meal1.Logo)

            print("\(meal1.familiy_id) im the search ")
            view.animateRandom()
            self.present(viewController, animated: true , completion: nil)
        case  5 :
            let meal1 =  home[indexPath.row]
            guard (home.count) > indexPath.row else {
                print("Index out of range")
                return
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var viewController = storyboard.instantiateViewController(withIdentifier: "viewControllerIdentifer") as! MealsDetailsController
            viewController.passedValue = (meal1.familiy_id)
            viewController.shopLogo = (meal1.Logo)

            viewController.name = (meal1.shopname)
            print("\(meal1.familiy_id) im the search ")
            view.animateRandom()
            self.present(viewController, animated: true , completion: nil)
        case 6 :
            let meal1 =  clothes[indexPath.row]
            guard (clothes.count) > indexPath.row else {
                print("Index out of range")
                return
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var viewController = storyboard.instantiateViewController(withIdentifier: "viewControllerIdentifer") as! MealsDetailsController
            viewController.passedValue = (meal1.familiy_id)
            viewController.name = (meal1.shopname)
            viewController.shopLogo = (meal1.Logo)

            print("\(meal1.familiy_id) im the search ")
            view.animateRandom()
            self.present(viewController, animated: true , completion: nil)
        default:
            let meal1 =  shops[indexPath.row]
            guard (shops.count) > indexPath.row else {
                print("Index out of range")
                return
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var viewController = storyboard.instantiateViewController(withIdentifier: "viewControllerIdentifer") as! MealsDetailsController
            viewController.passedValue = (meal1.familiy_id)
            viewController.name = (meal1.shopname)
            viewController.shopLogo = (meal1.Logo)

            print("\(meal1.familiy_id) im the search ")
            view.animateRandom()
            self.present(viewController, animated: true , completion: nil)
        }
       
    }
    

    @IBAction func basket(_ sender: UITapGestureRecognizer) {
        
        // add or nil
        if UserDataSingleton.sharedDataContainer.is_guest == "guest" || UserDataSingleton.sharedDataContainer.is_guest == nil {
            UserDataSingleton.sharedDataContainer.previous = nil
            
            performSegue(withIdentifier: "login", sender: self)
        }
        
        if hasOrder == false {
            performSegue(withIdentifier: "basket", sender: self)
        }
        if hasOrder == true {
            self.performSegue(withIdentifier: "orders", sender: self)
            
        }
        
    }
    func getNumber () {
        
        
        
        if UserDataSingleton.sharedDataContainer.is_guest == "user" {
            
            let param = ["user_id":"\(UserDataSingleton.sharedDataContainer.user_id!)",]
            let urlStr = "http://jaeeapp.com/api/client/cart_meals"
            let url = URL(string: urlStr)
            
            
            let user = "apiuser"
            let password = "ApiAuthPass2017"
            
            
            
            var headers: HTTPHeaders = [
                "Authorization": "Basic YXBpdXNlcjpBcGlBdXRoUGFzczIwMTchQCM="
            ]
            
            var tempOrdersList = [String]()
            
            Alamofire.request(url!, method: .post, parameters: param,encoding: URLEncoding.default, headers: headers).responseJSON { response in
                if let value: AnyObject = response.result.value as AnyObject? {
                    //Handle the results as JSON
                    
                    
                    let usertoken = JSON(value)
                    
                    
                    
                    for (key,subJson):(String, JSON) in  usertoken["meals"] {
                        self.qty = subJson["qty"].stringValue
                        tempOrdersList.append(self.qty)
                    }
                    
                }
                DispatchQueue.main.async {
                    self.hello =  tempOrdersList
                    let intArray = tempOrdersList.map { Int($0)!}
                    if intArray == [] {
                        TIPBadgeManager.sharedInstance.addBadgeSuperview(name: "someViewName", view: self.image
                        )
                        
                        TIPBadgeManager.sharedInstance.setAllBadgeValues(value: 0 , appIconBadge: true)
                    }
                    
                    let arraySum = intArray.reduce(0) { $0 + $1 }
                    TIPBadgeManager.sharedInstance.addBadgeSuperview(name: "someViewName", view: self.image
                    )
                    
                    TIPBadgeManager.sharedInstance.setAllBadgeValues(value: arraySum, appIconBadge: true)
                    
                }
                
                
                
            }
            
            
        } else {
            
            // set it to 0
            
            
        }
        
    }
    
    
    func GetStatus ()  {
        
        if UserDataSingleton.sharedDataContainer.user_id != nil {
            let urlStr = "http://jaeeapp.com/api/client/current_order"
            let url = URL(string: urlStr)
            let para = ["user_id": "\(UserDataSingleton.sharedDataContainer.user_id!)"]
            let user = "apiuser"
            let password = "ApiAuthPass2017!@#"
            var headers: HTTPHeaders = [
                "Authorization": "Basic YXBpdXNlcjpBcGlBdXRoUGFzczIwMTchQCM="
            ]
            
            
            Alamofire.request(url!, method: .post, parameters: para,encoding: URLEncoding.default, headers: headers).responseJSON { response in
                
                
                if let value : AnyObject = response.result.value as AnyObject {
                    
                    let data = JSON(value)
                    
                    if data["orders"].arrayValue == [] {
                     
                        self.hasOrder = false
                    }
                    if data["orders"].arrayValue != [] {
                        
                        self.hasOrder = true
                        TIPBadgeManager.sharedInstance.addBadgeSuperview(name: "someViewName", view: self.image
                        )
                        
                        TIPBadgeManager.sharedInstance.setAllBadgeValues(value: 1 , appIconBadge: true)
                    }
                    
                }
            }
        } else {
            TIPBadgeManager.sharedInstance.addBadgeSuperview(name: "someViewName", view: self.image
            )
            
            TIPBadgeManager.sharedInstance.setAllBadgeValues(value: 0 , appIconBadge: true)
        }
        
    }
    
    @IBAction func setting(_ sender: UITapGestureRecognizer) {
        
        
        // add or nil
        if UserDataSingleton.sharedDataContainer.is_guest == "guest" || UserDataSingleton.sharedDataContainer.is_guest == nil {
            UserDataSingleton.sharedDataContainer.previous = nil
            
            performSegue(withIdentifier: "login", sender: self)
        } else {
            
            performSegue(withIdentifier: "setting", sender: self)
            
        }
        
        
    }
    
   
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        auxiliar = shops.filter { $0.shopname.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil}
        if searchText == "" || searchBar.text == nil {
            if self.searchActive {
            self.searchActive = false
            print("search nill and ")
            }
        }
        tableView.reloadData()
    }
   
    
    func performSereach(shopName : String ) {
        let formattedString = shopName.replacingOccurrences(of: " ", with: "+")
        
        let urlStr = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(formattedString)+in+Riyadh&key=AIzaSyDPC7dwE6f2uJ1aXiPfIJJFjaHm5_yLxVw"
        
     
        Alamofire.request(urlStr).responseJSON { response in
            if let value : AnyObject = response.result.value as AnyObject {
                
                let data = JSON(value)
                for (key,subJson):(String, JSON) in  data["results"] {
                    
                    
                }
                
            } else {
            }
            
            
        }
        
        
        
    }
   

    @IBAction func searchTapped(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "toSearch", sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSearch" {

            if let viewController = segue.destination as? SearchShopViewController {
                print("im here agian then ")

                if(shops != nil){
                    print("im here done ")

                    viewController.dataArray = (shops as AnyObject) as! [Shops]
                }
            }
        } else {
            print("segue failed")
        }
    }
    
}



extension String {
    func localized(lang:String) ->String {
        
        let path = Bundle.main.path(forResource: lang, ofType: "Main.strings")
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }}









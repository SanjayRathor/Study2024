//
//  MealsDetailsController.swift
//  Jaee2
//
//  Created by Abdulaziz  Almohsen on 6/28/17.
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
import VegaScrollFlowLayout
import ViewAnimator
import ParallaxHeader


class MealsDetailsController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var BarTop: UIView!
  
    @IBOutlet weak var image: UIImageView!
   
    @IBOutlet weak var nameOfShop: UILabel!

    @IBOutlet weak var addButton: UIButton!
    weak var headerImageView: UIView?


    var hello = [String]()
    var qty = ""
    var passedValue = ""
    var name = ""
    var spinnerView = JTMaterialSpinner()

    var hasOrder : Bool = false
    var shopLogo = ""



    var meals = [Meals]()
   
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setupParallaxHeader()

        addButton.titleLabel?.adjustsFontSizeToFitWidth = true

        // spinner
        
        self.view.addSubview(spinnerView)
        spinnerView.frame = CGRect(x: (375.0 - 50.0) / 2.0, y: 300, width: 50, height: 50)
        spinnerView.circleLayer.lineWidth = 2.0
        spinnerView.circleLayer.strokeColor = UIColor.orange.cgColor
        spinnerView.beginRefreshing()
        spinnerView.animationDuration = 2.5
        DataManager.shared.firstVC = self
        getMeals()
        GetStatus ()
        collectionView.delegate = self
        collectionView.dataSource = self
        nameOfShop.text = name
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        view.animateRandom()
        
        
        
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Meals")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
        getNumber ()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
      

     
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if meals.count > 0 {
            self.collectionView.backgroundView = nil
            return meals.count
        }
        let rect = CGRect(x: 0,
                          y: 0,
                          width: self.collectionView.bounds.size.width,
                          height: self.collectionView.bounds.size.height)
        let noDataLabel: UILabel = UILabel(frame: rect)
        
        noDataLabel.text = "تقدر تطلب اي شي من \(nameOfShop.text!)"
        noDataLabel.textColor = UIColor.black
        noDataLabel.textAlignment = NSTextAlignment.center
        self.collectionView.backgroundView = noDataLabel
        
        return 0

    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mealsCell", for: indexPath) as! MealCollectionViewCell

        let entry = meals[indexPath.row]
        
        cell.mealName.text = entry.meal_name
        cell.mealPrice.text = "\(entry.price) ريال"
        
        cell.mealImage.hnk_setImage(from: URL(string: entry.Logo))
        return cell
        
    }
    
   
    
    
    
   func  getMeals () {
    
    let urlStr = "http://jaeeapp.com/api/client/family_meals"
    let url = URL(string: urlStr)
    
    let para = ["family_id": "\(passedValue)"]
    let user = "apiuser"
    let password = "ApiAuthPass2017!@#"
    
    
    
    var headers: HTTPHeaders = [
    "Authorization": "Basic YXBpdXNlcjpBcGlBdXRoUGFzczIwMTchQCM="
    ]
    
    
    Alamofire.request(url!, method: .post, parameters: para,encoding: URLEncoding.default, headers: headers).responseJSON { response in
       print(response)
        print("response is above")
    
    if let value : AnyObject = response.result.value as AnyObject {
    
    let meals = JSON(value)
        for (key,subJson):(String, JSON) in  meals["meals"] {
            if subJson["disable"].string == "0" {
            let name = subJson["name"].stringValue
            let price = subJson["price"].stringValue
            let logo = subJson["image"].stringValue
            let id = subJson["id"].stringValue
           let logoString = "http://jaeeapp.com/upload/img/\(logo)"

            let info = Meals(meal_id: id, Logo: logoString, meal_name: name, price: price)
 
            self.meals.append(info)
         
            
            
        }
           
            
        }
        
        DispatchQueue.main.async{
            self.collectionView.reloadData()
            self.spinnerView.endRefreshing()
         

        }
    
    } else {
    
    print("sorry data from api has error in bringing shops")
    }
    
    
    }
    
    
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let meal =  meals[indexPath.row]
        
        
        guard meals.count > indexPath.row else {
            print("Index out of range")
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var viewController = storyboard.instantiateViewController(withIdentifier: "Product") as! ProductViewController
        
        viewController.passedValue = meal.meal_id
        view.animateRandom()
        
        self.present(viewController, animated: true , completion: nil)
        
        
    }
        @IBAction func basketTapped(_ sender: UITapGestureRecognizer) {
        
        print("yes guest")
        
        
        
        // add or nil
        if UserDataSingleton.sharedDataContainer.is_guest == "guest" || UserDataSingleton.sharedDataContainer.is_guest == nil {
            UserDataSingleton.sharedDataContainer.previous = nil
            
            performSegue(withIdentifier: "login", sender: self)
        }
        
        if hasOrder == false {
            performSegue(withIdentifier: "basket", sender: self)
        }
        if hasOrder == true {
            print("segue to orders")
            self.performSegue(withIdentifier: "orders", sender: self)
            
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
                
                if data["orders"].array! == [] {
                    
                        self.hasOrder = false
                    print("array empty")
                }
                
                    if data["orders"].array! != [] {
                        print("array NOT empty")
                        

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
                        print("its zero")
                        TIPBadgeManager.sharedInstance.addBadgeSuperview(name: "someViewName", view: self.image
                        )
                        
                        TIPBadgeManager.sharedInstance.setAllBadgeValues(value: 0 , appIconBadge: true)
                    } else {
                    
                    let arraySum = intArray.reduce(0) { $0 + $1 }
                    TIPBadgeManager.sharedInstance.addBadgeSuperview(name: "someViewName", view: self.image
                    )
                    
                    TIPBadgeManager.sharedInstance.setAllBadgeValues(value: arraySum, appIconBadge: true)
                    
                    }
                    
                }
                
                
                
            }
            
            
        } else {
            
            // set it to 0
            
            
        }
        
    }
    func emptyItem()  {
        
        let title = UILabel()
        title.text = "Some Sentence"
        title.numberOfLines = 0
        title.textAlignment = .center
        title.sizeToFit()
        title.center = self.view.center
        title.center.x = self.view.center.x
        title.center.y = self.view.center.y
        
        
        self.view.addSubview(title)
    }
    
    // add costumed item
    
    @IBAction func addPressed(_ sender: Any) {
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    var viewController = storyboard.instantiateViewController(withIdentifier: "CustomedID") as! AddItemViewController
        viewController.passedValue = (passedValue)
        self.present(viewController, animated: true , completion: nil)

    }
    private func setupParallaxHeader() {
        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFill
        
        Alamofire.request(shopLogo).response { response in
            if let data = response.data {
                let image = UIImage(data: data)
               imageView.image = image
            } else {
                print("Data is nil. I don't know what to do :(")
            }
        }

        headerImageView = imageView

        collectionView.parallaxHeader.view = imageView
        collectionView.parallaxHeader.height = 200
        collectionView.parallaxHeader.minimumHeight = 0
        collectionView.parallaxHeader.mode = .topFill
        collectionView.parallaxHeader.parallaxHeaderDidScrollHandler = { parallaxHeader in
            print(parallaxHeader.progress)
        }
    }

}


//
//  ProductViewController.swift
//  Jaee2
//
//  Created by Abdulaziz  Almohsen on 6/29/17.
//  Copyright © 2017 Jaee. All rights reserved.
//

import UIKit
import Haneke
import Alamofire
import Foundation
import SwiftyJSON
import HMScrollNavigationBar
import HMScrollNavigationBar
import DropDown

class ProductViewController: UIViewController   {

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var qytLab: UILabel!
    @IBOutlet weak var priceLab: UILabel!
    @IBOutlet weak var itemDesc: UITextView!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var unite: UILabel!
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var sizebtn: UIButton!
    
    
    
    public var minimumVelocityToHide = 1500 as CGFloat
    public var minimumScreenRatioToHide = 0.5 as CGFloat
    public var animationDuration = 0.2 as TimeInterval

  
    
    var timer = Timer()

    var passedValue = ""
    
    var qty = ""
    var size = ""
    var hasSize = ""
    
    var mSize = ""
    var sSize = ""
    var lSize = ""
    var pickedSize = ""
    var abaiSizes = [String]()

    
    
    
    let Size = DropDown()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        self.view.addGestureRecognizer(panGesture)
        
        qytLab.text = "1"
        qty = qytLab.text!
        
      
        
        if hasSize == "0" {
            if sizebtn.isHidden == true {
            
            sizebtn.isHidden = false
            }
        }
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getDetials()
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "viewing meals")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])


    }
  // new
    
    @IBAction func placeDropdown(_ sender: Any) {
        
        Size.show()

        
  
    }
    
    func setupLanguage (){
        print("sizee")
        print(abaiSizes)
        Size.anchorView = sizebtn
        Size.bottomOffset = CGPoint(x: 0, y: sizebtn.bounds.height)
        // You can also use localizationKeysDataSource instead. Check the docs.
        // switch
        
            Size.dataSource = abaiSizes

        // Action triggered on selection
        Size.selectionAction = { [unowned self] (index, item) in
            self.sizebtn.setTitle(item, for: .normal)
            
            self.getPrice(size: self.Size.selectedItem!, meal_id: self.passedValue)
            
            self.pickedSize = self.Size.selectedItem!
        }
        
    }
    @IBAction func plusTapped(_ sender: Any) {
        
        let new = Int(qty)! + 1
        
        qytLab.text = String(new)
        
        qty = String(new)
    }
    @IBAction func reducedTapped(_ sender: Any) {
        
        if qytLab.text == "1" {
            qytLab.text = "1"
            
            qty = "1"

            
        } else {
        
        let new = Int(qty)! - 1
        
        qytLab.text = String(new)
        
        qty = String(new)
    }
    }
// new
    func getDetials() {
        abaiSizes = []
        
        
        let urlStr = "http://jaeeapp.com/api/client/meal/\(passedValue)"
        let url = URL(string: urlStr)
        let para = ["meal_id": "\(passedValue)"]
        let user = "apiuser"
        let password = "ApiAuthPass2017!@#"
        
        
        
        var headers: HTTPHeaders = [
            "Authorization": "Basic YXBpdXNlcjpBcGlBdXRoUGFzczIwMTchQCM="
        ]
        
        
        Alamofire.request(url!, method: .get, parameters: para,encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
            if let value : AnyObject = response.result.value as AnyObject {
            
            let data = JSON(value)
               print(data)
                let meals = data["meal"]
                if meals["price"].string == "0.00" {
                    self.hasSize = "0"
                    
                }
                
                let name = meals["name"].string
                let price  = meals["price"].string
                let image =  meals["image"].string
                let imaageString = "http://jaeeapp.com/upload/img/\(image!)"
                let time = meals["time"].string
                let description = meals["desc"].string
                let unit = meals["unit"].string
                
                if price == "0.00" {
                    self.hasSize = "0"
                   self.sizebtn.isHidden = false
                    self.pickedSize = "small"
                    let priceLab = meals["price_lbl"].string
                    self.priceLab.text = "\(priceLab!)ريال "
                    if meals["small"].string != "0" {
                        self.sSize = "small"
                        self.abaiSizes.append("S صغير")
                        print("im here ")
                    }
                    if  meals["medium"].string != "0" {
                        self.mSize = "medium"
                        self.abaiSizes.append("M وسط")
                    }
                    if  meals["large"].string != "0" {
                        self.abaiSizes.append("L كبير")
                         ("large is available")
                        self.lSize = "large"
                    }
                            self.setupLanguage ()
                } else {
                    
                    self.priceLab.text = "\(price!) ريال"
                    self.hasSize = "1"
                    self.sizebtn.isHidden = true

                    
                }
                if description == "" {
                    
                    self.itemDesc.isHidden = true
                } else {
                    self.itemDesc.text = description

                    
                }
                self.unite.text = unit
                self.time.text = time
                self.itemName.text = name
                self.itemImage.hnk_setImage(from: URL(string:imaageString))

                


                
                
            } else {
                
                 ("the response from json isnt valid")
            }
            
            
        }
        
        
    }
    
    // MARK :  add button
    @IBAction func addtoCart(_ sender: Any) {
        
        
       if  UserDataSingleton.sharedDataContainer.is_guest == "guest" || UserDataSingleton.sharedDataContainer.is_guest == nil {
        
            self.performSegue(withIdentifier: "login", sender: self)
            UserDataSingleton.sharedDataContainer.previous = passedValue
            return
        }
        
        if self.sizebtn.isHidden == false && Size.selectedItem == nil {
            let alert = UIAlertController(title: "حجم الطلب مطلوب", message: "حدد المقاس الي تبية علشان نضيفة في السلة لك 😁", preferredStyle: .alert)
            let action = UIAlertAction(title: "رجوع", style: .default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
            return
            
        } else {
            
            
            var param = [String:String]()
            
            if pickedSize == "" {
                param = ["meal_id": "\(passedValue)" ,
                    "user_id":"\(UserDataSingleton.sharedDataContainer.user_id!)",
                    "qty":"\(qty)"]
                
            }
            
            if pickedSize != "" {
                param = ["meal_id": "\(passedValue)" ,
                    "user_id":"\(UserDataSingleton.sharedDataContainer.user_id!)",
                    "size":"\(pickedSize)",
                    "qty":"\(qty)"]
                
            }
            
            print("here is the picked size \(pickedSize)")
            // send data to cart
            let urlStr = "http://jaeeapp.com/api/client/meal_add"
            let url = URL(string: urlStr)
            let user = "apiuser"
            let password = "ApiAuthPass2017!@#"
            
            
            var headers: HTTPHeaders = [
                "Authorization": "Basic YXBpdXNlcjpBcGlBdXRoUGFzczIwMTchQCM="
            ]
            
            
            Alamofire.request(url!, method: .post, parameters: param,encoding: URLEncoding.default, headers: headers).responseJSON { response in
                if let value: AnyObject = response.result.value as AnyObject? {
                    
                    print(response)
                    
                    let data = JSON(value)
                    
                     (data)
                    if  data["success"].bool == true {
                         ("added")
                        
                  self.dismiss(animated: true, completion: nil)
                    
                    } else {
                        
                        if data["error"].stringValue == "عفوا، لا يمكنك الطلب من أكثر من متجر في نفس الطلب" {
                            let alert = UIAlertController(title: "اضافة منتج الى السلة", message: "\(UserDataSingleton.sharedDataContainer.username!), مانسمح باضافة منتج من محل ثاني في نفس السلة حقتك ", preferredStyle: .alert)
                            let action = UIAlertAction(title: "ok", style: .default, handler: nil)
                            alert.addAction(action)
                            
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            
                            
                            if data["error"].stringValue == "عفوا، تمت اضافة هذا منتج مسبقا"{
                                let alert = UIAlertController(title: "اضافة منتج الى السلة", message: "عندك نفس هالمنتج في السلة", preferredStyle: .alert)
                                let action = UIAlertAction(title: "رجوع", style: .default, handler: nil)
                                alert.addAction(action)
                                
                                self.present(alert, animated: true, completion: nil)
                            }  else {
                                
                                if data["error"].stringValue == "معليش \(UserDataSingleton.sharedDataContainer.username!)، ماتقدر تقديم اكثر من طلب بنفس الوقت" {
                                    
                                    
                                        let alert = UIAlertController(title: "اضافة منتج الى السلة", message: "عندك طلب جاري توصيلة، اصبر لين يخلص واطلب ثانية 😘", preferredStyle: .alert)
                                        let action = UIAlertAction(title: "رجوع", style: .default, handler: nil)
                                        alert.addAction(action)
                                        
                                        self.present(alert, animated: true, completion: nil)
                                    
                                }
                            }
                        }
                    }
                
            
                } else {
                    
                     ("the response from json isnt valid")
                }
            }
            }
        }
    
    func getPrice ( size : String , meal_id : String) {
        var actualSize = ""
        switch size {
        case "S صغير":
            actualSize = "small"
        case "M وسط":
            actualSize = "medium"
        case "L كبير" :
            actualSize = "large"
        default:
            actualSize = "small"
        }
        let urlStr = "http://jaeeapp.com/api/client/get_meal_size"
        let url = URL(string: urlStr)
        let para = ["meal_id": "\(passedValue)" ,
            "size":"\(actualSize)"
        
        ]
        let user = "apiuser"
        let password = "ApiAuthPass2017!@#"
        
        
        
        var headers: HTTPHeaders = [
            "Authorization": "Basic YXBpdXNlcjpBcGlBdXRoUGFzczIwMTchQCM="
        ]
        
        
        Alamofire.request(url!, method: .post, parameters: para,encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
            if let value : AnyObject = response.result.value as AnyObject {
                
                let data = JSON(value)
                 (data)
                
                if data["price"].string == "0" {
                    
                    // MARK :- Need Windoe the size isnt available
                    let alert = UIAlertController(title: "الحجم غير متوفر", message: "الحجم المحدد غير متوفر حالياً", preferredStyle: .alert)
                    let action = UIAlertAction(title: "ok", style: .default, handler: nil)
                    alert.addAction(action)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                
                    self.priceLab.text = "\(data["price"].string!)ريال"
                    self.pickedSize = actualSize
                    print("the get price picked size \(self.pickedSize)")

                
                }
            }
        
    }
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func onPan(_ panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .began, .changed:
            // If pan started or is ongoing then
            // slide the view to follow the finger
            let translation = panGesture.translation(in: view)
            let y = max(0, translation.y)
            self.slideViewVerticallyTo(y)
            break
        case .ended:
            // If pan ended, decide it we should close or reset the view
            // based on the final position and the speed of the gesture
            let translation = panGesture.translation(in: view)
            let velocity = panGesture.velocity(in: view)
            let closing = (translation.y > self.view.frame.size.height * minimumScreenRatioToHide) ||
                (velocity.y > minimumVelocityToHide)
            
            if closing {
                UIView.animate(withDuration: animationDuration, animations: {
                    // If closing, animate to the bottom of the view
                    self.slideViewVerticallyTo(self.view.frame.size.height)
                }, completion: { (isCompleted) in
                    if isCompleted {
                        // Dismiss the view when it dissapeared
                        self.dismiss(animated: false, completion: nil)
                    }
                })
            } else {
                // If not closing, reset the view to the top
                UIView.animate(withDuration: animationDuration, animations: {
                    self.slideViewVerticallyTo(0)
                })
            }
            break
        default:
            // If gesture state is undefined, reset the view to the top
            UIView.animate(withDuration: animationDuration, animations: {
                self.slideViewVerticallyTo(0)
            })
            break
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen;
        self.modalTransitionStyle = .coverVertical;
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.modalPresentationStyle = .overFullScreen;
        self.modalTransitionStyle = .coverVertical;
    }
    func slideViewVerticallyTo(_ y: CGFloat) {
        self.view.frame.origin = CGPoint(x: 0, y: y)
    }
    
    }



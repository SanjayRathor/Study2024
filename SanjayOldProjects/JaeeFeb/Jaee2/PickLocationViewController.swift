//
//  PickLocationViewController.swift
//  Jaee2
//
//  Created by Abdulaziz  Almohsen on 7/3/17.
//  Copyright © 2017 Jaee. All rights reserved.
//

import MapKit
import CoreLocation
import Alamofire
import SwiftyJSON
import DropDown
import Permission
import NotificationBannerSwift
import LocationPickerViewController
import PercentEncoder
import JTMaterialSpinner


class PickLocationViewController: UIViewController   {
    
    
    // variables
  var lat = ""
  var lng = ""
    var currentcity = ""
    var timeselected = "الآن"
    var totalAPI = ""
    var subtotalAPI = ""
    var delivery_costAPI = ""
    
    var inRiyadh = true
    var isStore = false
    var familyLat = 0.0
    var familyLng = 0.0
    var clientLat = ""
    var clientLng = ""
    var coordinate: [CLLocation] = [CLLocation]()

    var coordinates: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()

    // outlets
    @IBOutlet weak var nextbtn: UIButton!
    @IBOutlet weak var codeText: UITextField!
    
    
    @IBOutlet weak var checkBtn: UIButton!
    
    @IBOutlet weak var phoneLab: UILabel!
    
    @IBOutlet weak var addressLab: UILabel!
    
    @IBOutlet weak var subtotal: UILabel!
    
    @IBOutlet weak var deliveryFee: UILabel!
    
    @IBOutlet weak var total: UILabel!

    
    @IBOutlet weak var phone: UILabel!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var time: UIButton!
    
    
    var spinnerView = JTMaterialSpinner()

    //dropdwon
    let timeDrop = DropDown()
    
    let banner = NotificationBanner(title: "تمت العملية بنجاح", subtitle: "تم تحديث موقعك", style: .success)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        self.view.addSubview(spinnerView)
        spinnerView.frame = CGRect(x: (375.0 - 50.0) / 2.0, y: 300, width: 50, height: 50)
        spinnerView.circleLayer.lineWidth = 2.0
        spinnerView.circleLayer.strokeColor = UIColor.gray.cgColor
        spinnerView.animationDuration = 2.5
        //dropdown
      
        setupTime ()

        
        // user info
        name.text = UserDataSingleton.sharedDataContainer.username
        phone.text = UserDataSingleton.sharedDataContainer.user_phone
        
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getOrderDetails ()
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "pick Location")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
        
    }
        
    
    
    
    
   
    @IBAction func nextTapped(_ sender: UIButton) {
       print("hi there")
       
            if UserDataSingleton.sharedDataContainer.username == nil {
                
                let alert = UIAlertController(title: "نبي بس اسمك", message: "خانه الآسم عندك فاضية.اضغط على زر ‘ تغير’ وادخل اسمك", preferredStyle: .alert)
                let action = UIAlertAction(title: "رجوع", style: .default, handler: nil)
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            

            let param = ["user_id":"\(UserDataSingleton.sharedDataContainer.user_id!)",
                "delivery_cost":"\(delivery_costAPI)",
                "subtotal":"\(subtotalAPI)",
                "total":"\(totalAPI)",
                "time":"\(self.timeselected)"
            ]
        print(param)
            let urlStr = "http://jaeeapp.com/api/client/order"
            let url = URL(string: urlStr)
            
            
            let user = "apiuser"
            let password = "ApiAuthPass2017"
            
            
            
            var headers: HTTPHeaders = [
                "Authorization": "Basic YXBpdXNlcjpBcGlBdXRoUGFzczIwMTchQCM="
            ]
            
            
            Alamofire.request(url!, method: .post, parameters: param,encoding: URLEncoding.default, headers: headers).responseJSON { response in
                print(response)

                if let value: AnyObject = response.result.value as AnyObject? {
                    
                    let data = JSON(value)
                    
                 
                    if data["success"].bool == true {
                        
                        self.performSegue(withIdentifier: "submitted", sender: self)
                        UserDataSingleton.sharedDataContainer.notificationOn = "on"
                        UserDataSingleton.sharedDataContainer.notificationOn = "on"

                    }
                }
            }

            
            
          
       
        
        
    }
    
    func getOrderDetails () {
        let param = ["user_id":"\(UserDataSingleton.sharedDataContainer.user_id!)",]
        let urlStr = "http://jaeeapp.com/api/client/cart_details"
        let url = URL(string: urlStr)
        
        let user = "apiuser"
        let password = "ApiAuthPass2017"
        
        
        
        var headers: HTTPHeaders = [
            "Authorization": "Basic YXBpdXNlcjpBcGlBdXRoUGFzczIwMTchQCM="
        ]
        
        
        Alamofire.request(url!, method: .post, parameters: param,encoding: URLEncoding.default, headers: headers).responseJSON { response in
            if let value: AnyObject = response.result.value as AnyObject? {
                //Handle the results as JSON
                
                let order = JSON(value)
                print("order is here")
                print(order)
                let data = order["order"]

                let meals = data["meals"]
                print("meas is here")
                print(meals)
                for (key,subJson):(String, JSON) in  meals {
                    let familyName = subJson["family_name"].stringValue
                    let type = subJson["family_type"].stringValue
                    let familyLat = subJson["family_lat"].stringValue
                    let familyLng = subJson["family_lng"].stringValue
                    
                    self.familyLat = Double(familyLat)!
                    self.familyLng = Double(familyLng)!
                    
                    switch type {
                        
                    case  "store" :
                        self.isStore = true
                        self.performSearch(lat: self.familyLat, long: self.familyLng, name: familyName)
                    case "family":
                        print("family")
                        self.GetCoordinate(longFamily: Double(familyLng)!, latFamily: Double(familyLat)!)
                     default :
                        print("default")
                    }
                    
                   

                }

                self.subtotalAPI = data["subtotal"].stringValue
                self.totalAPI = data["total"].stringValue
                self.delivery_costAPI = data["delivery_cost"].stringValue
                
                self.subtotal.text = "\(self.subtotalAPI)ريال"
                self.total.text =  "\(self.totalAPI)ريال"
                self.deliveryFee.text = "\(self.delivery_costAPI)ريال"
                
                
        
        }
        
    }
    
        
    }
    
    @IBAction func back(_ sender: UITapGestureRecognizer) {
        
        self.performSegue(withIdentifier: "tocart", sender: self)
    
    }
    
    func setupTime (){
        
        timeDrop.anchorView = time
        timeDrop.bottomOffset = CGPoint(x: 0, y: time.bounds.height)
        // You can also use localizationKeysDataSource instead. Check the docs.
        timeDrop.dataSource = ["الآن"
            , "بعد الظهر"
            , "بعد العصر"
            , "بعد المغرب"
            , "بعد العشاء"
            ]
        
        // Action triggered on selection
        timeDrop.selectionAction = { [unowned self] (index, item) in
            self.time.setTitle(item, for: .normal)
            
        
            
            self.timeselected = self.timeDrop.selectedItem!
        }
        
    }
    
    @IBAction func timeTapped(_ sender: Any) {
        timeDrop.show()
    }
    
    func performSearch( lat : Double , long : Double, name : String) {

        clientLat = UserDataSingleton.sharedDataContainer.lat!
        clientLng = UserDataSingleton.sharedDataContainer.lng!
        let url =  "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(long)&rankby=distance&name=\(name)&language=ar&key=AIzaSyBGzgcPuVg00MNdL8MokaSPRZ_hrg8okGQ"

        let urlStr = PercentEncoding.encodeURI.evaluate(string: url)




        Alamofire.request(urlStr).responseJSON
            { response in
                if let value: AnyObject = response.result.value as AnyObject? {
                    //Handle the results as JSON

                    let data = JSON(value)

                    for (key,subJson):(String, JSON) in  data["results"] {

                        let array = subJson["geometry"]["location"].dictionaryValue
                        for (key,subJson):(String, JSON) in array {
                            // Do something you want

                            let latitude = array["lat"]?.doubleValue
                            let longitude = array["lng"]?.doubleValue
                            let location = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                            self.coordinates.append(location)

                        }
                    }

                    let pointToCompare = CLLocation(latitude: Double(self.clientLat)!, longitude: Double(self.clientLng)!)
                    let  storedCorrdinates =  self.coordinates.map({CLLocation(latitude: $0.latitude, longitude: $0.longitude)}).sorted(by: {
                        $0.distance(from: pointToCompare) < $1.distance(from: pointToCompare)
                    })

                    self.coordinate = storedCorrdinates
                    let distanceInMeters = pointToCompare.distance(from: CLLocation(latitude: self.coordinate[0].coordinate.latitude, longitude: self.coordinate[0].coordinate.longitude))

                    let floatDistance = Float(distanceInMeters)
                    let killo = floatDistance * 0.001
                    print(killo)
                    
                    if killo > 15 {
                        let alertController = UIAlertController(title: "موقع الطلب شوي بعيد عليك لكن بنحاول نجيبه لك باسرع وقت 😎", message: "", preferredStyle: .alert)
                        let backToSignIn = UIAlertAction(title: "استكمال الطلب", style: .cancel, handler: nil)
                        alertController.addAction(backToSignIn)
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                    

        }
    }

 
    }
    func GetCoordinate (longFamily: Double , latFamily : Double  ){
        
        
        clientLat = UserDataSingleton.sharedDataContainer.lat!
        clientLng = UserDataSingleton.sharedDataContainer.lng!
        
        let pointToCompare = CLLocation(latitude: Double(clientLat)!, longitude: Double(clientLng)!)
        let distanceInMeters = pointToCompare.distance(from: CLLocation(latitude: latFamily, longitude: longFamily))
        
        let floatDistance = Float(distanceInMeters)
        let killo = floatDistance * 0.001
        
        print(killo)
        
        if killo > 15 {
            let alertController = UIAlertController(title: "موقع الطلب شوي بعيد عليك لكن بنحاول نجيبه لك باسرع وقت 😎", message: "", preferredStyle: .alert)
            let backToSignIn = UIAlertAction(title: "استكمال الطلب", style: .cancel, handler: nil)
            alertController.addAction(backToSignIn)
            
            self.present(alertController, animated: true, completion: nil)
        }
        //
    }
    
    
    @IBAction func checkTapped(_ sender: Any) {
        if  codeText.text == "" || codeText.text == nil  {
            // alert no code entered
            let alertController = UIAlertController(title: "خانة الكود فارغ",
                                                    message: nil,
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: "رجوع", style: .default,  handler:  nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            print(delivery_costAPI)
            spinnerView.beginRefreshing()
            let cost = Double(delivery_costAPI)
            guard let code = codeText.text else { return }
            let trimmedString = code.trimmingCharacters(in: .whitespaces)

            let url =  "https://api.voucherify.io/v1/vouchers/\(trimmedString)/redemption"
           let para: [String: Any] = [
            "order": [
                "amount": cost
            ]
        ]
        
        let headers = [
            "X-App-Id" : "3362ed72-c26d-4941-9159-272e57cd214e",
            "X-App-Token" : "8c02412d-7603-4923-9135-d083187b9a53",
            "Content-Type" : "application/json"]
        Alamofire.request(url, method: .post, parameters: para,encoding: JSONEncoding.default , headers: headers).responseJSON { response in
            
            if let value : AnyObject = response.result.value as AnyObject {
                
                let discountData = JSON(value)
                
                print(discountData)
                if discountData["message"].stringValue == "Resource not found" ||
                    discountData["message"].stringValue == "voucher is disabled" ||
                    discountData["message"].stringValue == "quantity exceeded" ||
                    discountData["message"].stringValue == "quantity exceeded" ||
                    discountData["message"].stringValue == "voucher_not_active" ||
                    discountData["message"].stringValue == "voucher_expired"  ||
                    discountData["message"].stringValue == "Invalid Order"{
                    self.spinnerView.endRefreshing()
                    let alertController = UIAlertController(title: " كود الخصم المستخدم غير صحيح",
                        message: nil,
                        preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "رجوع", style: .default,  handler:  nil)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                    print("not valid")
                    
                    // alert code not valied
                } else {
                    for (key,subJson):(String, JSON) in discountData {
                        
                        switch subJson["discount"]["type"].stringValue {
                        case "PERCENT" :
                         let percent = subJson["discount"]["percent_off"].stringValue
                            print("its precent")
                            let afterDiscount = discountData["order"]["discount_amount"].intValue
                           let newDeliveryFee = Double(self.delivery_costAPI)! - Double(afterDiscount)
                            let total = Double(newDeliveryFee) + Double(self.subtotalAPI)!
                            self.totalAPI = String(total)
                            self.total.text = "\(total)ريال "
                            self.deliveryFee.text = "\(newDeliveryFee)ريال بعد الخصم"
                            self.delivery_costAPI = String(newDeliveryFee)
                            self.checkBtn.isEnabled = false
                            self.spinnerView.endRefreshing()
                            print("its precent")
                            let alertController = UIAlertController(title: "  تم خصم %\(percent)",
                                                                    message: nil,
                                                                    preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "تمام", style: .default,  handler:  nil)
                            
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)
                            
                        case "AMOUNT" :
                            self.spinnerView.endRefreshing()

                            print("its amount")
                            
                        default :
                            
                            print("not present or amount")
                        }
                        
                        
                        
                    }
                    
                }
                
            }
            
            
            
            
        }
        
        
        
        }
    }
    
    
    
    
}

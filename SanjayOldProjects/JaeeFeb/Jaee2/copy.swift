//
//  PickLocationViewController.swift
//  Jaee2
//
//  Created by Abdulaziz  Almohsen on 7/3/17.
//  Copyright © 2017 Jaee. All rights reserved.
//

/*

import MapKit
import CoreLocation
import Alamofire
import SwiftyJSON
import DropDown
import Permission
import NotificationBannerSwift



class PickLocationViewController: UIViewController , CLLocationManagerDelegate ,MKMapViewDelegate  {
    
    
    // variables
    var lat = ""
    var lng = ""
    var currentcity = ""
    var timeselected = "الآن"
    var totalAPI = ""
    var subtotalAPI = ""
    var delivery_costAPI = ""
    
    var denyLocation = false
    
    // outlets
    @IBOutlet weak var nextbtn: UIButton!
    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var nameLab: UILabel!
    
    @IBOutlet weak var phoneLab: UILabel!
    
    @IBOutlet weak var addressLab: UILabel!
    
    @IBOutlet weak var subtotal: UILabel!
    
    @IBOutlet weak var deliveryFee: UILabel!
    
    @IBOutlet weak var total: UILabel!
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var phone: UILabel!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var time: UIButton!
    let locationManager = CLLocationManager()
    var myLocation:CLLocationCoordinate2D?
    
    let permission: Permission = .locationAlways
    
    //dropdwon
    let timeDrop = DropDown()
    
    let banner = NotificationBanner(title: "تمت العملية بنجاح", subtitle: "تم تحديث موقعك", style: .success)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        permission.presentPrePermissionAlert = true
        
        let alert = permission.deniedAlert // or permission.disabledAlert
        
        alert.title    = "تطبيق جاي يوصل بدقة اكثر اذا شغلت تحديد الموقع من الآعدادات.الله لا يهينكم شعلوها"
        alert.message  = nil
        alert.cancel   = "بعدين"
        alert.confirm = "تشغيلها الآن"
        
        
        print(permission.status) // PermissionStatus.NotDetermined
        
        permission.request { status in
            switch status {
            case .authorized:    print("authorized")
            case .denied:
                self.denyLocation = true
                print("denied")
            case .disabled:      print("disabled")
            case .notDetermined: print("not determined")
            }
        }
        
        //dropdown
        
        setupTime ()
        
        
        // map
        
        let theLocation: MKUserLocation = map.userLocation
        theLocation.title = "I'm here!"
        let yourAnnotationAtIndex = 1
        
        
        
        map.setUserTrackingMode(.follow, animated: true)
        
        
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        //
        map.delegate = self
        map.mapType = .standard
        map.isZoomEnabled = true
        map.isScrollEnabled = true
        
        if let coor = map.userLocation.location?.coordinate{
            map.setCenter(coor, animated: true)
            
        }
        
        
        // user info
        
        name.text = UserDataSingleton.sharedDataContainer.username
        phone.text = UserDataSingleton.sharedDataContainer.user_phone
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        map.showsUserLocation = true;
        getOrderDetails ()
        addLongPressGesture()
        resetTracking()
        
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        map.showsUserLocation = false
    }
    
    func addLongPressGesture(){
        let longPressRecogniser:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target:self , action:#selector(PickLocationViewController.handleLongPress(_:)))
        longPressRecogniser.minimumPressDuration = 0.5 //user needs to press for 2 seconds
        self.map.addGestureRecognizer(longPressRecogniser)
    }
    
    func handleLongPress(_ gestureRecognizer:UIGestureRecognizer){
        if gestureRecognizer.state != .began{
            return
        }
        
        let touchPoint:CGPoint = gestureRecognizer.location(in: self.map)
        let touchMapCoordinate:CLLocationCoordinate2D =
            self.map.convert(touchPoint, toCoordinateFrom: self.map)
        
        let annot:MKPointAnnotation = MKPointAnnotation()
        annot.coordinate = touchMapCoordinate
        annot.title = "الموقع الجديد"
        annot.subtitle = " هذا ليس موقعك الحالي"
        self.resetTracking()
        
        self.map.addAnnotation(annot)
        self.centerMap(touchMapCoordinate)
    }
    
    func resetTracking(){
        if (map.showsUserLocation){
            map.showsUserLocation = true
            self.map.removeAnnotations(map.annotations)
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    func centerMap(_ center:CLLocationCoordinate2D){
        self.saveCurrentLocation(center)
        
        let spanX = 0.007
        let spanY = 0.007
        
        let newRegion = MKCoordinateRegion(center:center , span: MKCoordinateSpanMake(spanX, spanY))
        map.setRegion(newRegion, animated: true)
    }
    
    func saveCurrentLocation(_ center:CLLocationCoordinate2D){
        let message = "\(center.latitude) , \(center.longitude)"
        print("\(message) new")
        lat = String(center.latitude)
        lng = String(center.longitude)
        
        UserDataSingleton.sharedDataContainer.lat = String(center.latitude)
        UserDataSingleton.sharedDataContainer.lng   = String(center.longitude)
        
        
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: Double(lat)!, longitude: Double(lng)!)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
            guard let addressDict = placemarks?[0].addressDictionary else {
                return
            }
            
            // Print each key-value pair in a new row
            
            // Print fully formatted address
            
            
            // Access each element manually
            if let locationName = addressDict["SubLocality"] as? String {
                
                self.label.text = locationName
                
                UserDataSingleton.sharedDataContainer.address = locationName
            }
            
            if let city = addressDict["City"] as? String {
                //                print(city)
                print(city)
                self.currentcity = city
                
                
                
                
            }
            
        })
        
        
        myLocation = center
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        
        var currentLat = locValue.latitude
        var currentLng = locValue.longitude
        
        UserDataSingleton.sharedDataContainer.lat = String(currentLat)
        UserDataSingleton.sharedDataContainer.lng = String(currentLng)
        
        
        
        print("\(UserDataSingleton.sharedDataContainer.lat) im here ")
        
        centerMap(locValue)
    }
    
    static var enable:Bool = true
    @IBAction func getMyLocation(_ sender: UIButton) {
        
        
        
        if CLLocationManager.locationServicesEnabled() {
            if PickLocationViewController.enable {
                locationManager.stopUpdatingHeading()
                sender.titleLabel?.text = "Enable"
            }else{
                locationManager.startUpdatingLocation()
                sender.titleLabel?.text = "Disable"
            }
            PickLocationViewController.enable = !PickLocationViewController.enable
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        let identifier = "pin"
        var view : MKPinAnnotationView
        if let dequeueView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView{
            dequeueView.annotation = annotation
            view = dequeueView
        }else{
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        view.pinColor =  .red
        return view
    }
    @IBAction func nextTapped(_ sender: UIButton) {
        
        
        updateLocation ()
        
        if self.currentcity != "الرياض" && self.currentcity != "Riyadh" {
            print(currentcity)
            let alert = UIAlertController(title: "انت خارج الرياض", message: " نآسف، لا يمكننا خدمتك وانت خارج الرياض ☹️", preferredStyle: .alert)
            let action = UIAlertAction(title: "رجوع", style: .default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            // submit
            
            
            let param = ["user_id":"\(UserDataSingleton.sharedDataContainer.user_id!)",
                "delivery_cost":"\(delivery_costAPI)",
                "subtotal":"\(subtotalAPI)",
                "total":"\(totalAPI)",
                "time":"\(self.timeselected)"
            ]
            let urlStr = "http://jaeeapp.com/api/client/order"
            let url = URL(string: urlStr)
            
            
            let user = "apiuser"
            let password = "ApiAuthPass2017"
            
            
            
            var headers: HTTPHeaders = [
                "Authorization": "Basic YXBpdXNlcjpBcGlBdXRoUGFzczIwMTchQCM="
            ]
            
            
            Alamofire.request(url!, method: .post, parameters: param,encoding: URLEncoding.default, headers: headers).responseJSON { response in
                if let value: AnyObject = response.result.value as AnyObject? {
                    
                    
                    let data = JSON(value)
                    
                    
                    if data["success"].bool == true {
                        
                        self.performSegue(withIdentifier: "submitted", sender: self)
                    }
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
                let data = order["order"]
                
                print(data)
                
                self.subtotalAPI = data["subtotal"].stringValue
                self.totalAPI = data["total"].stringValue
                self.delivery_costAPI = data["delivery_cost"].stringValue
                
                self.subtotal.text = self.subtotalAPI
                self.total.text =  self.totalAPI
                self.deliveryFee.text = self.delivery_costAPI
                
                
                
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
            
            
            print(self.timeDrop.selectedItem)
            
            self.timeselected = self.timeDrop.selectedItem!
        }
        
    }
    
    @IBAction func timeTapped(_ sender: Any) {
        timeDrop.show()
    }
    
    func submitOrder (id : String){
        
        updateLocation ()
        let param = ["user_id":"\(UserDataSingleton.sharedDataContainer.user_id!)",
            "delivery_cost":"\(delivery_costAPI)",
            "subtotal":"\(subtotalAPI)",
            "total":"\(totalAPI)",
            "time":"\(self.timeselected)"
        ]
        let urlStr = "jaeeapp.com/api/client/order"
        let url = URL(string: urlStr)
        
        
        let user = "apiuser"
        let password = "ApiAuthPass2017"
        
        
        
        var headers: HTTPHeaders = [
            "Authorization": "Basic YXBpdXNlcjpBcGlBdXRoUGFzczIwMTchQCM="
        ]
        
        
        Alamofire.request(url!, method: .post, parameters: param,encoding: URLEncoding.default, headers: headers).responseJSON { response in
            if let value: AnyObject = response.result.value as AnyObject? {
                
                
                let data = JSON(value)
                
                print(data)
                
                if data["success"].bool == true {
                    
                    self.performSegue(withIdentifier: "submitted", sender: self)
                }
                
                
                //Handle the results as JSON
            }
        }
    }
    
    func updateLocation () {
        
        
        
        
        let param = ["name":"\(UserDataSingleton.sharedDataContainer.username!)",
            "mobile":"\(UserDataSingleton.sharedDataContainer.user_phone!)",
            "lat":"\(UserDataSingleton.sharedDataContainer.lat!)",
            "lng":"\(UserDataSingleton.sharedDataContainer.lng!)",
            "user_id":"\(UserDataSingleton.sharedDataContainer.user_id!)",
            "address" : "\(UserDataSingleton.sharedDataContainer.address!)"
        ]
        
        let urlStr = "http://jaeeapp.com/api/client/update_profile"
        let url = URL(string: urlStr)
        
        
        let user = "apiuser"
        let password = "ApiAuthPass2017"
        
        
        
        var headers: HTTPHeaders = [
            "Authorization": "Basic YXBpdXNlcjpBcGlBdXRoUGFzczIwMTchQCM="
        ]
        
        
        Alamofire.request(url!, method: .post, parameters: param,encoding: URLEncoding.default, headers: headers).responseJSON { response in
            print(response.result.debugDescription)
            
            if let value: AnyObject = response.result.value as AnyObject? {
                //Handle the results as JSON
                let data = JSON(value)
                
                if data["success"].bool == true {
                    
                    self.banner.show()
                    
                    
                } else {
                    
                    let alert = UIAlertController(title: "تغير معلومات", message: "حدث خطاء اثناء تغير المعلومات. الرجاء التآكد من صحه المعلومات", preferredStyle: .alert)
                    let action = UIAlertAction(title: "معاودة", style: .default, handler: nil)
                    alert.addAction(action)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
                
                
                
            }
        }
        
        
        
        
    }
    
    func askLocation () {
        
        
        let alert = permission.deniedAlert // or permission.disabledAlert
        
        alert.title    = "تطبيق جاي يوصل بدقة اكثر اذا تم تشغيل تحديد الموقع من الآعدادات. الرجاء تشغيلها "
        alert.message  = nil
        alert.cancel   = "بعدين"
        alert.confirm = "الذهاب الآن"
        
        
        
        permission.request { status in
            switch status {
            case .authorized:
                
                
                self.denyLocation = false
                func centerMap(_ center:CLLocationCoordinate2D){
                    self.saveCurrentLocation(center)
                    
                    let spanX = 0.007
                    let spanY = 0.007
                    
                    let newRegion = MKCoordinateRegion(center:center , span: MKCoordinateSpanMake(spanX, spanY))
                    self.map.setRegion(newRegion, animated: true)
                }
                
                print("authorized")
                
                
            case .denied:
                self.denyLocation = true
                print("denied")
                
            case .disabled:
                
                print("disabled")
                
                
            case .notDetermined:
                
                func centerMap(_ center:CLLocationCoordinate2D){
                    self.saveCurrentLocation(center)
                    
                    let spanX = 0.007
                    let spanY = 0.007
                    
                    let newRegion = MKCoordinateRegion(center:center , span: MKCoordinateSpanMake(spanX, spanY))
                    self.map.setRegion(newRegion, animated: true)
                }
                print("not determined")
            }
        }
        
        
    }
    
    
}

*/

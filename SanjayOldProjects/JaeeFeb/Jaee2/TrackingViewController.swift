//
//  TrackingViewController.swift
//  Jaee2
//
//  Created by Abdulaziz  Almohsen on 7/11/17.
//  Copyright © 2017 Jaee. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MapKit
import CoreLocation
import SwiftyGif
import Permission
import OneSignal
import TCPickerView
import StoreKit



class TrackingViewController: UIViewController , CLLocationManagerDelegate  , MKMapViewDelegate{
    
    
    
    
    
    // outlets
    @IBOutlet weak var statusLab: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var contactView: UIView!
    @IBOutlet weak var driverName: UILabel!
    @IBOutlet weak var subtotal: UILabel!
    @IBOutlet weak var total: UILabel!
    
    let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
    
    var doneDeliveryNotification = false
    var cancelDeliveryNotification = false
    var acceptedDeliveryNotification = false
    
    // Variables
    var currentUserLocationLat = ""
    var currentUserLocationLng = ""
    var totalAPI = ""
    var subtotalAPI = ""
    var order_id = ""
    var currentDriverLocationLat = ""
    var currentDriverLocationLng = ""
    var currentDriverName = ""
    var currentDriverNumber = ""
    let permission: Permission = .locationAlways

    var places = [Place]()

    var isTaken = false
    
    let locationManager = CLLocationManager()
    var pinAnnotationView:MKPinAnnotationView!
    
    var timer = Timer()
    var mealValue = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
       print("shit")
       
        let gifManager = SwiftyGifManager(memoryLimit:20)
        let gif = UIImage(gifName: "bikee")
        let imageview = UIImageView(gifImage: gif, manager: gifManager)
        imageview.frame = CGRect(x: 0.0, y: 5.0, width: 400.0, height: 200.0)
       self.myImageView.setGifImage(gif)
        
        // searching image 
               
         // map
        requestLocationAccess()
        addAnnotations()
        addPolyline()
        addPolygon()
        self.locationManager.delegate = self

        
        // counter 
      
        contactView.isHidden = true

    }
    
  
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("hello world")
        let alertController = UIAlertController(title: "تم ارسال طلبك بنجاح",
                                                message: "تم ارسال طلبك بنجاح وفي إنتظار اقرب مندوب لك. سيتم إظهار معلومات المندوب في هذي الصفحة قريباَ",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "متابعة", style: .default,  handler:  nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
        // progress
//        progress.animate(toStep: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "track order")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
        
        // order repeated func
        getOrderData ()
        scheduledTimerWithTimeInterval()
        
        

    }
   
    
    func scheduledTimerWithTimeInterval(){
        timer = Timer.scheduledTimer(timeInterval: 35 , target: self, selector: #selector(self.getOrderData), userInfo: nil, repeats: true)
    }
    
    func updateLocation (){
        
        mapView.showsUserLocation = true
        let pLat = Double(self.currentDriverLocationLat)
        let pLong = Double(self.currentDriverLocationLng)
        let center = CLLocationCoordinate2D(latitude: pLat!, longitude: pLong!)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07))
        
        self.mapView.setRegion(region, animated: true)
        
        
        
        let annotation = MKPointAnnotation()
        annotation.title = "im coming"

        annotation.coordinate = CLLocationCoordinate2D(latitude: pLat!, longitude: pLong!)
        mapView.removeAnnotations(mapView.annotations)
        
       
        mapView.addAnnotation(annotation)
        
    }
    
    
    
    // request location 
    
    func requestLocationAccess() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return
            
        case .denied, .restricted:
            print("no connection")
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    func addAnnotations() {
        mapView?.delegate = self
        mapView?.addAnnotations(places)
        
        let overlays = places.map { MKCircle(center: $0.coordinate, radius: 20) }
        mapView?.addOverlays(overlays)
        
        // Add polylines
        
                var locations = places.map { $0.coordinate }
                print("Number of locations: \(locations.count)")
                let polyline = MKPolyline(coordinates: &locations, count: locations.count)
                mapView?.add(polyline)
        
    }
    func addPolyline() {
        var locations = places.map { $0.coordinate }
        let polyline = MKPolyline(coordinates: &locations, count: locations.count)
        
        mapView?.add(polyline)
    }

    func addPolygon() {
        var locations = places.map { $0.coordinate }
        let polygon = MKPolygon(coordinates: &locations, count: locations.count)
        mapView?.add(polygon)
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 2
            return renderer
            
        } else if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.orange
            renderer.lineWidth = 3
            return renderer
            
        } else if overlay is MKPolygon {
            let renderer = MKPolygonRenderer(polygon: overlay as! MKPolygon)
            renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
            renderer.strokeColor = UIColor.orange
            renderer.lineWidth = 2
            return renderer
        }
        
        return MKOverlayRenderer()
    }
    
// to here
    @objc func getOrderData () {
        
        print("passed")
        let param = ["user_id":"\(UserDataSingleton.sharedDataContainer.user_id!)"]
        let urlStr = "http://jaeeapp.com/api/client/current_order"
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
                
                self.mealValue = []
                
                for (key,subJson):(String, JSON) in  data["orders"][0]["order_meal"] {
                  
                 let mealNames = subJson["meal"]["name"].stringValue
                    
                    self.mealValue.append(mealNames)
                    

                }
                
                let order = data["orders"][0]
                 let driver = data["orders"][0]["driver"]
                self.totalAPI = "\(order["total"].stringValue) ريال "
                self.subtotalAPI = "\(order["subtotal"].stringValue) ريال"
                self.subtotal.text = "\(order["subtotal"].stringValue) ريال"
                self.total.text = "\(order["total"].stringValue) ريال"
                
                
                var id = 0
                
                if  order["id"].int == nil {
                    
                    id = 39
                }
                
                if order["id"].int != nil {
                    
                    id = order["id"].int!
                }
                
                self.order_id = String(describing: id)
                let lat = driver["lat"].stringValue
                let lng = driver["lng"].stringValue
                self.currentDriverName = driver["name"].stringValue
                self.currentDriverNumber = driver["mobile"].stringValue
                self.totalAPI = "\(order["total"].stringValue) ريال "
                self.subtotalAPI = "\(order["subtotal"].stringValue) ريال"
                self.currentDriverLocationLat = lat
                self.currentDriverLocationLng = lng
                if order["status"].stringValue == "3" {
                    
                    self.confirmStatus()
                    self.isTaken = true
                }
                
                if order["status"].stringValue == "4" {
                    
                    self.deliveryStatus()
                    self.isTaken = true
                }
                
                if order["status"].stringValue != "4" && order["status"].stringValue != "3" && order["status"].stringValue != "1"  && order["status"].stringValue != "2" {
                    
                    self.timer.invalidate()
                  print("hi im looping")
                    self.doneDelivery()
                    return 
                    
                }
                
                
                
            }
           

            
        
        }
    }


    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        let annotationIdentifier = "Identifier"
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        if let annotationView = annotationView {
            
            annotationView.canShowCallout = true
            
            annotationView.image = UIImage(named: "pin")
            annotationView.frame.size = CGSize(width: 40.0, height: 40.0)
        }
        return annotationView
    }
    
    
    
    
    // countrer func
    
   
    
    func confirmStatus () {
        
        if UserDataSingleton.sharedDataContainer.notificationOn == "on"
           {
        let userID = status.subscriptionStatus.userId
        let pushToken = status.subscriptionStatus.pushToken
        if pushToken != nil {
            if let playerID = userID {
                // do something
                OneSignal.postNotification(["contents": ["en": "مندوبنا استلم طلبك "], "include_player_ids": ["\(playerID)"]])
                UserDataSingleton.sharedDataContainer.notificationOn = "off"

                UserDataSingleton.sharedDataContainer.id = playerID
            }
        }
            
        }

        contactView.isHidden = false

        statusLab.text = "\(UserDataSingleton.sharedDataContainer.username!)،استلمنا طلبك"
        cancelBtn.isHidden = true
        
        driverName.text = currentDriverName
        subtotal.text = subtotalAPI
        total.text = totalAPI
        
        
        print("im here")
        
        
    }
    
    func deliveryStatus () {
        
        if UserDataSingleton.sharedDataContainer.notificationComing == "on" {
        let userID = status.subscriptionStatus.userId
        let pushToken = status.subscriptionStatus.pushToken
        if pushToken != nil {
            if let playerID = userID {
                // do something
            OneSignal.postNotification(["contents": ["en": " طلبك جايك على الطريق 🚴🏽 "], "include_player_ids": ["\(playerID)"]])
                
                UserDataSingleton.sharedDataContainer.id = playerID
                UserDataSingleton.sharedDataContainer.notificationComing = "off"

            }
        }
        }
        cancelBtn.isHidden = true
        myImageView.isHidden = true
        mapView.showsUserLocation = true
       statusLab.text = "جاري التوصيل"
        contactView.isHidden = false 
        driverName.text = currentDriverName
        subtotal.text = subtotalAPI
        total.text = totalAPI
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.updateLocation()
        }
        
    }
    
    func doneDelivery (){
        UserDataSingleton.sharedDataContainer.notificationComing = "on"
        UserDataSingleton.sharedDataContainer.notificationComing = "on"
        let userID = status.subscriptionStatus.userId
        let pushToken = status.subscriptionStatus.pushToken
        timer.invalidate()
        if pushToken != nil {
            if let playerID = userID {
                self.timer.invalidate()

                // do something
                OneSignal.postNotification(["contents": ["en": "جاي في خدمتك كل يوم \(UserDataSingleton.sharedDataContainer.username!) "], "include_player_ids": ["\(playerID)"]])
                
                UserDataSingleton.sharedDataContainer.id = playerID
            }
        }
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            // Fallback on earlier versions
            print("old version")
        }

//        progress.animate(toStep: 4)

        let alertController = UIAlertController(title: "شكرا على استخدام جاي ،في امان الله 🌹",
                                                message: nil,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default,  handler:  { action in
            
            self.performSegue(withIdentifier: "main", sender: self)
            
            })
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    // call 
    
    @IBAction func callDriver(_ sender: Any) {
        let alertController = UIAlertController(title: "سوف يتم الاتصال بالمندوب ", message: "تواصل مع المندوب لمعرفه حالة الطلب اكثر ", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "الغاء", style: .cancel, handler: nil)
        let backToSignIn = UIAlertAction(title: "اتصال", style: .default, handler: { action in
            
            
            let number = self.currentDriverNumber
            let numberCharacters = NSCharacterSet.decimalDigits.inverted
            
            if !number.isEmpty && number.rangeOfCharacter(from: numberCharacters) == nil {
                
                let url = URL(string: "tel://\(number)")
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                
                
            } else {
                let alert = UIAlertView()
                alert.title = "Sorry!"
                alert.message = "هذا المتجر/المحل لا يوجد لديه رقم. اذهب فورا لآستلام الطلب من المحل دون الحاجه للاتصال"
                alert.addButton(withTitle: "Ok")
                alert.show()
                
            }
            
        })
        alertController.addAction(backToSignIn)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
        
        
    }

    
    @IBAction func cancelTapped(_ sender: Any) {
        
        let alertController = UIAlertController(title: "هل تريد الغاء الطلب؟", message: "", preferredStyle: .alert)
        let backToSignIn = UIKit.UIAlertAction(title: "لا ", style: .cancel, handler: nil)
        
        let cancelOrder = UIKit.UIAlertAction(title: "نعم ", style: .default, handler: { action in
            self.cancelOrderFunc()
        })
        alertController.addAction(backToSignIn)
        alertController.addAction(cancelOrder)
        self.present(alertController, animated: true, completion: nil)
        
        }
    
    func cancelOrderFunc() {
        
        UserDataSingleton.sharedDataContainer.notificationComing = "on"
        UserDataSingleton.sharedDataContainer.notificationComing = "on"
        let param = ["driver_id":"39" ,
                     "order_id":"\(self.order_id)",
            "id":"6"]
        let urlStr = "http://jaeeapp.com/api/order_status"
        timer.invalidate()
        
        let url = URL(string: urlStr)
        
        
        let user = "apiuser"
        let password = "ApiAuthPass2017"
        
        
        var headers: HTTPHeaders = [
            "Authorization": "Basic YXBpdXNlcjpBcGlBdXRoUGFzczIwMTchQCM="
        ]
        
        
        Alamofire.request(url!, method: .post, parameters: param,encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
            if let value: AnyObject = response.result.value as AnyObject? {
                print(response)
                let usertoken = JSON(value)
                
                if usertoken == ["تم تغيير حالة الطلب"] {
                    
                    let alertController = UIAlertController(title: "تم الغاء الطلب بنجاح", message: "تم الغاء الطلب", preferredStyle: .alert)
                    let backToSignIn = UIKit.UIAlertAction(title: "الرجوع ", style: .default, handler: { action in self.performSegue(withIdentifier: "main", sender: self)})
                    alertController.addAction(backToSignIn)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                    
                } else {
                    
                    // not done
                    
                    let alertController = UIAlertController(title: "لم يتم الغاء الطلب بنجاح ، قد يكون بسبب النت البطئ... حاول مرة اخرى", message: " الغاء الطلب", preferredStyle: .alert)
                    let backToSignIn = UIKit.UIAlertAction(title: "محاولة اخرى ", style: .default, handler:nil)
                    alertController.addAction(backToSignIn)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                
            } else {
                
            }
        }
    }
    }




extension TrackingViewController: CircularStepProgressDelegate {

    func didFinishCompleteAnimation(sender: CircularStepProgressView) {
        let alertController = UIAlertController(title: "شكرا لك على استخدام جاي :) نراكم قريباً",
                                                message: nil,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction private func showButtonPressed(button: UITapGestureRecognizer) {
        let picker = TCPickerView()
        picker.title = "طلباتك كالتالي:"
        let cars = mealValue
        let values = cars.map { TCPickerView.Value(title: $0) }
        picker.values = values
       
        
        picker.show()
    }
    
    
    
}



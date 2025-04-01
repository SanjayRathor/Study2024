////
////  updateLocationViewController.swift
////  Jaee2
////
////  Created by Abdulaziz  Almohsen on 7/4/17.
////  Copyright © 2017 Jaee. All rights reserved.
////
//
//import UIKit
//import MapKit
//import CoreLocation
//import Alamofire
//import SwiftyJSON
//
//
//
//class updateLocationViewController: UIViewController , CLLocationManagerDelegate ,MKMapViewDelegate {
//    
//    // variable
//    var lat = ""
//    var lng = ""
//    var currentcity = ""
//    // map manager
//    let locationManager = CLLocationManager()
//    var myLocation:CLLocationCoordinate2D?
//    
//    
//    // outlet
//    @IBOutlet weak var label: UILabel!
//    
//    @IBOutlet weak var map: MKMapView!
//    
//    @IBOutlet weak var nametxt: UITextField!
//    @IBOutlet weak var phonetxt: UITextField!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        
//        // user info loading
//        
//        nametxt.text = UserDataSingleton.sharedDataContainer.username
//        
//        phonetxt.text = UserDataSingleton.sharedDataContainer.user_phone
//        // map
//        
//        
//        let theLocation: MKUserLocation = map.userLocation
//        theLocation.title = "I'm here!"
//        super.viewDidLoad()
//        
//        
//        // Ask for Authorisation from the User.
//        self.locationManager.requestAlwaysAuthorization()
//        
//        // For use in foreground
//        self.locationManager.requestWhenInUseAuthorization()
//        
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager.startUpdatingLocation()
//        }
//        
//        map.delegate = self
//        map.mapType = .standard
//        map.isZoomEnabled = true
//        map.isScrollEnabled = true
//        
//        if let coor = map.userLocation.location?.coordinate{
//            map.setCenter(coor, animated: true)
//        }
//        addLongPressGesture()
//        
//        
//        
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        map.showsUserLocation = true;
//        
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        map.showsUserLocation = false
//    }
//    
//    func addLongPressGesture(){
//        let longPressRecogniser:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target:self , action:#selector(PickLocationViewController.handleLongPress(_:)))
//        longPressRecogniser.minimumPressDuration = 1.0 //user needs to press for 2 seconds
//        self.map.addGestureRecognizer(longPressRecogniser)
//    }
//    
//    func handleLongPress(_ gestureRecognizer:UIGestureRecognizer){
//        if gestureRecognizer.state != .began{
//            return
//        }
//        
//        let touchPoint:CGPoint = gestureRecognizer.location(in: self.map)
//        let touchMapCoordinate:CLLocationCoordinate2D =
//            self.map.convert(touchPoint, toCoordinateFrom: self.map)
//        
//        let annot:MKPointAnnotation = MKPointAnnotation()
//        annot.coordinate = touchMapCoordinate
//        annot.title = "الموقع الجديد"
//        annot.subtitle = " هذا ليس موقعك الحالي"
//        self.resetTracking()
//        self.map.addAnnotation(annot)
//        self.centerMap(touchMapCoordinate)
//    }
//    
//    func resetTracking(){
//        if (map.showsUserLocation){
//            map.showsUserLocation = true
//            self.map.removeAnnotations(map.annotations)
//            self.locationManager.stopUpdatingLocation()
//        }
//    }
//    
//    func centerMap(_ center:CLLocationCoordinate2D){
//        self.saveCurrentLocation(center)
//        
//        let spanX = 0.007
//        let spanY = 0.007
//        
//        let newRegion = MKCoordinateRegion(center:center , span: MKCoordinateSpanMake(spanX, spanY))
//        map.setRegion(newRegion, animated: true)
//    }
//    
//    func saveCurrentLocation(_ center:CLLocationCoordinate2D){
//        let message = "\(center.latitude) , \(center.longitude)"
//        //        print("\(message) new")
//        lat = String(center.latitude)
//        lng = String(center.longitude)
//        print(lat)
//        
//        let geoCoder = CLGeocoder()
//        let location = CLLocation(latitude: Double(lat)!, longitude: Double(lng)!)
//        
//        geoCoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
//            guard let addressDict = placemarks?[0].addressDictionary else {
//                return
//            }
//            
//            // Print each key-value pair in a new row
//            //            addressDict.forEach { print($0) }
//            
//            // Print fully formatted address
//            
//            
//            // Access each element manually
//            if let locationName = addressDict["SubLocality"] as? String {
//                //                print("\(locationName) here is the nighbot")
//                
//                self.label.text = locationName
//            }
//            
//            if let city = addressDict["City"] as? String {
//                self.currentcity = city
//                
//                
//                
//                
//            }
//            
//        })
//        
//        
//        myLocation = center
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
//        
//        centerMap(locValue)
//    }
//    
//    static var enable:Bool = true
//    @IBAction func getMyLocation(_ sender: UIButton) {
//        
//        
//        
//        if CLLocationManager.locationServicesEnabled() {
//            if PickLocationViewController.enable {
//                locationManager.stopUpdatingHeading()
//                sender.titleLabel?.text = "Enable"
//            }else{
//                locationManager.startUpdatingLocation()
//                sender.titleLabel?.text = "Disable"
//            }
//            PickLocationViewController.enable = !PickLocationViewController.enable
//        }
//    }
//    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
//        let identifier = "pin"
//        var view : MKPinAnnotationView
//        if let dequeueView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView{
//            dequeueView.annotation = annotation
//            view = dequeueView
//        }else{
//            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            view.canShowCallout = true
//            view.calloutOffset = CGPoint(x: -5, y: 5)
//            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//        }
//        view.pinColor =  .red
//        return view
//    }
//    
//    @IBAction func saveData(_ sender: Any) {
//        
//        let param = ["user_id":"\(392)",
//            "name":"\(nametxt.text)",
//            "email":"",
//            "mobile":"\(phonetxt.text)",
//            "":"",
//            "address":"\(label.text)",
//            "lat":"\(lat)",
//            "lng":"\(lng)"
//        ]
//        let urlStr = "http://jaeeapp.com/api/client/update_profile"
//        let url = URL(string: urlStr)
//        
//        
//        let user = "apiuser"
//        let password = "ApiAuthPass2017"
//        
//        
//        
//        var headers: HTTPHeaders = [
//            "Authorization": "Basic YXBpdXNlcjpBcGlBdXRoUGFzczIwMTchQCM="
//        ]
//        
//        
//        Alamofire.request(url!, method: .post, parameters: param,encoding: URLEncoding.default, headers: headers).responseJSON { response in
//            if let value: AnyObject = response.result.value as AnyObject? {
//                //Handle the results as JSON
//                
//                
//                let data = JSON(value)
//                
//                print(data)
//                
//            }
//        }
//        
//    }
//    @IBAction func back(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
//    }
//}

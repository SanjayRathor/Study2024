//
//  KPMapVC.swift
//  Jaee2
//
//  Created by Abdulaziz  Almohsen on 11/16/17.
//  Copyright © 2017 Jaee. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit
import MapKit
import JTMaterialSpinner


class KPMapVC: UIViewController,UISearchBarDelegate {
    
    // IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var imgPin: UIImageView!
    @IBOutlet var lblSelectedAddress: UILabel!
    
    // Variables
    var pinAnimation: CABasicAnimation!
    var selectedAddress: FullAddress!
    var callBackBlock: ((_ add: FullAddress) -> Void)!
       var spinnerView = JTMaterialSpinner()
    
    var riyadh: (country: String, city: String)?

    
    // View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initAnimation()
        self.addLableShadow()
        self.view.addSubview(spinnerView)
        spinnerView.frame = CGRect(x: (375.0 - 50.0) / 2.0, y: 300, width: 50, height: 50)
        spinnerView.circleLayer.lineWidth = 2.0
        spinnerView.circleLayer.strokeColor = UIColor.gray.cgColor
        spinnerView.animationDuration = 2.5
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.fetchUserLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "locationPickerSegue"{
            let searchCon = segue.destination as! KPSearchLocationVC
            searchCon.selectionBlock = {[unowned self](add) -> () in
                self.setMapResion(lat: add.lat, long: add.long)
                self.lblSelectedAddress.text = add.address
                self.selectedAddress = add
            }
        }
    }
    @IBAction func proceesClicked(_ sender: Any) {
        
        if selectedAddress == nil {
            print("no location saved")
            return
        } else {
            spinnerView.beginRefreshing()

            var lat = selectedAddress.lat
            var lng = selectedAddress.long
            let location = CLLocation(latitude: lat, longitude: lng)
            
            fetchCountryAndCity(location: location) { country, city in
              
                
                if let riyadh = self.riyadh, riyadh == (country, city) {
                    print("Hey it's Riyadh. Name in user locale is \(city)")
                } else {
                    print("Hey it's NOT Riyadh. Name in user locale is \(city)")

                }
                
                // Get Riyadh : - Riyadh
                if city == "Riyadh" || city == "الرياض" || city == "리야드" || city == "Riyah"  {
                    print("it's Riyadh")
                    UserDataSingleton.sharedDataContainer.lat = String(lat)
                    UserDataSingleton.sharedDataContainer.lng = String(lng)
                

                    self.updateLocation()
                    
                } else {
                    
                    print("not in riyadh")
                    let alert = UIAlertController(title: "خارج الرياض", message: "اسف ، مانوصل لخارج الرياض حاليآ. ", preferredStyle: .alert)
                    let action = UIAlertAction(title: "رجوع", style: .default, handler: nil)
                    alert.addAction(action)
                    self.spinnerView.endRefreshing()
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
            }
            
        }
        
    }
    
}


// MARK: - Actions
extension KPMapVC{
    
    @IBAction func getUserCurrentLocation(sender: UIButton){
        self.fetchUserLocation()
    }
    
  
    
    @IBAction func btnSearchAddTap(sender: UIButton){
        self.performSegue(withIdentifier: "locationPickerSegue", sender: nil)
    }
}

// MARK: - Other methods
extension KPMapVC{
    
    /// Init pin rotation animation
    func initAnimation(){
        pinAnimation = CABasicAnimation(keyPath: "transform.rotation.y")
        pinAnimation.toValue = (M_PI * 2.0 * 0.2)
        pinAnimation.duration = 0.2
        pinAnimation.isCumulative = true
        pinAnimation.repeatCount = Float.infinity
    }
    
    /// Add Shadow in address lable
    func addLableShadow(){
        lblSelectedAddress.layer.shadowColor = UIColor.black.cgColor
        lblSelectedAddress.layer.shadowRadius = 4.0
        lblSelectedAddress.layer.shadowOpacity = 0.7
        lblSelectedAddress.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    /// Start pin rotation animation
    func startPinAnimation(){
        self.imgPin.layer.add(self.pinAnimation, forKey: "rotationAnimation")
    }
    
    /// Stop pin rotation animation
    func stopPinAnimation(){
        self.imgPin.layer.removeAllAnimations()
    }
    
    /// Fetch user current location with formatted address.
    func fetchUserLocation() {
        self.startPinAnimation()
        UserLocation.sharedInstance.fetchUserLocationForOnce(controller: self) { (location, error) in
            if let _ = location{
                if isGooleKeyFound{
                    KPAPICalls.shared.getAddressFromLatLong(lat: "\(location!.coordinate.latitude)", long: "\(location!.coordinate.longitude)", block: { (str) in
                        self.stopPinAnimation()
                        self.lblSelectedAddress.text = str
                        self.mapView.userLocation.title = str
                        self.setMapResion(lat: location!.coordinate.latitude, long: location!.coordinate.longitude)
                        self.selectedAddress = FullAddress(lati: location!.coordinate.latitude, longi: location!.coordinate.longitude, add: str)
                        
                    })
                }else{
                    KPAPICalls.shared.addressFromlocation(location: location!, block: { (str) in
                        self.stopPinAnimation()
                        if let _ = str{
                            self.lblSelectedAddress.text = str
                            self.mapView.userLocation.title = str
                            self.setMapResion(lat: location!.coordinate.latitude, long: location!.coordinate.longitude)
                            self.selectedAddress = FullAddress(lati: location!.coordinate.latitude, longi: location!.coordinate.longitude, add: str!)
                        }
                    })
                }
            }else{
                self.stopPinAnimation()
            }
        }
    }
}

// MARK: - MapView Delegate and fetch address.
extension KPMapVC: MKMapViewDelegate{
    
    /// Fetch new address on map grag by user.
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool){
        if !animated{
            self.startPinAnimation()
            let cord = mapView.centerCoordinate
            if isGooleKeyFound{
                KPAPICalls.shared.getAddressFromLatLong(lat: "\(cord.latitude)", long: "\(cord.longitude)", block: { (str) in
                    self.stopPinAnimation()
                    self.lblSelectedAddress.text = str
                    self.selectedAddress = FullAddress(lati: cord.latitude, longi: cord.longitude, add: str)
                    print(self.selectedAddress )
                })
            }else{
                let loc = CLLocation(latitude: cord.latitude, longitude: cord.longitude)
                KPAPICalls.shared.addressFromlocation(location: loc, block: { (str) in
                    self.stopPinAnimation()
                    if let _ = str{
                        self.lblSelectedAddress.text = str
                        self.selectedAddress = FullAddress(lati: cord.latitude, longi: cord.longitude, add: str!)
                        print(self.selectedAddress )

                    }
                })
            }
        }
    }
    
    
    /// Set resion on map with selected loaction
    func setMapResion(lat: Double, long: Double){
        var loc = CLLocationCoordinate2D()
        loc.latitude = lat
        loc.longitude = long
        
        var span = MKCoordinateSpan()
        span.latitudeDelta = 0.02
        span.longitudeDelta = 0.02
        
        var myResion = MKCoordinateRegion()
        myResion.center = loc
        myResion.span = span
        self.mapView.setRegion(myResion, animated: true)
    }
    func fetchCountryAndCity(location: CLLocation, completion: @escaping (String, String) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print(error)
            } else if let country = placemarks?.first?.country,
                let city = placemarks?.first?.locality {
                completion(country, city)
            }
        }
    }
    func updateLocation () {
        UserDataSingleton.sharedDataContainer.address = self.lblSelectedAddress.text!
        if UserDataSingleton.sharedDataContainer.address == "" {
            UserDataSingleton.sharedDataContainer.address = "الرياض"
        }
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
                    self.performSegue(withIdentifier: "toOrder", sender: self)
                 self.spinnerView.endRefreshing()
                    
                } else {
                    self.spinnerView.endRefreshing()
                    let alert = UIAlertController(title: "تغير معلومات", message: "حدث خطاء اثناء تغير المعلومات. الرجاء التآكد من صحه المعلومات", preferredStyle: .alert)
                    let action = UIAlertAction(title: "محاولة اخرى", style: .default, handler: nil)
                    alert.addAction(action)
                    
                    
                    
                }
                
            }
        }
        
    }
    
}


//
//  HomeDellivery.swift
//  TamimiEcom
//
//  Created by Ansh on 18/09/20.
//  Copyright © 2020  ltd. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol ContinueHomeDelliveryAction:class  {
    func continueActionHomeDellivery()
}
class HomeDellivery: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate,UIGestureRecognizerDelegate {
    var sectectredLocation : LocationInformation?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var txtArea: UITextField!
    
    @IBOutlet weak var despTxtView: UITextView!
    @IBOutlet weak var txtCity: UITextField!
    
    let locationManager = CLLocationManager()
    
    weak var delegate:ContinueHomeDelliveryAction?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLocationCurrent()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func continueAction(_ sender: Any) {
        if let location = self.sectectredLocation  {
            ApplicationStates.saveLocationInformation(locationId: location._id, locationName: location.storeName, locationAddress: location.addressvalue)
        }
        if self.delegate != nil {
        self.navigationController?.popViewController(animated: false)
        self.delegate?.continueActionHomeDellivery()
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    @objc func handleTap(_ gestureReconizer: UILongPressGestureRecognizer) {
        
        let location = gestureReconizer.location(in: mapView)
        let locValue = mapView.convert(location,toCoordinateFrom: mapView)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locValue, span: span)
        mapView.setRegion(region, animated: true)
        self.geocode(latitude: locValue.latitude, longitude: locValue.longitude) { (placemark, err) in
            if placemark !=  nil {
                let dict = ["_id":"currentLocation"];
                self.sectectredLocation = LocationInformation(dict as NSDictionary)
                self.sectectredLocation?.lattitude = String(locValue.latitude)
                self.sectectredLocation?.longitude = String(locValue.longitude)
                
                self.displayLocationInfo(placemark?.first)
            }
        }
        
    }
    
    func setLocationCurrent() {
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        if let coor = mapView.userLocation.location?.coordinate{
            mapView.setCenter(coor, animated: true)
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        mapView.mapType = MKMapType.standard
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locValue, span: span)
        mapView.setRegion(region, animated: true)
        self.geocode(latitude: locValue.latitude, longitude: locValue.longitude) { (placemark, err) in
            if placemark !=  nil {
                let dict = ["_id":"currentLocation"];
                self.sectectredLocation = LocationInformation(dict as NSDictionary)
                self.sectectredLocation?.lattitude = String(locValue.latitude)
                self.sectectredLocation?.longitude = String(locValue.longitude)
                
                self.displayLocationInfo(placemark?.first)
            }
        }
    }
    func geocode(latitude: Double, longitude: Double, completion: @escaping (_ placemark: [CLPlacemark]?, _ error: Error?) -> Void)  {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { placemark, error in
            guard let placemark = placemark, error == nil else {
                completion(nil, error)
                return
            }
            completion(placemark, nil)
        }
    }
    
    func displayLocationInfo(_ placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            //stop updating location to save battery life
            let name = (containsPlacemark.name != nil) ? containsPlacemark.name : ""
            
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            if let lcation =  locality{
                self.sectectredLocation?.addressvalue =  lcation
                
            }
            if var nameN =  name  {
                if let lc = locality {
                    if !lc.isEmpty {
                        nameN.append(contentsOf: " ")
                        nameN.append(contentsOf: lc)
                        self.txtCity.text = locality
                    }
                }
                if let adAread = administrativeArea {
                    if !adAread.isEmpty {
                        nameN.append(contentsOf: " ")
                        nameN.append(contentsOf: adAread)
                    }
                }
                if let ct = country {
                    if !ct.isEmpty {
                        nameN.append(contentsOf: " ")
                        nameN.append(contentsOf: ct)
                    }
                }
                self.sectectredLocation?.storeName = "\(nameN) "
            }
          
            self.txtArea.text = self.sectectredLocation?.storeName
            if let coordinate = containsPlacemark.location?.coordinate {
                
                self.mapView.removeAnnotations(self.mapView.annotations)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = locality
                annotation.subtitle = administrativeArea
                mapView.addAnnotation(annotation)
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
    }
}

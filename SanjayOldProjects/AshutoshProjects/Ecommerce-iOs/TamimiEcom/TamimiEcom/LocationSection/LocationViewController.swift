//
//  LocationViewController.swift
//  TamimiEcom
//
//  Created by Ansh on 16/09/20.
//  Copyright © 2020  ltd. All rights reserved.
//

import UIKit
import MapKit

struct LocationInformation {
    var _id = ""
    var workingHours = ""
    var contactNo = ""
    var storeName = ""
    var addressvalue = ""
    var lattitude = ""
    var longitude = ""
    init(_ dict: NSDictionary) {
        self._id = dict["_id"] as! String
        if let storeName = dict["storeName"] as? String {
            self.storeName = storeName
        }
        if let locationDict =  dict["location"] as? NSDictionary {
            if let coordinates = locationDict["coordinates"] as? NSArray {
                if let lattitude = coordinates.firstObject as? Double {
                    self.lattitude = String(lattitude)
                }
                if let longitude = coordinates.lastObject as? Double {
                    self.longitude = String(longitude)
                }
            }
        }
        
        var addressValue : String = ""
        if let locationName = dict["locationName"] as? String {
            addressValue.append(locationName)
        }
        if let address = dict["address"] as? String {
            if !addressValue.isEmpty {
                addressValue.append("\n")
            }
            addressValue.append(address)
        }
        if let city = dict["city"] as? String {
            if !city.isEmpty {
                if !addressValue.isEmpty {
                    addressValue.append("\n")
                }
                addressValue.append(city)
                
                if let cityCode = dict["cityCode"] as? String {
                    if !city.isEmpty {
                        addressValue.append(", ")
                    }
                    addressValue.append(cityCode)
                }
            }
        }
        if let state = dict["state"] as? String {
            if !state.isEmpty {
                if !addressValue.isEmpty {
                    addressValue.append("\n")
                }
                addressValue.append(state)
                if let stateCode = dict["stateCode"] as? String {
                    if !state.isEmpty {
                        addressValue.append(", ")
                    }
                    addressValue.append(stateCode)
                }
            }
        }
        if let country = dict["country"] as? String {
            if !country.isEmpty {
                if !addressValue.isEmpty {
                    addressValue.append("\n")
                }
                addressValue.append(country)
                if let countryCode = dict["countryCode"] as? String {
                    if !country.isEmpty {
                        addressValue.append(", ")
                    }
                    addressValue.append(countryCode)
                }
            }
        }
        self.addressvalue = addressValue
        if let workingHours = dict["workingHours"] as? String {
            self.workingHours = workingHours
        }
        if let contactNo = dict["contactNo"] as? String {
            self.contactNo = contactNo
        }
    }
}
protocol ContinueActionLocationViewController:class  {
    func continueAction()
}
class LocationViewController: UIViewController {
    
    weak var delegete:ContinueActionLocationViewController?
    var sectectredLocation : LocationInformation?
    @IBOutlet weak var mapView: MKMapView!
    var itemArray = NSMutableArray()
    @IBOutlet weak var tbView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibhView = UINib(nibName: "LocationTableViewCell", bundle: nil)
        self.tbView.register(nibhView, forCellReuseIdentifier: "LocationTableViewCell")
        self.tbView.delegate = self
        self.tbView.dataSource = self
        self.fetchCoreLocations()
        // Do any additional setup after loading the view.
    }
    func fetchCoreLocations() {
        let  requestPath =  "\(Constants.stores)"
        NetworkManager.shared.getJSONResponse(path: requestPath,isLoader:true) { (value, status) in
            switch status {
            case .success:
                if let valueData  = value as? NSDictionary {
                    if let success = valueData["success"] as? Int {
                        if success == 1 {
                            self.itemArray.removeAllObjects()
                            if let data = valueData["data"]  as? NSArray {
                                for ids in data {
                                    if let dict  = ids as? NSDictionary {
                                        self.itemArray.add(LocationInformation(dict))
                                    }
                                }
                            }
                            self.tbView.reloadData()
                            self.addAnnotations()
                        }
                    }
                }
            case .error(let error):
                print(error!)
            }
        }
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func addAnnotations(){
        var i = 0
        for info in self.itemArray {
            if let cordInfo = info as? LocationInformation {
                let addAnotation = MKPointAnnotation()
                addAnotation.title = cordInfo.storeName
                addAnotation.coordinate = CLLocationCoordinate2D(latitude: cordInfo.lattitude.toDouble(), longitude: cordInfo.lattitude.toDouble())
                if ApplicationStates.getLocationSelctedID() != "" {
                    if cordInfo._id == ApplicationStates.getLocationSelctedID() {
                        mapView.setRegion(MKCoordinateRegion(center: addAnotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000), animated: false)
                        mapView.showsUserLocation = true
                        i = 1
                    }
                }
                self.mapView.addAnnotation(addAnotation)
            }
        }
        if i == 0 && self.itemArray.count > 0 {
            i = 1
            if  let location = self.itemArray.object(at: 0) as? LocationInformation {
                self.sectectredLocation = location
                mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.lattitude.toDouble(), longitude: location.lattitude.toDouble()), latitudinalMeters: 1000, longitudinalMeters: 1000), animated: false)
                mapView.showsUserLocation = true
            }
        }
    }
    
    @IBAction func continueAction(_ sender: Any) {
        if let location = self.sectectredLocation  {
            ApplicationStates.saveLocationInformation(locationId: location._id, locationName: location.storeName, locationAddress: location.addressvalue)
            if self.delegete != nil {
            self.navigationController?.popViewController(animated: false)
            self.delegete?.continueAction()
            }else {
                self.navigationController?.popViewController(animated: true)
            }
        }else {
            alert(Constants.appName, message: "Please select location", view: self)
        }
    }
}
extension LocationViewController:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : LocationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "LocationTableViewCell", for: indexPath) as! LocationTableViewCell
        if  let location = self.itemArray.object(at: indexPath.row) as? LocationInformation {
            cell.titleLbl.text = location.storeName
            cell.infoLbl.text = location.addressvalue
        }
        return cell
    }
    
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  let location = self.itemArray.object(at: indexPath.row) as? LocationInformation {
            self.sectectredLocation = location
            mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.lattitude.toDouble(), longitude: location.lattitude.toDouble()), latitudinalMeters: 1000, longitudinalMeters: 1000), animated: false)
            mapView.showsUserLocation = true
        }
    }
}

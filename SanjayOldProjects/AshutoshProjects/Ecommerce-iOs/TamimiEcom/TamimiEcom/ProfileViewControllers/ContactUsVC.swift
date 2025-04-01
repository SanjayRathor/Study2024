//
//  ContactUsVC.swift
//  TamimiEcom
//
//  Created by Ansh Kumar on 21/09/20.
//  Copyright © 2020 Ansh ltd. All rights reserved.
//

import UIKit
import MapKit
import SVProgressHUD
import RSSelectionMenu

class ContactUsVC: UIViewController {
    @IBOutlet weak var lblWorking: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var storeAddress: UILabel!
    @IBOutlet weak var lblStroreName: UILabel!
    var annotationDone = false
    @IBOutlet weak var btnPhone: UIButton!
    @IBOutlet weak var lblTimeings: UILabel!
    var contactUsDict : [String:Any] = [:]
    @IBOutlet weak var txtDesp: UITextField!
    @IBOutlet weak var txtRelated: UITextField!
    @IBOutlet weak var txtSubject: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtNameField: UITextField!
    
    var itemArray = NSMutableArray()
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var writeUsView: UIView!
    @IBOutlet weak var locateUsView: UIView!
    @IBOutlet weak var callUsView: UIView!
    @IBOutlet weak var lblWriteUsInfo: UILabel!
    @IBOutlet weak var locateus: CenteredButton!
    @IBOutlet weak var writeUs: CenteredButton!
    @IBOutlet weak var btnCallUs: CenteredButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getContactUs()
        // Do any additional setup after loading the view.
        
        let attributedString = NSMutableAttributedString(string: "FILL THIS OR EMAIL US ON\nECARE@TAMIMIMARKETS.COM", attributes: [
            .font: UIFont(name: "SegoeUI", size: 13.0)!,
            .foregroundColor: UIColor(red: 106.0 / 255.0, green: 109.0 / 255.0, blue: 110.0 / 255.0, alpha: 1.0)
        ])
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 238.0 / 255.0, green: 27.0 / 255.0, blue: 34.0 / 255.0, alpha: 1.0), range: NSRange(location: 25, length: 23))
        lblWriteUsInfo.attributedText =  attributedString
        self.writeUsCall()
        
    }
    @IBAction func callPhone(_ sender: Any) {
        if let phoneNo = self.contactUsDict["phoneNo"] as? String {
        if let url = URL(string: "tel://\(phoneNo)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }else {
            alert(Constants.appName, message: "Something went wrong!", view: self)
        }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func writeUsAction(_ sender: Any) {
        self.writeUsCall()
    }
    func writeUsCall() {
        self.locateus.isSelected =  false
        self.writeUs.isSelected =  true
        self.btnCallUs.isSelected =  false
        self.writeUsView.isHidden = false
        self.locateUsView.isHidden = true
        self.callUsView.isHidden = true
        
    }
    @IBAction func callUSAction(_ sender: Any) {
        self.locateus.isSelected =  false
        self.writeUs.isSelected =  false
        self.btnCallUs.isSelected =  true
        self.writeUsView.isHidden = true
        self.locateUsView.isHidden = true
        self.callUsView.isHidden = false
        if self.contactUsDict.count > 0 {
            self.updateContactUS()
        }else {
            self.getContactUs()
        }
        
    }
    @IBAction func locateUse(_ sender: Any) {
        self.locateus.isSelected =  true
        self.writeUs.isSelected =  false
        self.btnCallUs.isSelected =  false
        self.writeUsView.isHidden = true
        self.locateUsView.isHidden = false
        self.callUsView.isHidden = true
        if self.itemArray.count == 0 {
            self.fetchCoreLocations()
        }
    }
    
    @IBAction func submitWriteUs(_ sender: Any) {
        let name : String = txtNameField.text!
        let phone : String = txtPhoneNumber.text!
        let subject : String = txtSubject.text!
        let relatedTo : String = txtRelated.text!
        let desp: String  = txtDesp.text!
        if name.isEmpty {
            alert(Constants.appName, message: "Please enter name", view: self)
        }else  if phone.isEmpty {
            alert(Constants.appName, message: "Please enter phone number", view: self)
        }else  if subject.isEmpty {
            alert(Constants.appName, message: "Please enter subject", view: self)
        }
        else  if relatedTo.isEmpty {
            alert(Constants.appName, message: "Please enter related to", view: self)
        }else  if desp.isEmpty {
            alert(Constants.appName, message: "Please enter description", view: self)
        }else {
            SVProgressHUD.show()
            let post:[String:Any] = [
                "name": name,"customerId":ApplicationStates.getUserID(),"description":desp,"category":"writeToUs","phoneNo":phone,"subject":subject,"relatedTo":relatedTo
            ]
            NetworkManager.shared.postJSONResponse(path: Constants.addQuery, parameters:post) { (value, status) in
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                }
                switch status {
                case .success:
                    if let valueData  = value as? NSDictionary {
                        if let code = valueData["code"] as? Int {
                            if code == 201 {
                                if let message  = valueData["message"] as? String {
                                    alert(Constants.appName, message: message, view: self)
                                    self.txtDesp.text = ""
                                    self.txtRelated.text = ""
                                    self.txtSubject.text = ""
                                    self.txtPhoneNumber.text = ""
                                    self.txtNameField.text = ""                 }
                            }
                        }
                    }
                case .error(let error):
                    print(error!)
                }
            }
        }
    }
    
    @IBAction func vieAllStoreAction(_ sender: Any) {
        if self.itemArray.count == 0 {
            self.fetchCoreLocations()
        }else {
            self.listOfLoication()
        }
    }
}
extension ContactUsVC {
    func fetchCoreLocations() {
        let  requestPath =  Constants.stores
        NetworkManager.shared.getJSONResponse(path: requestPath,isLoader:true) { (value, status) in
            switch status {
            case .success:
                if let valueData  = value as? NSDictionary {
                    if let code = valueData["code"] as? Int {
                        if code == 201 {
                            self.itemArray.removeAllObjects()
                            if let data = valueData["data"]  as? NSArray {
                                for ids in data {
                                    if let dict  = ids as? NSDictionary {
                                        self.itemArray.add(LocationInformation(dict))
                                    }
                                }
                            }
                            self.addAnnotations(witIndex: 0)
                        }
                    }
                }
            case .error(let error):
                print(error!)
            }
        }
    }
    func addAnnotations(witIndex:Int){
        if !self.annotationDone {
        for info in self.itemArray {
            if let cordInfo = info as? LocationInformation {
                let addAnotation = MKPointAnnotation()
                addAnotation.title = cordInfo.storeName
                addAnotation.coordinate = CLLocationCoordinate2D(latitude: cordInfo.lattitude.toDouble(), longitude: cordInfo.lattitude.toDouble())
                self.annotationDone = true
                self.mapView.addAnnotation(addAnotation)
            }
        }
        }
        if self.itemArray.count > witIndex {
            if  let location = self.itemArray.object(at: witIndex) as? LocationInformation {
                self.lblStroreName.text = location.storeName
                //self.lblWorking.text = ""
                 var ss = location.addressvalue
                ss =  ss.replacingOccurrences(of: "\n", with: " ")
                self.storeAddress.text = "STORE ADDRESS:  \(ss)"
                
                mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.lattitude.toDouble(), longitude: location.lattitude.toDouble()), latitudinalMeters: 1000, longitudinalMeters: 1000), animated: false)
                mapView.showsUserLocation = true
                
                self.lblWorking.text = "Working Hours: \(location.workingHours)"
                self.lblPhone.text = "Phone Number: \(location.contactNo)"
                
            }
        }
    }
}
extension ContactUsVC {
    func getContactUs() {
        SVProgressHUD.show()
        let  requestPath =  Constants.listContact
        NetworkManager.shared.getJSONResponse(path: requestPath,isLoader:true) { (value, status) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }
            switch status {
            case .success:
                if let valueData  = value as? NSDictionary {
                    if let code = valueData["code"] as? Int {
                        if code == 201 {
                            self.itemArray.removeAllObjects()
                            if let data = valueData["data"]  as? [String : Any] {
                                //data
                                self.contactUsDict = data
                                self.updateContactUS()
                            }
                        }
                    }
                }
            case .error(let error):
                print(error!)
            }
        }
    }
    func updateContactUS() {
        if let workingDays = self.contactUsDict["workingDays"] as? String {
            self.lblTimeings.text = workingDays
        }
        if let workingHours = self.contactUsDict["workingHours"] as? String {
            var holeValue : String = self.lblTimeings.text ?? ""
            holeValue.append("\n")
            holeValue.append(workingHours)
            self.lblTimeings.text = holeValue
        }
        if let phoneNo = self.contactUsDict["phoneNo"] as? String {
            self.btnPhone.setTitle(" \(phoneNo)", for: .normal)
        }
       //nnn
    }
    func listOfLoication() {
        var simpleDataArray = [String]()
        let simpleSelectedArray = [String]()
        for ids in self.itemArray {
            if let data  = ids as? LocationInformation {
                simpleDataArray.append(data.storeName)
            }
        }
        let selectionMenu = RSSelectionMenu(dataSource: simpleDataArray) { (cell, item, indexPath) in
            cell.textLabel?.text = item
        }
        
        selectionMenu.maxSelectionLimit = 1
        selectionMenu.setSelectedItems(items: simpleSelectedArray) { [weak self] (item, index, isSelected, selectedItems) in

            print(selectedItems)
            print(index)
            self?.addAnnotations(witIndex: index)
        }        // show as alert
        selectionMenu.show(style: .alert(title: "Select Location", action: nil, height: nil), from: self)
//        selectionMenu.show(style: .push, from: self)
    }
}

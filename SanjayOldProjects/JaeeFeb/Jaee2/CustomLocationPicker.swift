//
//  CustomLocationPicker.swift
//  Jaee2
//
//  Created by Abdulaziz  Almohsen on 8/22/17.
//  Copyright © 2017 Jaee. All rights reserved.
//

import UIKit
import LocationPickerViewController

class CustomLocationPicker: LocationPicker {
    
    var viewController: PickLocationViewController!
    
    override func viewDidLoad() {
        super.addBarButtons()
        super.viewDidLoad()
    }
    
    override func locationDidSelect(locationItem: LocationItem) {
        let locationPicker = LocationPicker()
       
        
        print("Select overrided method: " + locationItem.name)
    }
    
   
    
}

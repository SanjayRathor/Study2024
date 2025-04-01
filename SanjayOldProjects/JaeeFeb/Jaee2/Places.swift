//
//  Places.swift
//  Jaee2
//
//  Created by Abdulaziz  Almohsen on 7/12/17.
//  Copyright © 2017 Jaee. All rights reserved.
//

import Foundation
import MapKit

@objc class Place: NSObject {
    
    dynamic var coordinate : CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        
        self.coordinate = coordinate
    }
  
}

extension Place: MKAnnotation { }

//
//  LocationPermission.swift
//  Jaee2
//
//  Created by Abdulaziz  Almohsen on 7/17/17.
//  Copyright © 2017 Jaee. All rights reserved.
//

//import Foundation
//import CoreLocation
//import Permission
//
//internal extension Permission {
//    var statusLocationWhenInUse: PermissionStatus {
//        guard CLLocationManager.locationServicesEnabled() else { return .disabled }
//        
//        let status = CLLocationManager.authorizationStatus()
//        
//        switch status {
//        case .authorizedWhenInUse, .authorizedAlways: return .authorized
//        case .restricted, .denied:                    return .denied
//        case .notDetermined:                          return .notDetermined
//        }
//    }
//    
//    func requestLocationWhenInUse(_ callback: Callback) {
//        guard let _ = Foundation.Bundle.main.object(forInfoDictionaryKey: .locationWhenInUseUsageDescription) else {
//            print("WARNING: \(String.locationWhenInUseUsageDescription) not found in Info.plist")
//            return
//        }
//        
//        LocationManager.request(self)
//    }
//}

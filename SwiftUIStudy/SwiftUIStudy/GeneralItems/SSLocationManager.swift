//
//  SSLocationManager.swift
//  SwiftUIStudy
//
//  Created by Sanjay Rathor on 11/02/25.
//

import UIKit
import CoreLocation

//@Observable
//class LocationManager: NSObject, CLLocationManagerDelegate {
//    var locationContinuation:
//    CheckedContinuation<CLLocationCoordinate2D?, any Error>?
//    let manager = CLLocationManager()
//    
//    override init() {
//        super.init()
//        manager.delegate = self
//    }
//    
//    @MainActor
//    func requestLocation() async throws -> CLLocationCoordinate2D? {
//        try await withCheckedThrowingContinuation { continuation in
//            locationContinuation = continuation
//            manager.requestLocation()
//        }
//    }
//    
//    func locationManager(_ manager: CLLocationManager,
//                         didUpdateLocations locations: [CLLocation]) {
//        locationContinuation?.resume(returning:
//                                        locations.first?.coordinate)
//    }
//    
//    func locationManager(_ manager: CLLocationManager,
//                         didFailWithError error: any Error) {
//        locationContinuation?.resume(throwing: error)
//    }
//}

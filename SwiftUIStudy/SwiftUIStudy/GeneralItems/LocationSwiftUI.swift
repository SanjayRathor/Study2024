//
//  LocationSwiftUI.swift
//  SwiftUIStudy
//
//  Created by Sanjay Rathor on 11/02/25.
//

import SwiftUI
import CoreLocation
/*
@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {
    var locationContinuation:
    CheckedContinuation<CLLocationCoordinate2D?, any Error>?
    let manager = CLLocationManager()
    override init() {
        super.init()
        manager.delegate = self
    }
    @MainActor
    func requestLocation() async throws ->
    CLLocationCoordinate2D? {
        try await withCheckedThrowingContinuation { continuation in
            locationContinuation = continuation
            manager.requestLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        locationContinuation?.resume(returning:
                                        locations.first?.coordinate)
    }
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: any Error) {
        locationContinuation?.resume(throwing: error)
    }
}
struct LocationContentView: View {
    @State private var locationManager = LocationManager()
    var body: some View {
        
        Button("Tap Me") {
            Task {
                if let location = try? await
                    locationManager.requestLocation() {
                    print("Location: \(location)")
                } else {
                    print("Location unknown.")
                }
            }
        }
        .frame(height: 44)
        .foregroundStyle(.black)
        .clipShape(.capsule)
        .padding()
    }
}



#Preview {
    LocationContentView()
}
*/

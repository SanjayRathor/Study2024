//
//  MapView.swift
//  StudySwiftUI
//
//  Created by Sanjay Rathor on 13/03/25.
//

import SwiftUI
import CoreLocation
import MapKit

struct MapView: View {
    var location: String = ""
    @State private var region: MKCoordinateRegion =
    MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.510357, longitude: -0.116773), span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0))
    
    var body: some View {
        Map(initialPosition: .region(region))
    }
}
#Preview {
    MapView()
}

/*
 NavigationStack {
 List {
 .
 .
 .
 }
 .listStyle(.plain)
 .navigationTitle("FoodPin")
 .navigationBarTitleDisplayMode(.automatic)
 }
 */

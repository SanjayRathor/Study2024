//
//  SwiftUICompleteApp.swift
//  SwiftUIComplete
//
//  Created by Sanjay Singh Rathor on 17/11/20.
//

import SwiftUI

@main
struct SwiftUICompleteApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(User())
        }
    }
}

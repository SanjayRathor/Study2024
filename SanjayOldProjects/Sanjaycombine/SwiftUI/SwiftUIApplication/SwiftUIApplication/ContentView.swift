//
//  ContentView.swift
//  SwiftUIApplication
//
//  Created by Sanjay Singh Rathor on 10/11/20.
//

import SwiftUI

struct ContentView: View {
    @State var isOnState = false
    @ObservedObject var abd = LoginViewModel()
    var body: some View {
        VStack {
            LoginView()
            
        /*
             ToggleView(isOnButtton: $isOnState)
             Text(isOnState ? "HELLO" : "FELLO")
            .padding()
        }*/
      }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

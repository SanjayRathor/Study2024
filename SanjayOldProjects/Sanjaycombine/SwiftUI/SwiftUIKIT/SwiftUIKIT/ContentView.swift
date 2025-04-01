//
//  ContentView.swift
//  SwitUIApp
//
//  Created by Sanjay Singh Rathor on 21/10/20.
//  Copyright © 2020 Timesinternet ltd. All rights reserved.
//

import SwiftUI

struct PrimaryLabel: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.red)
            .foregroundColor(Color.white)
            .font(.largeTitle)
    }
}

//In SwiftUI, when a @State variable changes, the view invalidates its appearance and recomputes the body.

struct ContentView: View {
    @State var value = 1.0
    @ObservedObject var timer = TimeCounter()

    var body: some View {
        Text(String(timer.counter))
    }
}

/*
 struct ContentView : View {
 @State var alertIsVisible: Bool = false
 var body: some View {
 VStack {
 Text("Welcome to my first app!")
 .alert(isPresented: self.$alertIsVisible) {
 Alert(title: Text("Hello there!"),
 message: Text("This is my first pop-up."),
 dismissButton: .default(Text("Awesome!")))
 }
 Button(action: {
 print("Button pressed!")
 self.alertIsVisible = true
 })
 {
 Text("Hit me!")
 }
 
 }
 }
 }
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

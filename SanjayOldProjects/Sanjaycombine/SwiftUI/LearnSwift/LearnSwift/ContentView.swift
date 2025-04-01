//
//  ContentView.swift
//  LearnSwift
//
//  Created by Sanjay Singh Rathor on 23/01/21.
//

import SwiftUI

struct ContentView: View {
    @State private var rotation: Double = 0
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.blue)
                .frame(width: 200, height: 200) .rotationEffect(.degrees(rotation)) .animation(.linear)
            Button(action: {
                rotation = (rotation < 360 ? rotation + 60 : 0)
            }) {
                Text("Rotate") }
        } .padding(10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

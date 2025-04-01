//
//  ContentView.swift
//  SwiftUIEmptyView
//
//  Created by Sanjay Singh Rathor on 01/11/20.
//  Copyright © 2020 Timesinternet ltd. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
      Image(systemName: "table")
        .resizable()
        .frame(width: 60, height: 60, alignment: .center) .border(Color.gray, width: 1)
        .cornerRadius(60 / 2)
        .background(Color(white: 0.9)) .clipShape(Circle())
        .foregroundColor(.red)
        Text("Welcome to Kuchi") .font(.system(size: 60))
        .bold()
        .foregroundColor(.red) .lineLimit(2) .multilineTextAlignment(.leading)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

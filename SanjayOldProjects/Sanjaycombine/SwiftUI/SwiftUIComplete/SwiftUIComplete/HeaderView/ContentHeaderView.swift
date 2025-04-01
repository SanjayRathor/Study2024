//
//  ContentHeaderView.swift
//  SwiftUIComplete
//
//  Created by Sanjay Singh Rathor on 18/11/20.
//

import SwiftUI

struct ContentHeaderView: View {

    var title:String
    var body: some View {
        VStack {
            ZStack {
                Text(title)
                    .font(.title)
                    .foregroundColor(.white)
                Image("Surf Board")
                    .resizable()
                    .scaledToFit()
                Text(" Hut Pizza")
                    .font(.title)
                    .foregroundColor(.white)

            }
            PageTitleView()
        }
    }
}

struct ContentHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ContentHeaderView(title: "PIZZA")
    }
}
